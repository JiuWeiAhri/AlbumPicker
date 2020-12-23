//
//  UIScrollView+YXRefresh.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (YXRefresh)

@property (nonatomic, copy) void (^yx_headerRefresh)(void); /**< 下拉刷新 */
@property (nonatomic, copy) void (^yx_footerRefresh)(void); /**< 上拉刷新 */
@property (nonatomic, assign, readonly) BOOL yx_isRefreshing; /**< 上拉刷新 */
@property (nonatomic, assign) BOOL yx_hideHeaderRefresh; /**< 是否隐藏下拉刷新，默认NO */
@property (nonatomic, assign) BOOL yx_hideFooterRefresh; /**< 是否隐藏上拉加载更多，默认NO */

/**
 开始下拉刷新
 */
- (void)yx_beginRefreshing;

/**
 结束刷新
 */
- (void)yx_endRefreshing;

/**
 结束刷新，且没有更多数据
 */
- (void)yx_endRefreshingWithNoMoreData;

@end

NS_ASSUME_NONNULL_END
