//
//  BaseVC.h
//  CaiYunXiaoKa
//
//  Created by zx on 2019/12/29.
//  Copyright © 2019 zhxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXBaseVCConfig : NSObject

@property (nonatomic, strong) UIImage *navBackImage; /**< 导航栏返回按钮 */
@property (nonatomic, copy) NSString *navBackTitle; /**< 导航栏返回文字 */
@property (nonatomic, strong) UIColor *navBackTitleColor; /**< 导航栏返回文字颜色，默认黑色 */
@property (nonatomic, strong) UIFont *navBackTitleFont; /**< 导航栏返回文字字体，默认18 */

YX_ShareInstance_h(YXBaseVCConfig)

@end

@interface YXBaseVC : UIViewController

/** 默认返回上一级菜单 可以重写 */
- (void)backAction;

/** 设置导航条右侧按钮 */
- (void)setupRightButtonWithItems:(NSArray *)buttonArray;

/** 自定义导航栏标题 */
- (void)setNavigationTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color;

/** 设置导航条右侧按钮的文字 */
- (void)yx_setRightBarButtonItemTitle:(NSString *)title handler:(void (^)(id sender))block;

@end

NS_ASSUME_NONNULL_END
