//
//  BaseVC.m
//  CaiYunXiaoKa
//
//  Created by zx on 2019/12/29.
//  Copyright © 2019 zhxin. All rights reserved.
//

#import "YXBaseVC.h"
#import "YXKitOC.h"
#import "YXBaseNavController.h"

@implementation YXBaseVCConfig

YX_ShareInstance_m(YXBaseVCConfig)

@end

@interface YXBaseVC ()

@end

@implementation YXBaseVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    // 设置返回按钮UI
    if (self.navigationController.viewControllers.count > 1) {
        
        if (YXBaseVCConfig.sharedYXBaseVCConfig.navBackImage || YXBaseVCConfig.sharedYXBaseVCConfig.navBackTitle) {
            // 显示深色箭头和文字
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            [button setImage:YXBaseVCConfig.sharedYXBaseVCConfig.navBackImage forState:0];
            
            // 没有文字时调整内部图片边距
            if (YXBaseVCConfig.sharedYXBaseVCConfig.navBackTitle) {
                [button setTitle:YXBaseVCConfig.sharedYXBaseVCConfig.navBackTitle forState:0];
                [button setTitleColor:YXBaseVCConfig.sharedYXBaseVCConfig.navBackTitleColor ? : YX_BlackColor() forState:0];
                button.titleLabel.font = YXBaseVCConfig.sharedYXBaseVCConfig.navBackTitleFont ? : YX_Font18();
                [button yx_layoutImageToLeft:4];
            } else {
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, -42, 0, 0)];
            }
            UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = barItem;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    DLog(@"\n✅✅✅  %@ 已显示", NSStringFromClass([self class]));
}

- (void)dealloc {
    DLog(@"\n❌❌❌  %@ 已释放", NSStringFromClass([self class]));
}

#pragma mark - Public Func

/** 设置导航条右侧按钮的文字 */
- (void)yx_setRightBarButtonItemTitle:(NSString *)title handler:(void (^)(id sender))block {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] yx_initWithTitle:title style:UIBarButtonItemStylePlain handler:block];
    
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - Private Func

/** 返回按钮点击事件 */
- (void)backAction {
    [self.navigationController yx_popViewController];
}

/** 设置导航条右侧按钮 */
- (void)setupRightButtonWithItems:(NSArray *)buttonArray {
    self.navigationItem.rightBarButtonItems = buttonArray;
}

/** 设置导航条标题 */
- (void)setNavigationTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.backgroundColor = YX_ClearColor();
    titleLabel.font = font;
    titleLabel.textColor = color;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    self.navigationItem.titleView = titleLabel;
}

@end
