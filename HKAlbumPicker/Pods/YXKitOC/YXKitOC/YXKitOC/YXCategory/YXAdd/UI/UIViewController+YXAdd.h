//
//  UIViewController+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YXAdd)

/// 获取当前正在显示的UIViewController
+ (UIViewController *)yx_currentVC;

/// 获取当前正在显示的UINavigationController
+ (UINavigationController *)yx_currentNav;

/// 获取当前正在显示的UITabBarController
+ (UITabBarController *)yx_currentTab;

@end

NS_ASSUME_NONNULL_END
