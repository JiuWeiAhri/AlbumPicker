//
//  YXCollectionView.m
//  Ebook
//
//  Created by zx on 2017/5/14.
//  Copyright © 2017年 without_bug. All rights reserved.
//

#import "YXCollectionView.h"
#import <MJRefresh/MJRefresh.h>
#import "YXNoDataView.h"
#import <Masonry/Masonry.h>
#import "YXEqualCellSpaceFlowLayout.h"
#import "YXColor.h"
#import "UIView+YXAdd.h"
#import "YXDefineHeader.h"
#import "YXFont.h"

#define KNotificationKey_NeedRefreshTableViewWhenNextShow      @"KNotificationKey_NeedRefreshTableViewWhenNextShow" // 下一次显示时需要刷新列表

@implementation YXCollectionViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumVerticalSpacing = self.minimumHorizontalSpacing = 10;
    }
    return self;
}

@end

@interface YXCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSInteger _pageIndex;
    NSInteger _pageSize;
    BOOL _needRefreshWhenNextShow;
}

@property (nonatomic, strong) NSMutableArray *listArray; /**< 列表数据源 */
@property (nonatomic, strong) UICollectionView *collectionView; /**< 列表 */
@property (nonatomic, strong) MJRefreshNormalHeader *header; /**< 下拉刷新 */
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) YXNoDataView *noDataView; /**< 无数据提示 */
@property (nonatomic, strong) UIView *messageView; /**< 消息提示 */
@property (nonatomic, strong) UILabel *messageLabel; /**< 提示消息 */
@property (nonatomic, strong) YXCollectionViewConfig *config; /**< 配置 */

@end

@implementation YXCollectionView

- (instancetype)initWithFrame:(CGRect)frame config:(YXCollectionViewConfig *)config
{
    self = [super initWithFrame:frame];
    if (self) {
        self.config = config;
        _enableRefresh = _enableLoadMore = YES;
        [self configView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.config) {
            YXCollectionViewConfig *config = [[YXCollectionViewConfig alloc] init];
            config.minimumHorizontalSpacing = 15;
            self.config = config;
            [self configView];
        }
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationKey_NeedRefreshTableViewWhenNextShow object:nil];
}

- (void)configView {
    
    [[NSNotificationCenter defaultCenter] addObserverForName:KNotificationKey_NeedRefreshTableViewWhenNextShow object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self->_needRefreshWhenNextShow = YES;
    }];
    _pageSize = 20;
    _pageIndex = 1;
    self.isShowMessage = YES;
    [self addSubview:self.collectionView];
    if (self.enableRefresh) {
        self.collectionView.mj_header = self.header;
    }
    
    [self addSubview:self.messageView];
    self.backgroundColor = YX_ClearColor();
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - Private Func

- (void)showMessage:(NSString *)message {
    [self showMessage:message show:YES];
}

- (void)showMessage:(NSString *)message show:(BOOL)show {
    
    if (!self.isShowMessage) {
        return;
    }
    
    CGFloat marginY = (self.yx_currentVC.automaticallyAdjustsScrollViewInsets) ? 64 : 0;
    
    self.messageView.hidden = NO;
    self.messageView.minY_yx = (show ? -self.messageView.height_yx : 0.) + marginY;
    self.messageView.width_yx = self.messageLabel.width_yx = self.collectionView.width_yx;
    self.messageLabel.text = message;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.messageView.minY_yx = (show ? 0. : -self.messageView.height_yx) + marginY;
        
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
    
    /** 有下拉刷新（网络数据），设置的总个数小于等于当前总个数时加载完毕，无下拉刷新时（本地数据）当前页个数小于每页设定个数时加载完毕 */
    BOOL isNoMoreData = self.enableLoadMore ? (self.allCount <= self.listArray.count) : (array.count < _pageSize);
    
    if (isNoMoreData) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.collectionView.mj_footer endRefreshing];
    }
    
    /** 没有数据且内容不够滑动时，隐藏footer */
    self.collectionView.mj_footer.hidden = (isNoMoreData && (self.collectionView.contentSize.height < self.height_yx)) || self.listArray.count == 0;
}

#pragma mark - Public Func

