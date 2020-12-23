//
//  UIView+Layer.m
//  YXKitDemo
//
//  Created by zx on 2018/3/14.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#import "UIView+YXLayer.h"

@implementation UIView (YXLayer)

// layer properties set & get method
- (void)setYx_cornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = !!cornerRadius;
}

- (CGFloat)yx_cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setYx_borderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)yx_borderWidth
{
    return self.layer.borderWidth;
}

- (void)setYx_borderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)yx_borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setYx_shadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}

- (UIColor *)yx_shadowColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setYx_shadowOpacity:(float)shadowOpacity
{
    self.layer.shadowOpacity = shadowOpacity;
}

- (float)yx_shadowOpacity
{
    return self.layer.shadowOpacity;
}

- (void)setYx_shadowOffset:(CGSize)shadowOffset
{
    self.layer.shadowOffset = shadowOffset;
}

- (CGSize)yx_shadowOffset
{
    return self.layer.shadowOffset;
}

- (void)setYx_shadowRadius:(CGFloat)shadowRadius
{
    self.layer.shadowRadius = shadowRadius;
}

- (CGFloat)yx_shadowRadius
{
    return self.layer.shadowRadius;
}

- (void)setYx_onePixHeight:(BOOL)onePixHeight{
    if (onePixHeight) {
        CGRect rect = self.frame;
        rect.size.height = 1.0 / [UIScreen mainScreen].scale;
        self.frame = rect;
    }
}

- (BOOL)yx_onePixHeight{
    return self.yx_onePixHeight;
}

- (void)setYx_onePixWidth:(BOOL)onePixWidth {
    if (onePixWidth) {
        CGRect rect = self.frame;
        rect.size.width = 1.0 / [UIScreen mainScreen].scale;
        self.frame = rect;
    }
}

- (BOOL)yx_onePixWidth {
    return self.yx_onePixWidth;
}

@end
