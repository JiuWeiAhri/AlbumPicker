//
//  yxTableView.h
//  Ebook
//
//  Created by zx on 2017/4/23.
//  Copyright © 2017年 without_bug. All rights reserved.
//  -UITableView的Block版本
//  --快速集成下拉刷新，上拉加载更多，支持自动显示无数据提示，支持XibCell和ClassCell
//  --不支持多个Section，如果想实现header，footer，需要自定义cell去实现

#import <UIKit/UIKit.h>
#import "YXNoDataView.h"

NS_ASSUME_NONNULL_BEGIN

@class YXTableView;

typedef void (^YXStatusBlock)(NSError * _Nullable error, NSArray * _Nullable array);
typedef Class _Nonnull (^YXReturnLoadClassBlock)(UITableView *tableView, NSIndexPath *indexPath, id cellData);
typedef void (^YXLoadCellBlock)(UITableView *tableView, id loadCell, NSIndexPath *indexPath, id cellData);
typedef CGFloat (^YXReturnHeightBlock)(UITableView *tableView, NSIndexPath *indexPath, id cellData);
typedef void (^YXDidSelectedBlock)(UITableView *tableView, NSIndexPath *indexPath, id cellData);
typedef void (^YXLoadDataBlock)(NSInteger pageIndex, NSInteger pageSize, YXStatusBlock statusBlock);

@protocol YXTableViewDelegate <NSObject>

@optional

/** 列表滑动代理 */
- (void)yxTableView:(YXTableView *)yxTableView scrollViewDidScroll:(UITableView *)tableView;

/** Celli将要显示代理 */
- (void)yxTableView:(YXTableView *)yxTableView tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath;

/** Cell已显示代理 */
- (void)yxTableView:(YXTableView *)yxTableView tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath;

/** 无数据页面隐藏或展示*/
- (void)yxTableView:(YXTableView *)yxTableView tableView:(UITableView *)tableView didChangedNoDataViewHiddenStatus:(BOOL)isHidden;

@end

@interface YXTableView : UIView

/** data */
@property (nonatomic, strong, readonly) NSMutableArray *listArray; /**< 数据源 */

/** function */
@property (nonatomic, assign) NSInteger allCount; /**< 共多少个cell，由网络获取 */
@property (nonatomic, assign) BOOL enableRefresh; /**< 是否支持下拉刷新 */
@property (nonatomic, assign) BOOL enableLoadMore; /**< 是否支持加载更多 */
@property (nonatomic, assign) BOOL enableDelete; /**< 是否有删除功能，默认NO */
@property (nonatomic, assign) BOOL enableMultipleSelection; /**< 是否开启多选 */
@property (nonatomic, assign) BOOL isGroupedStyle; /**< 是否分组样式 */
@property (nonatomic, assign) BOOL isDynamicCellHeight; /**< 是否动态计算cell高度（使用此方法应给TableView设置estimatedRowHeight属性，否则iOS9、10可能出现问题） */

/** block */
@property (nonatomic, copy) YXReturnLoadClassBlock classBlock; /**< cell重用 */
@property (nonatomic, copy) YXLoadCellBlock loadBlock; /**< cell重用 */
@property (nonatomic, copy) YXReturnHeightBlock heightBlock; /**< cell高度 */
@property (nonatomic, copy) YXDidSelectedBlock selectedBlock; /**< 选择cell */
@property (nonatomic, copy) YXLoadDataBlock dataBlock; /**< 获取数据 */
@property (nonatomic, copy) CGFloat (^handleHeightForHeaderInSectionBlock)(YXTableView *yxTableView, NSUInteger section, id cellData); /**< 设置Header高度Block */
@property (nonatomic, copy) UIView * (^handleViewForHeaderInSectionBlock)(YXTableView *yxTableView, NSUInteger section, id cellData); /**< 设置HeaderViewBlock */
@property (nonatomic, copy) void (^handleWillDeletedBlock)(NSInteger index); /**< 将要删除Block */

/** delegate */
@property (nonatomic, weak) id<YXTableViewDelegate> delegate;

/** view */
@property (nonatomic, strong) UIView *headerView; /**< 头 */
@property (nonatomic, strong, readonly) UITableView *tableView; /**< 列表 */
@property (nonatomic, strong, readonly) YXNoDataView *noDataView; /**< 无数据提示 */

/// 如果是Xib页面的View设置Headre头，调用这个方法，防止header头高度获取不到
- (void)setXibHeaderView:(UIView *)xibView;

/// 如果是Xib页面的View设置Footer头，调用这个方法，防止Footer头高度获取不到
- (void)setXibHFooterView:(UIView *)xibView;

/** 带下拉加载头，用于加载网络数据 */
- (void)refresh;

/** 不带下拉加载头，用于加载本地数据 */
- (void)reloadData;

/** 仅刷新tableView，提示无数据，数据源不重新处理 */
- (void)reloadDataNoBlock;

- (void)registCells:(NSArray<Class> *)classes returnClass:(YXReturnLoadClassBlock)classBlock loadCell:(YXLoadCellBlock)loadBlock returnHeight:(YXReturnHeightBlock)heightBlock didSelected:(YXDidSelectedBlock)selectedBlock loadData:(YXLoadDataBlock)dataBlock;

@end

NS_ASSUME_NONNULL_END
