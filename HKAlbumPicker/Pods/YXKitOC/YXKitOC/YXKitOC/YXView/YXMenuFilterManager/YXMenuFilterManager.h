//
//  YXMenuFilterManager.h
//  YXKitOC
//
//  Created by 李鹏飞 on 2020/4/3.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+YXFilterObject.h"
#import "NSMutableArray+YXFilterObject.h"
#import "YXMenuFilterCustomViewProtocol.h"
#import "YXMenuFilterConfig.h"

@class YXMenuFilterManager;

NS_ASSUME_NONNULL_BEGIN

@protocol YXMenuFilterManagerDataSource <NSObject>

@required

/// 设置筛选项标题
/// @param menuFilterManager 筛选管理器
- (NSArray *)titlesOfFilterInYXMenuFilterManager:(YXMenuFilterManager *)menuFilterManager;

/// 设置筛选项内容
/// @param menuFilterManager 筛选管理器
/// @param index 筛选项索引
- (UIView<YXMenuFilterCustomViewProtocol> *)viewOfFilterInYXMenuFilterManager:(YXMenuFilterManager *)menuFilterManager index:(NSInteger)index;

@end


@protocol YXMenuFilterManagerDelegate <NSObject>

@optional

/// 高度发生变化，列表frame需要刷新
- (void)menuFilterManager:(YXMenuFilterManager *)menuFilterManager filtersShowViewHeightDidUpdate:(CGFloat)filtersShowViewHeight;

@required

/// 已选择数据
/// @param menuFilterManager 筛选管理器
/// @param objects 当前被改变的选项
/// @param filterPage 已选择数据所在视图
/// @param filterPageIndex 已选择数据所在视图的索引
- (void)menuFilterManager:(YXMenuFilterManager *)menuFilterManager didSelectedFilterObjects:(NSArray<YXFilterObject *> *)objects filterPage:(UIView *)filterPage filterPageIndex:(NSInteger)filterPageIndex;

@end


@interface YXMenuFilterManager : NSObject

- (instancetype)initWithFrame:(CGRect)frame showInView:(UIView *)superView;

@property (nonatomic, weak) id<YXMenuFilterManagerDataSource> dataSource;
@property (nonatomic, weak) id<YXMenuFilterManagerDelegate> delegate;
@property (nonatomic, assign) CGFloat filterBarHeight; /**< 筛选条和已筛选按钮整体高度 */
@property (nonatomic, assign, readonly) CGFloat customViewHeight; /**< 自定义视图高度 */
@property (nonatomic, assign, readonly) CGRect customViewFrame; /**< 自定义视图Frame */
@property (nonatomic, strong) YXMenuFilterConfig *config; /**< 自定义配置信息 */

/** 刷新 */
- (void)reloadData;

/** 关闭 */
- (void)close;

@end

NS_ASSUME_NONNULL_END
