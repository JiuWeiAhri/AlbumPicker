//
//  UILabel+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (YXAdd)

+ (instancetype)creatWithMinX:(CGFloat)x minY:(CGFloat)y title:(NSString *)title;
+ (instancetype)creatWithMinX:(CGFloat)x minY:(CGFloat)y title:(NSString *)title fontSize:(CGFloat)size;
+ (instancetype)creatWithMinX:(CGFloat)x minY:(CGFloat)y title:(NSString *)title fontSize:(CGFloat)size color:(nullable UIColor *)color;
+ (instancetype)creatWithMinX:(CGFloat)x minY:(CGFloat)y title:(NSString *)title fontSize:(CGFloat)size color:(nullable UIColor *)color textAlignment:(NSTextAlignment)alignment;
+ (instancetype)creatWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)size color:(nullable UIColor *)color textAlignment:(NSTextAlignment)alignment;

#pragma mark - YXAdd

/** 设置行间距(设置label.text后调用) */
- (void)yx_setLineSpacing:(CGFloat)lineSpacing;

/** 设置行间距(设置label.text后调用) */
- (void)yx_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;

/// 添加删除线
- (void)yx_setStrikethrough;

/// 添加下划线
- (void)yx_setUnderline;

/// 设置部分文字颜色
- (void)yx_setTextColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
