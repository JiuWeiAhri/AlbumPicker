//
//  UINavigationController+YXAdd.m
//  CaiYunXiaoKa
//
//  Created by zx on 2020/1/6.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "UINavigationController+YXAdd.h"

@implementation UINavigationController (YXAdd)

- (void)yx_pushViewController:(UIViewController *)controller {
    [self pushViewController:controller animated:YES];
}

- (UIViewController *)yx_popViewController {
    return [self popViewControllerAnimated:YES];
}

/** 用于适配iOS14调用该方法TabBar被隐藏问题 */
- (NSArray<__kindof UIViewController *> *)yx_popToRootViewControllerAnimated:(BOOL)animated {
    for (int i = 0; i < self.viewControllers.count; i++) {
        UIViewController *vc = self.viewControllers[i];
        vc.hidesBottomBarWhenPushed = i == 0 ? (vc.hidesBottomBarWhenPushed) : NO;
    }
    return [self popToRootViewControllerAnimated:animated];
}

/** 用于适配iOS14调用该方法TabBar被隐藏问题 */
- (NSArray<__kindof UIViewController *> *)yx_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    /** 容错处理，pop一个不存在的vc，默认返回上一级 */
    if (![self.viewControllers containsObject:viewController]) {
        if (self.viewControllers.count > 1) {
            [self popToViewController:self.viewControllers[self.viewControllers.count - 2] animated:YES];
        } else {
            [self popToViewController:self.viewControllers.lastObject animated:YES];
        }
    }
    
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    for (NSInteger i = index; i < (self.viewControllers.count - index); i++) {
        UIViewController *vc = self.viewControllers[i];
        vc.hidesBottomBarWhenPushed = i == 0 ? (vc.hidesBottomBarWhenPushed) : NO;
    }
    return [self popToViewController:viewController animated:animated];
}

@end
