//
//  UIViewController+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "UIViewController+YXAdd.h"

@implementation UIViewController (YXAdd)

/// 获取当前正在显示的UIViewController
+ (UIViewController *)yx_currentVC {
    UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    return [UIViewController findBestViewController:viewController];
}

/// 获取当前正在显示的UINavigationController
+ (UINavigationController *)yx_currentNav {
    return [self yx_currentVC].navigationController;
}

/// 获取当前正在显示的UITabBarController
+ (UITabBarController *)yx_currentTab {
    return [self yx_currentVC].tabBarController;
}

#pragma mark - Private Func

+ (UIViewController *)findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        return [UIViewController findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        UISplitViewController *svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else {
            UITabBarController *tab = [[UIApplication sharedApplication].delegate window].rootViewController;
            if ([tab isKindOfClass:UITabBarController.class] &&
                tab.moreNavigationController &&
                tab.selectedViewController == svc &&
                tab.selectedIndex >= 4) {
                return [UIViewController findBestViewController:tab.moreNavigationController.topViewController];
            } else
                return vc;
        }
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        return vc;
    }
}

@end
