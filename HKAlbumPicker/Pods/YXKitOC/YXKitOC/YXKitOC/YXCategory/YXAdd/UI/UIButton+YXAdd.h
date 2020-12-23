//
//  UIButton+YXFunc.h
//  CaiYunXiaoKa
//
//  Created by zx on 2020/1/4.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YXAdd)

#pragma mark - Creat

+ (instancetype)yx_creatWithMinX:(CGFloat)x minY:(CGFloat)y
                           image:(nullable UIImage *)image
                           block:(nullable void (^)(id sender))block;

+ (instancetype)yx_creatWithMinX:(CGFloat)x minY:(CGFloat)y
                           title:(nullable NSString *)title fontSize:(CGFloat)size titleColor:(nullable UIColor *)color
                           block:(nullable void (^)(id sender))block;

+ (instancetype)yx_creatWithFrame:(CGRect)frame
                            title:(nullable NSString *)title fontSize:(CGFloat)size titleColor:(nullable UIColor *)titleColor
                            image:(nullable UIImage *)image
                            block:(nullable void (^)(id sender))block;

#pragma mark - Add

/// 设置图片在顶部
- (void)yx_layoutImageToTop:(CGFloat)spacing;

/// 设置图片在l左边
- (void)yx_layoutImageToLeft:(CGFloat)spacing;

/// 设置图片在底部
- (void)yx_layoutImageToBottom:(CGFloat)spacing;

/// 设置图片在右面
- (void)yx_layoutImageToRight:(CGFloat)spacing;

/// 设置背景色
- (void)yx_setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
