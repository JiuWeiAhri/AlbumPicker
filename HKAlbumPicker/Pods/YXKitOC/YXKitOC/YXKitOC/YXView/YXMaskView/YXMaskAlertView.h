//
//  CustomAlertView.h
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/2/3.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXMaskAlertViewShowType) {
    YXMaskAlertViewShowType_ActionSheet, /**< 从下往上 */
    YXMaskAlertViewShowType_Alert, /**< 中间 */
};

@interface YXMaskAlertView : UIView

@property (nonatomic, strong) UIView *contentView; /**< 内容视图 */
@property (nonatomic, assign) YXMaskAlertViewShowType showType; /**< 显示方式 */
@property (nonatomic, assign) BOOL isCloseWhenClickBackground; /**< 是否点击背景层关闭提示框 */

+ (instancetype)showWithContentView:(UIView *)contentView showType:(YXMaskAlertViewShowType)showType;

+ (instancetype)showWithContentView:(UIView *)contentView showType:(YXMaskAlertViewShowType)showType showInVC:(UIViewController *)showInVC;

- (void)close;

/** 自定义视图高度变化后刷新Frame */
- (void)reloadContentViewSize;

@end

NS_ASSUME_NONNULL_END
