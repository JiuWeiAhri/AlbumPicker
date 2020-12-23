//
//  YXMenuFilterManager.m
//  YXKitOC
//
//  Created by 李鹏飞 on 2020/4/3.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXMenuFilterManager.h"
#import "YXFiltersShowView.h"
#import "YXPullDownMenuView.h"
#import "YXKitOC.h"

@interface YXMenuFilterManager () <YXPullDownMenuViewDataSource, YXFiltersShowViewDelegate, YXMenuFilterDelegate>

@property (nonatomic, strong) YXPullDownMenuView *filterBar; /**< 筛选条 */
@property (nonatomic, strong) YXFiltersShowView *filtersShowView; /**< 历史筛选条 */
@property (nonatomic, assign) CGRect frame; /**< 不算导航栏不算tabbar的frame */
@property (nonatomic, strong) NSMutableArray<YXFilterObject *> *selectedFilterObjects; /**< 已选筛选项 */

@end

@implementation YXMenuFilterManager

- (instancetype)initWithFrame:(CGRect)frame showInView:(UIView *)superView
{
    self = [super init];
    if (self) {
        self.frame = frame;
        [superView addSubview:self.filterBar];
        [superView addSubview:self.filtersShowView];
        self.filterBarHeight = self.filterBar.height + self.filtersShowView.height;
    }
    return self;
}

#pragma mark - Public Func

- (void)reloadData {
    if ([self.dataSource respondsToSelector:@selector(titlesOfFilterInYXMenuFilterManager:)]) {
        self.filterBar.titles = [self.dataSource titlesOfFilterInYXMenuFilterManager:self];
    } else {
        self.filterBar.titles = @[];
    }
}

/** 关闭 */
- (void)close {
    [self.filterBar finished];
}

/** 刷新指定页的FilterButtonObject按钮数据源 */
- (void)reloadFiltersShowViewData {
    
    [self.filtersShowView.listArray removeAllObjects];
    
    for (YXFilterObject *object in self.selectedFilterObjects) {
        NSMutableArray *buttonObjects = [NSMutableArray array];
        for (int i = 0; i < object.titles.count; i++) {
            NSString *title = object.titles[i];
            NSString *value = object.values[i];
            YXFilterButtonObject *buttonObject = [[YXFilterButtonObject alloc] init];
            buttonObject.filterPageIndex = object.filterPageIndex;
            buttonObject.key = object.key;
            buttonObject.relationKeys = object.relationKeys;
            buttonObject.title = title;
            buttonObject.value = value;
            buttonObject.isDefault = object.isDefault;
            [buttonObjects addObject:buttonObject];
        }
        [self.filtersShowView mergeFilterObjects:buttonObjects];
    }
    
    [self.filtersShowView reloadData];
}

/** 删除指定页指定key的筛选项 */
- (void)removeFilterObjectWithPageIndex:(NSInteger)pageIndex key:(NSString *)key {
    
    for (YXFilterObject *temp1_object in self.selectedFilterObjects.copy) {
        if (temp1_object.filterPageIndex == pageIndex && [key isEqualToString:temp1_object.key]) {
            
            /** 移除关联项 */
            for (YXFilterObject *temp2_object in self.selectedFilterObjects.copy) {
                if ([temp1_object.relationKeys containsObject:temp2_object.key]) {
                    [self.selectedFilterObjects removeObject:temp2_object];
                }
            }
            /** 移除该项 */
            [self.selectedFilterObjects removeObject:temp1_object];
        }
    }
}

/** 筛选指定页面的已选数据集合 */
- (NSArray *)filterObjectsAtPageIndex:(NSInteger)pageIndex {
    return [self.selectedFilterObjects yx_select:^BOOL(YXFilterObject *  _Nonnull obj) {
        return obj.filterPageIndex == pageIndex;
    }];
}

#pragma mark - YXPullDownMenuDataSource

- (UIView *)itemViewForPullDownMenu:(YXPullDownMenuView *)pullDownMenu menuIndex:(NSInteger)menuIndex {

    UIView<YXMenuFilterCustomViewProtocol> *customView = [self.dataSource viewOfFilterInYXMenuFilterManager:self index:menuIndex];
    customView.pageIndex = menuIndex;
    customView.menuFilterDelegate = self;
    /// 更改自定义视图的MinY以适应已选筛选项条高度变化
    customView.minY = CGRectGetMinY(self.frame) + self.filterBar.height;
    customView.height = self.customViewHeight;
    /// 刷新页面，更新已选项UI
    if ([customView respondsToSelector:@selector(reloadData)]) {
        customView.selectedFilterObjects = [self.selectedFilterObjects filterObjectsAtPageIndex:menuIndex];
        [customView reloadData];
    } else {
        NSString *str = [NSString stringWithFormat:@"%@未实现YXMenuFilterCustomViewProtocol协议的reloadData方法", NSStringFromClass([customView class])];
        DLog(@"%@", str);
    }
    
    return customView;
}

