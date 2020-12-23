//
//  YXBaseTabBarController.m
//  CaiYunXiaoKa
//
//  Created by zx on 2019/12/29.
//  Copyright © 2019 zhxin. All rights reserved.
//

#import "YXBaseTabBarController.h"
#import "YXBaseNavController.h"

@interface YXBaseTabBarController ()

@property (nonatomic, strong) NSArray *items; /**< 每个tabBarItem属性数组*/

@end

@implementation YXBaseTabBarController

- (instancetype)initWithItems:(NSArray *)items  {
    if (self = [super init]) {
        self.items = items;
        [self removeTabarTopLine];
        [self setViewControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillLayoutSubviews {
    float height = 50;
    CGRect tabFrame = self.tabBar.frame;
    
    tabFrame.size.height = height;
    tabFrame.origin.y = self.view.frame.size.height - height;
    self.tabBar.frame = tabFrame;
}

/** 根据数据源初始化UI */
- (void)setViewControllers {
    // UITabBarController 数据源
    NSArray *dataAry = self.items;
    
    for (NSDictionary *dataDic in dataAry) {
        // 每个tabar的数据
        UIViewController *vc = dataDic[@"class"];
        NSString *title = dataDic[@"title"];
        NSString *imageName = dataDic[@"image"];
        NSString *selectedImage = dataDic[@"selectedImage"];
        
        [self addChildViewController:[self itemChildViewController:vc title:title imageName:imageName selectedImage:selectedImage]];
    }
}

- (UINavigationController *)itemChildViewController:(UIViewController *)viewcontroller title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage {
    
    UIViewController *vc = viewcontroller;
    
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    // title设置
    [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    vc.tabBarItem.title = title;
    
    // 导航
    YXBaseNavController *nav = [[YXBaseNavController alloc] initWithRootViewController:vc];
    
    nav.navigationBar.topItem.title = title;
    [nav addChildViewController:vc];
    return nav;
}

#pragma 设置小红点数值
// 设置指定tabar 小红点的值
- (void)setBadgeValue:(NSString *)badgeValue index:(NSInteger)index {
    if (index + 1 > self.viewControllers.count || index < 0) {
        // 越界或者数据异常直接返回
        return;
    }
    YXBaseNavController *base = self.viewControllers[index];
    
    if (base.viewControllers.count == 0) {
        return;
    }
    UIViewController *vc = base.viewControllers[0];
    
    vc.tabBarItem.badgeValue = badgeValue.intValue > 0 ? badgeValue : nil;
}

#pragma mark - 去掉tabBar顶部线条

// 去掉tabBar顶部线条
- (void)removeTabarTopLine {
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
}

@end
