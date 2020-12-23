//
//  yxTableView.m
//  Ebook
//
//  Created by zx on 2017/4/23.
//  Copyright © 2017年 without_bug. All rights reserved.
//

#import "YXTableView.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "UIView+YXFrame.h"
#import "UIView+YXAdd.h"
#import "UIViewController+YXAdd.h"
#import "YXInline.h"
#import "YXDefineHeader.h"
#import "YXFont.h"
#import "YXColor.h"

static NSInteger pageStartIndex = 1;

@interface YXTableView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

@property (nonatomic, strong) MJRefreshNormalHeader *header; /**< 下拉刷新 */
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) YXNoDataView *noDataView; /**< 无数据提示 */
@property (nonatomic, strong) UIView *messageView; /**< 消息提示 */
@property (nonatomic, strong) UILabel *messageLabel; /**< 提示消息 */
@property (nonatomic, strong) UITableView *tableView; /**< 列表 */

@property (nonatomic, strong) NSMutableArray *listArray; /**< 数据源 */

@end

@implementation YXTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView {
    
    self.layer.masksToBounds = YES;
    _pageSize = 15;
    _pageIndex = pageStartIndex;
    
    self.enableRefresh = YES;
    self.enableLoadMore = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.tableView];
    [self addSubview:self.messageView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Public Func

/** 如果是Xib页面的View设置Headre头，调用这个方法，防止header头高度获取不到 */
- (void)setXibHeaderView:(UIView *)xibView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    [view addSubview:xibView];
    [xibView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
    }];
    [view layoutIfNeeded];
    view.height = xibView.height;
    self.tableView.tableHeaderView = view;
    
    /** 修改无数据位置 */
    [self.noDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(view.height));
        make.left.equalTo(@0);
        make.height.equalTo(@(self.height - view.height));
        make.width.equalTo(self.tableView);
    }];
}

/** 如果是Xib页面的View设置Footer头，调用这个方法，防止Footer头高度获取不到 */
- (void)setXibHFooterView:(UIView *)xibView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    [view addSubview:xibView];
    [xibView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
    }];
    [view layoutIfNeeded];
    view.height = xibView.height;
    self.tableView.tableFooterView = view;
}

/** 带下拉加载头，用于加载网络数据 */
- (void)refresh {
    [self.header beginRefreshing];
}

/** 不带下拉加载头，用于加载本地数据 */
- (void)reloadData {
    self.dataBlock(NSNotFound, NSNotFound, ^(NSError *error, NSArray *array) {
        [self.listArray removeAllObjects];
        [self.listArray addObjectsFromArray:array];
        [self.tableView reloadData];
        /// 刷新无数据显示隐藏状态
        [self resetNoDataViewAndReloadHiddenStatus];
        /** 无数据即将展示 */
        if ([self.delegate respondsToSelector:@selector(yxTableView:tableView:didChangedNoDataViewHiddenStatus:)]) {
            [self.delegate yxTableView:self tableView:self.tableView didChangedNoDataViewHiddenStatus:array.count > 0];
        }
        // 更新footer状态
        [self reloadFooterStatus:array];
    });
}

/** 仅刷新tableView，提示无数据，数据源不重新处理 */
- (void)reloadDataNoBlock {
    [self.tableView reloadData];
    /// 刷新无数据显示隐藏状态
    [self resetNoDataViewAndReloadHiddenStatus];
    /** 无数据即将展示 */
    if ([self.delegate respondsToSelector:@selector(yxTableView:tableView:didChangedNoDataViewHiddenStatus:)]) {
        [self.delegate yxTableView:self tableView:self.tableView didChangedNoDataViewHiddenStatus:self.listArray.count > 0];
    }
}

/** 注册cell */
- (void)registCells:(NSArray<Class> *)classes returnClass:(YXReturnLoadClassBlock)classBlock loadCell:(YXLoadCellBlock)loadBlock returnHeight:(YXReturnHeightBlock)heightBlock didSelected:(YXDidSelectedBlock)selectedBlock loadData:(YXLoadDataBlock)dataBlock {
    
    for (Class class in classes) {
        NSString *className = [NSStringFromClass(class) componentsSeparatedByString:@"."].lastObject;
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
        if (nibPath) {
            [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
        } else {
            [self.tableView registerClass:class forCellReuseIdentifier:className];
        }
    }
    
    self.classBlock = classBlock;
    self.loadBlock = loadBlock;
    self.heightBlock = heightBlock;
    self.selectedBlock = selectedBlock;
    self.dataBlock = dataBlock;
}

#pragma mark - Private Func

- (void)showMessage:(NSString *)message {
    [self showMessage:message show:YES];
}

- (void)showMessage:(NSString *)message show:(BOOL)show {
    
    CGFloat marginY = (self.yx_currentVC.automaticallyAdjustsScrollViewInsets) ? 64 : 0;
    
    self.messageView.hidden = NO;
    self.messageView.minY = (show ? -self.messageView.height : 0.) + marginY;
    self.messageView.width = self.messageLabel.width = self.tableView.width;
    self.messageLabel.text = message;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.messageView.minY = (show ? 0. : -self.messageView.height) + marginY;
        
    } completion:^(BOOL finished) {
        if (show) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showMessage:message show:NO];
            });
        } else {
            self.messageView.hidden = YES;
        }
    }];
}