#pragma mark - YXFiltersShowViewDelegate

/// 点击已选筛选条件，执行清除
- (void)filterDidSelectedAtIndex:(NSInteger)index {
    
    /** 移除选中YXFilterObject，及其关联项 */
    YXFilterButtonObject *object = [self.filtersShowView.listArray objectAtIndex:index];
    NSString *removeKey = object.key;
    NSInteger removeIndex = object.filterPageIndex;
    [self removeFilterObjectWithPageIndex:removeIndex key:removeKey];
    
    /** 刷新FilterShowView */
    [self reloadFiltersShowViewData];
    
    /** 动态更新高度 */
    self.filterBarHeight = self.filterBar.height + self.filtersShowView.height;
    if ([self.delegate respondsToSelector:@selector(menuFilterManager:filtersShowViewHeightDidUpdate:)]) {
        [self.delegate menuFilterManager:self filtersShowViewHeightDidUpdate:self.filterBarHeight];
    }
    
    /** 抛出筛选结果 */
    if ([self.delegate respondsToSelector:@selector(menuFilterManager:didSelectedFilterObjects:filterPage:filterPageIndex:)]) {
        UIView *cunstomView = [self.dataSource viewOfFilterInYXMenuFilterManager:self index:object.filterPageIndex];
        [self.delegate menuFilterManager:self didSelectedFilterObjects:[self filterObjectsAtPageIndex:object.filterPageIndex] filterPage:cunstomView filterPageIndex:object.filterPageIndex];
    }
}

- (void)filterScrollViewClearSelected:(YXFiltersShowView *)filterView {
    
}

#pragma mark - YXMenuFilterCustomViewProtocol

/// 得到筛选数据
- (void)filterPage:(UIView<YXMenuFilterCustomViewProtocol> *)filterPage didSelectedObjects:(NSArray<YXFilterObject *> *)filterObjects {
    
    /** 更新已选筛选项数据，展开customView时需要给出当前已选数据源 */
    [self.selectedFilterObjects removeFilterObjectsAtPageIndex:filterPage.pageIndex];
    [self.selectedFilterObjects addObjectsFromArray:filterObjects];
    
    /** 刷新已选按钮UI */
    [self reloadFiltersShowViewData];
    
    /// 更新高度
    self.filterBarHeight = self.filterBar.frame.size.height + (self.filtersShowView.listArray.count > 0 ? self.filtersShowView.frame.size.height : 0);
    if ([self.delegate respondsToSelector:@selector(menuFilterManager:filtersShowViewHeightDidUpdate:)]) {
        [self.delegate menuFilterManager:self filtersShowViewHeightDidUpdate:self.filterBarHeight];
    }
    
    /// 回调筛选结果
    if ([self.delegate respondsToSelector:@selector(menuFilterManager:didSelectedFilterObjects:filterPage:filterPageIndex:)]) {
        [self.delegate menuFilterManager:self didSelectedFilterObjects:filterObjects filterPage:filterPage filterPageIndex:filterPage.pageIndex];
    }
    
    /// 关闭筛选视图
    [self.filterBar finished];
}

/// 筛选视图关闭
- (void)didCloseOfContentFilterView:(UIView *)contentView {
    [self.filterBar finished];
}

#pragma mark - Getter

- (YXPullDownMenuView *)filterBar {
    if (!_filterBar) {
        _filterBar = [[YXPullDownMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.frame), YX_ScreenW(), 44)];
        _filterBar.selectedColor = self.config.selectedTextColor;
        _filterBar.normalColor = self.config.normalTextColor;
        _filterBar.dataSource = self;
    }
    return _filterBar;
}

- (YXFiltersShowView *)filtersShowView {
    if (!_filtersShowView) {
        _filtersShowView = [[YXFiltersShowView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.filterBar.frame), YX_ScreenW(), 0)];
        _filtersShowView.delegate = self;
    }
    return _filtersShowView;
}

- (CGFloat)customViewHeight {
    return self.frame.size.height - self.filterBar.height;
}

- (NSMutableArray<YXFilterObject *> *)selectedFilterObjects {
    if (!_selectedFilterObjects) {
        _selectedFilterObjects = [NSMutableArray array];
    }
    return _selectedFilterObjects;;
}

- (CGRect)customViewFrame {
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.filterBar.height);
}

- (YXMenuFilterConfig *)config {
    if (!_config) {
        _config = [YXMenuFilterConfig sharedYXMenuFilterConfig];
    }
    return _config;
}

@end

