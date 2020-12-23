//
//  UINavigationController+YXAdd.h
//  CaiYunXiaoKa
//
//  Created by zx on 2020/1/6.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (YXAdd)

- (void)yx_pushViewController:(UIViewController *)controller;

- (UIViewController *)yx_popViewController;

/** 用于适配iOS14调用该方法TabBar被隐藏问题 */
- (NSArray<__kindof UIViewController *> *)yx_popToRootViewControllerAnimated:(BOOL)animated;

/** 用于适配iOS14调用该方法TabBar被隐藏问题 */
- (NSArray<__kindof UIViewController *> *)yx_popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
