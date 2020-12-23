//
//  YXCollectionView.h
//  Ebook
//
//  Created by zx on 2017/5/14.
//  Copyright © 2017年 without_bug. All rights reserved.
//  --快速集成下拉刷新，上拉加载更多，支持自动显示无数据提示，支持XibCell和ClassCell
//  --不支持多个Section，如果想实现header，footer，需要自定义cell去实现

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXCollectionAlignmentMode) {
    YXCollectionAlignmentMode_None,
    YXCollectionAlignmentMode_Left,
    YXCollectionAlignmentMode_Center,
    YXCollectionAlignmentMode_Right,
};

typedef NS_ENUM(NSUInteger, ScrollDirectionMode) {
    ScrollDirectionMode_Vertical,
    ScrollDirectionMode_Horizontal,
};

@class YXCollectionView;

typedef void (^YXCStatusBlock)(NSError * _Nullable error, NSArray * _Nullable array);
typedef Class _Nonnull (^YXCReturnLoadClassBlock)(UICollectionView *tableView, NSIndexPath *indexPath, id cellData);
typedef void (^YXCLoadCellBlock)(UICollectionView *tableView, id loadCell, NSIndexPath *indexPath, id cellData);
typedef CGSize (^YXCReturnSizeBlock)(UICollectionView *tableView, NSIndexPath *indexPath, id cellData);
typedef void (^YXCDidSelectedBlock)(UICollectionView *tableView, NSIndexPath *indexPath, id cellData);
typedef void (^YXCLoadDataBlock)(NSInteger pageIndex, NSInteger pageSize, YXCStatusBlock statusBlock);

@interface YXCollectionViewConfig : NSObject

@property (nonatomic, assign) CGFloat minimumHorizontalSpacing; /**< 横向最小间距 */
@property (nonatomic, assign) CGFloat minimumVerticalSpacing; /**< 纵向最小间距 */
@property (nonatomic, assign) YXCollectionAlignmentMode collectionAlignmentMode; /**< 对齐方式，默认None */
@property (nonatomic, assign) ScrollDirectionMode scrollDirectionMode; /**< 滑动方向，默认竖直方向 */

@end

@protocol YXCollectionViewDelegate <NSObject>

/** 无数据页面隐藏或展示*/
- (void)yxCollectionView:(YXCollectionView *)yxCollectionView collectionView:(UICollectionView *)collectionView didChangedNoDataViewHiddenStatus:(BOOL)isHidden;

@end

@interface YXCollectionView : UIView

@property (nonatomic, assign) BOOL enableRefresh; /**< 是否支持下拉刷新 */
@property (nonatomic, assign) BOOL enableLoadMore; /**< 是否支持加载更多 */

@property (nonatomic, weak) id<YXCollectionViewDelegate> delegate;


@property (nonatomic, copy) YXCLoadDataBlock dataBlock; /**< 获取数据 */
@property (nonatomic, copy) YXCLoadCellBlock loadBlock; /**< cell重用 */
@property (nonatomic, copy) YXCReturnLoadClassBlock classBlock; /**< cell重用 */
@property (nonatomic, copy) YXCDidSelectedBlock selectedBlock; /**< 选择cell */
@property (nonatomic, copy) YXCReturnSizeBlock sizeBlock; /**< cell高度 */
@property (nonatomic, strong, readonly) UICollectionView *collectionView; /**< collectionView */
@property (nonatomic, assign) UIEdgeInsets collectionViewInsets; /**< collection偏移量 */
@property (nonatomic, assign) UIEdgeInsets scrollContentInsets; /**< scrollContent偏移量 */
@property (nonatomic, strong, readonly) NSMutableArray *listArray; /**< 列表数据源 */
@property (nonatomic, assign) BOOL isShowMessage; /**< 是否显示错误消息 */
@property (nonatomic, assign, readonly) NSInteger pageIndex; /**< 第N页 */
@property (nonatomic, assign, readonly) NSInteger pageSize; /**< 每页多少个数据 */
@property (nonatomic, assign) NSInteger allCount; /**< 列表个数总和 */

@property (nonatomic, copy) void(^tapGesBlock)(void); /**< 单机手势回调，用于隐藏键盘等操作 */

/// 唯一初始化方法
- (instancetype)initWithFrame:(CGRect)frame config:(YXCollectionViewConfig *)config;

- (void)refreshWhenNextShowIfNeed;
- (void)refresh;
- (void)reloadData;
- (void)reloadDataNoBlock;
- (void)registCells:(NSArray *)classes returnClass:(YXCReturnLoadClassBlock)classBlock loadCell:(YXCLoadCellBlock)loadBlock returnSize:(YXCReturnSizeBlock)sizeBlock didSelected:(YXCDidSelectedBlock)selectedBlock loadData:(YXCLoadDataBlock)dataBlock;
- (void)loadNextPage:(void(^)(void))didLoadSuccessBlock;

@end

NS_ASSUME_NONNULL_END