/** 刷新底部加载更多的状态 */
- (void)reloadFooterStatus:(NSArray *)array {
    
    if (!self.enableLoadMore) {
        return;
    }
    
    /** 有上拉加载更多刷新（网络数据），设置的总个数小于等于当前总个数时加载完毕，无下拉刷新时（本地数据）当前页个数小于每页设定个数时加载完毕 */
    BOOL isNoMoreData = self.enableLoadMore ? (self.allCount <= self.listArray.count) : (array.count < _pageSize);
    
    if (isNoMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    
    /** 没有数据且内容不够滑动时，隐藏footer */
    self.tableView.mj_footer.hidden = (isNoMoreData && (self.tableView.contentSize.height < self.height)) || self.listArray.count == 0;
}

/** 重置为无数据状态，并判断隐藏状态 */
- (void)resetNoDataViewAndReloadHiddenStatus {
    self.noDataView.type = YXNoDataViewTypeNoData;
    self.noDataView.hidden = self.listArray.count > 0;
    self.noDataView.image = YXNoDataViewConfig.sharedYXNoDataViewConfig.noDataImage;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isGroupedStyle ? self.listArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isGroupedStyle ? 1 : self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (self.classBlock) {
        Class class = self.classBlock(tableView, indexPath, self.listArray[self.isGroupedStyle ? indexPath.section : indexPath.row]);
        NSString *className = [NSStringFromClass(class) componentsSeparatedByString:@"."].lastObject;
        cell = [tableView dequeueReusableCellWithIdentifier:className forIndexPath:indexPath];
        
        if (self.loadBlock) {
            self.loadBlock(tableView, cell, indexPath, self.listArray[self.isGroupedStyle ? indexPath.section : indexPath.row]);
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.;
    if (self.isDynamicCellHeight) {
        height = UITableViewAutomaticDimension;
    } else if (self.heightBlock) {
        height = self.heightBlock(tableView, indexPath, self.listArray[self.isGroupedStyle ? indexPath.section : indexPath.row]);
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    if (self.selectedBlock) {
        self.selectedBlock(tableView, indexPath, self.listArray[self.isGroupedStyle ? indexPath.section : indexPath.row]);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.enableDelete ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.handleWillDeletedBlock) {
            self.handleWillDeletedBlock(indexPath.row);
        }
        [self.listArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

/** 分组显示 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isGroupedStyle) {
        if (indexPath.row == 0) {
            [cell yx_addCorner:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:10];
        }
        
        NSInteger count = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        if (indexPath.row == (count - 1)) {
            if (indexPath.row == 0) {
                [cell yx_addCorner:UIRectCornerAllCorners cornerRadius:10];
            } else {
                [cell yx_addCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadius:10];
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(yxTableView:tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate yxTableView:self tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

/** cell已显示 */
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([self.delegate respondsToSelector:@selector(yxTableView:tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [self.delegate yxTableView:self tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.handleHeightForHeaderInSectionBlock && (self.listArray.count > section)) {
        return self.handleHeightForHeaderInSectionBlock(self, section, self.listArray[section]);
    }
    return self.isGroupedStyle ? 20 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.handleViewForHeaderInSectionBlock && (self.listArray.count > section)) {
        return self.handleViewForHeaderInSectionBlock(self, section, self.listArray[section]);
    }
    return self.isGroupedStyle ? [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.isGroupedStyle ? [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0)] : nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(yxTableView:scrollViewDidScroll:)]) {
        [self.delegate yxTableView:self scrollViewDidScroll:self.tableView];
    }
}

#pragma mark - Getter

- (NSMutableArray *)listArray {
    
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    
    return _listArray;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorColor = YX_LineColor();
        [_tableView setRowHeight:100.];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    
    return _tableView;
}

/** 处理加载的信息 */
- (void)handleDataBlockWithError:(NSError *)error array:(NSArray *)array {
    
    /** 请求出错 */
    if (error) {
        [self showMessage:error.domain];
        
        if (self.listArray.count == 0) {
            /// 刷新无数据显示隐藏状态
            [self resetNoDataViewAndReloadHiddenStatus];
            if (error.code == -1004 || error.code == -1011) {
                self.noDataView.type = YXNoDataViewTypeNoService;
            } else {
                self.noDataView.type = YXNoDataViewTypeNoNet;
            }
            /** 无数据即将展示 */
            if ([self.delegate respondsToSelector:@selector(yxTableView:tableView:didChangedNoDataViewHiddenStatus:)]) {
                [self.delegate yxTableView:self tableView:self.tableView didChangedNoDataViewHiddenStatus:NO];
            }
        }
    }
    /** 拿到请求数据 */
    else {
        [self.listArray removeAllObjects];
        [self.listArray addObjectsFromArray:array];
        [self.tableView reloadData];
        /// 刷新无数据显示隐藏状态
        [self resetNoDataViewAndReloadHiddenStatus];
        /** 无数据即将展示 */
        if ([self.delegate respondsToSelector:@selector(yxTableView:tableView:didChangedNoDataViewHiddenStatus:)]) {
            [self.delegate yxTableView:self tableView:self.tableView didChangedNoDataViewHiddenStatus:array.count > 0];
        }
        
        // 更新footer状态
        [self reloadFooterStatus:array];
    }
    
    [self->_header endRefreshing];
}

- (MJRefreshNormalHeader *)header {
    
    if (!_header) {
        YX_WeakSelf
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            YX_StrongSelf
            self->_pageIndex = pageStartIndex;
            
            if (self.dataBlock) {
                self.dataBlock(self->_pageIndex, self->_pageSize, ^(NSError *error, NSArray *array) {
                    [self handleDataBlockWithError:error array:array];
                });
            }
        }];
        
        [_header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [_header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
        [_header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
        _header.lastUpdatedTimeLabel.hidden = YES;
        _header.automaticallyChangeAlpha = YES;
    }
    
    return _header;
}

- (MJRefreshAutoNormalFooter *)footer {
    
    if (!_footer) {
        YX_WeakSelf
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            YX_StrongSelf
            
            self->_pageIndex++;
            
            if (self.dataBlock) {
                self.dataBlock(self->_pageIndex, self->_pageSize, ^(NSError *error, NSArray *array) {
                    
                    if (error) {
                        [self showMessage:error.domain];
                    } else {
                        [self.listArray addObjectsFromArray:array];
                        [self.tableView reloadData];
                    }
                    
                    if (self.enableLoadMore && !self.tableView.mj_footer) {
                        self.tableView.mj_footer = self.footer;
                    }
                    
                    [weakSelf reloadFooterStatus:array];
                });
            }
            
        }];
        _footer.hidden = YES;
        _footer.stateLabel.textColor = YX_LightGrayColor();
        _footer.stateLabel.font = [UIFont systemFontOfSize:13];
        [_footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    }
    
    return _footer;
}

- (YXNoDataView *)noDataView {
    
    if (!_noDataView) {
        _noDataView = [[YXNoDataView alloc] init];
        [self.tableView addSubview:_noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.width.height.equalTo(self.tableView);
        }];
    }
    
    return _noDataView;
}

- (UIView *)messageView {
    if (!_messageView) {
        _messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30.)];
        _messageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _messageView.hidden = YES;
        
        self.messageLabel.frame = _messageView.bounds;
        [_messageView addSubview:self.messageLabel];
    }
    return _messageView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = YX_Font13();
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

#pragma mark - Setter

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    self.tableView.tableHeaderView = headerView;
}

- (void)setEnableRefresh:(BOOL)enableRefresh {
    _enableRefresh = enableRefresh;
    
    if (enableRefresh) {
        self.tableView.mj_header = self.header;
    } else {
        self.tableView.mj_header = nil;
    }
}

- (void)setEnableLoadMore:(BOOL)enableLoadMore {
    _enableLoadMore = enableLoadMore;
    
    if (enableLoadMore) {
        self.tableView.mj_footer = self.footer;
    } else {
        self.tableView.mj_footer = nil;
    }
}

- (void)setAllCount:(NSInteger)allCount {
    _allCount = allCount;
}

- (void)setIsGroupedStyle:(BOOL)isGroupedStyle {
    _isGroupedStyle = isGroupedStyle;
    self.backgroundColor = self.tableView.backgroundColor = isGroupedStyle ? YX_GroupTableViewBackgroundColor() : YX_WhiteColor();
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, isGroupedStyle ? 20 : 0, 0, isGroupedStyle ? 20 : 0));
    }];
}

- (void)setEnableMultipleSelection:(BOOL)enableMultipleSelection {
    self.tableView.allowsMultipleSelection = enableMultipleSelection;
}

- (void)setIsDynamicCellHeight:(BOOL)isDynamicCellHeight {
    _isDynamicCellHeight = isDynamicCellHeight;
    _tableView.estimatedRowHeight = 60.f;
}

@end