- (void)refreshWhenNextShowIfNeed {
    if (_needRefreshWhenNextShow) {
        [self refresh];
        _needRefreshWhenNextShow = NO;
    }
}

- (void)refresh {
    [self.header beginRefreshing];
}

- (void)reloadData {
    YX_WeakSelf
    self.dataBlock(NSNotFound, NSNotFound, ^(NSError *error, NSArray *array) {
        YX_StrongSelf
        [self.listArray removeAllObjects];
        [self.listArray addObjectsFromArray:array];
        [self.collectionView reloadData];
        // 更新footer状态
        [self reloadFooterStatus:array];
        self.noDataView.hidden = self.listArray.count > 0;
        self.noDataView.type = YXNoDataViewTypeNoData;
        /** 无数据显示隐藏状态代理 */
        if ([self.delegate respondsToSelector:@selector(yxCollectionView:collectionView:didChangedNoDataViewHiddenStatus:)]) {
            [self.delegate yxCollectionView:self collectionView:self.collectionView didChangedNoDataViewHiddenStatus:array.count > 0];
        }
    });
}

- (void)reloadDataNoBlock {
    [self.collectionView reloadData];
    self.noDataView.hidden = self.listArray.count > 0;
    self.noDataView.type = YXNoDataViewTypeNoData;
    /** 无数据即将展示 */
    if ([self.delegate respondsToSelector:@selector(yxCollectionView:collectionView:didChangedNoDataViewHiddenStatus:)]) {
        [self.delegate yxCollectionView:self collectionView:self.collectionView didChangedNoDataViewHiddenStatus:self.listArray.count > 0];
    }
}

- (void)registCells:(NSArray *)classes returnClass:(YXCReturnLoadClassBlock)classBlock loadCell:(YXCLoadCellBlock)loadBlock returnSize:(YXCReturnSizeBlock)sizeBlock didSelected:(YXCDidSelectedBlock)selectedBlock loadData:(YXCLoadDataBlock)dataBlock {
    
    for (Class class in classes) {
        NSString *className = [NSStringFromClass(class) componentsSeparatedByString:@"."].lastObject;
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
        if (nibPath) {
            [self.collectionView registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:className];
        } else {
            [self.collectionView registerClass:class forCellWithReuseIdentifier:className];
        }
    }
    
    self.classBlock = classBlock;
    self.loadBlock = loadBlock;
    self.sizeBlock = sizeBlock;
    self.selectedBlock = selectedBlock;
    self.dataBlock = dataBlock;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = nil;
    
    if (self.classBlock) {
        Class class = self.classBlock(collectionView, indexPath, self.listArray[indexPath.row]);
        NSString *className = [NSStringFromClass(class) componentsSeparatedByString:@"."].lastObject;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
        
        if (self.loadBlock) {
            self.loadBlock(collectionView, cell, indexPath, self.listArray[indexPath.row]);
        }
    }
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.config.minimumVerticalSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.config.minimumHorizontalSpacing;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedBlock) {
        self.selectedBlock(collectionView, indexPath, self.listArray[indexPath.row]);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = self.sizeBlock(collectionView, indexPath, self.listArray[indexPath.row]);
    return size;
}

#pragma mark - Getter

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = nil;
        if (self.config.collectionAlignmentMode != YXCollectionAlignmentMode_None) {
            layout = [[YXEqualCellSpaceFlowLayout alloc] initWthType:self.config.collectionAlignmentMode];
            ((YXEqualCellSpaceFlowLayout *)layout).betweenOfCell = self.config.minimumHorizontalSpacing;
        } else {
            layout = [[UICollectionViewFlowLayout alloc] init];
        }
        
        layout.scrollDirection = self.config.scrollDirectionMode == ScrollDirectionMode_Horizontal ?  UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.backgroundColor = YX_ClearColor();
    }
    return _collectionView;
}

- (MJRefreshNormalHeader *)header {
    
    if (!_header) {
        YX_WeakSelf
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            YX_StrongSelf
            self->_pageIndex = 1;
            
            if (weakSelf.dataBlock) {
                weakSelf.dataBlock(self->_pageIndex, self->_pageSize, ^(NSError *error, NSArray *array) {
                    
                    if (error) {
                        [weakSelf showMessage:error.domain];
                        if (weakSelf.listArray.count == 0) {
                            [weakSelf reloadFooterStatus:array];
                            weakSelf.noDataView.type = (error.code == -1004 || error.code == -1011) ? YXNoDataViewTypeNoService : YXNoDataViewTypeNoNet;
                            weakSelf.noDataView.hidden = weakSelf.listArray.count > 0;
                            /** 无数据显示隐藏状态代理 */
                            if ([weakSelf.delegate respondsToSelector:@selector(yxCollectionView:collectionView:didChangedNoDataViewHiddenStatus:)]) {
                                [weakSelf.delegate yxCollectionView:weakSelf collectionView:weakSelf.collectionView didChangedNoDataViewHiddenStatus:NO];
                            }
                        }
                    } else {
                        [weakSelf.listArray removeAllObjects];
                        [weakSelf.listArray addObjectsFromArray:array];
                        [weakSelf.collectionView reloadData];
                        [weakSelf reloadFooterStatus:array];
                        weakSelf.noDataView.type = YXNoDataViewTypeNoData;
                        weakSelf.noDataView.hidden = weakSelf.listArray.count > 0;
                        /** 无数据显示隐藏状态代理 */
                        if ([weakSelf.delegate respondsToSelector:@selector(yxCollectionView:collectionView:didChangedNoDataViewHiddenStatus:)]) {
                            [weakSelf.delegate yxCollectionView:weakSelf collectionView:weakSelf.collectionView didChangedNoDataViewHiddenStatus:array.count > 0];
                        }
                    }
                    
                    [self->_header endRefreshing];
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
            [self loadNextPage];
        }];
        _footer.hidden = YES;
        _footer.stateLabel.textColor = YX_LightGrayColor();
        _footer.stateLabel.font = [UIFont systemFontOfSize:13];
        [_footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    }
    
    return _footer;
}

- (void)loadNextPage {
    _pageIndex++;
    
    if (self.dataBlock) {
        self.dataBlock(self->_pageIndex, self->_pageSize, ^(NSError *error, NSArray *array) {
            
            if (error) {
                [self showMessage:error.domain];
            } else {
                [self.listArray addObjectsFromArray:array];
                [self.collectionView reloadData];
            }
            
            /// 刷新底部加载更多的状态
            [self reloadFooterStatus:array];
        });
    }
}

- (YXNoDataView *)noDataView {
    
    if (!_noDataView) {
        _noDataView = [[YXNoDataView alloc] init];
        [self.collectionView addSubview:_noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.width.height.equalTo(self.collectionView);
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
        _messageLabel.textColor = YX_WhiteColor();
        _messageLabel.font = YX_Font13();
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

#pragma mark - Setter

- (void)setEnableRefresh:(BOOL)enableRefresh {
    _enableRefresh = enableRefresh;
    if (!_collectionView) {
        return;
    }
    
    if (enableRefresh && _collectionView) {
        self.collectionView.mj_header = self.header;
    } else {
        self.collectionView.mj_header = nil;
    }
}

- (void)setEnableLoadMore:(BOOL)enableLoadMore {
    _enableLoadMore = enableLoadMore;
    if (!_collectionView) {
        return;
    }
    
    if (enableLoadMore) {
        self.collectionView.mj_footer = self.footer;
    } else {
        self.collectionView.mj_footer = nil;
    }
}

- (void)setCollectionViewInsets:(UIEdgeInsets)collectionViewInsets {
    _collectionViewInsets = collectionViewInsets;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(collectionViewInsets);
    }];
    [self layoutIfNeeded];
}

- (void)setScrollContentInsets:(UIEdgeInsets)scrollContentInsets {
    _scrollContentInsets = scrollContentInsets;
    self.collectionView.contentInset = scrollContentInsets;
    self.collectionView.scrollIndicatorInsets = scrollContentInsets;
}

- (void)setTapGesBlock:(void (^)(void))tapGesBlock {
    _tapGesBlock = tapGesBlock;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.cancelsTouchesInView = NO;
    [self.collectionView addGestureRecognizer:tapGes];
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)tapGesAction {
    if (self.tapGesBlock) {
        self.tapGesBlock();
    }
}

@end
