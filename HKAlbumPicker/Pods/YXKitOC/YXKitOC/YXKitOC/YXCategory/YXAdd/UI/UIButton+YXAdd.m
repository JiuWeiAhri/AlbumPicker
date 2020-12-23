//
//  UIButton+YXFunc.m
//  CaiYunXiaoKa
//
//  Created by zx on 2020/1/4.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "UIButton+YXAdd.h"
#import "UIView+YXAdd.h"
#import "UIControl+YXAdd.h"
#import "YXColor.h"
#import "UIImage+YXAdd.h"

@implementation UIButton (YXAdd)

#pragma mark - Creat

//+ (instancetype)yx_creatWithMinX:(CGFloat)x minY:(CGFloat)y image:(UIImage *)image {
//    UIButton *btn = [[UIButton alloc] init];
//    btn.origin_yx = CGPointMake(x, y);
//    [btn setImage:image forState:0];
//    btn.yx_size = image.size;
//    return btn;
//}
//
//+ (instancetype)yx_creatWithMinX:(CGFloat)x minY:(CGFloat)y
//                           title:(UIImage *)title fontSize:(CGFloat)size titleColor:(UIColor *)color
//                           image:(UIImage *)image
//                           block:(void (^)(id sender))block {
//    UIButton *btn = [[UIButton alloc] init];
//    btn.origin_yx = CGPointMake(x, y);
//    [btn setImage:image forState:0];
//    btn.yx_size = image.size;
//    return btn;
//}

+ (instancetype)yx_creatWithMinX:(CGFloat)x minY:(CGFloat)y
                           image:(nullable UIImage *)image
                           block:(nullable void (^)(id sender))block {
    UIButton *btn = [self yx_creatWithFrame:CGRectMake(x, y, 0, 0) title:nil fontSize:0 titleColor:nil image:image block:block];
    btn.size_yx = image.size;
    return btn;
}

+ (instancetype)yx_creatWithMinX:(CGFloat)x minY:(CGFloat)y
                           title:(nullable NSString *)title fontSize:(CGFloat)size titleColor:(nullable UIColor *)titleColor
                           block:(nullable void (^)(id sender))block {
    UIButton *btn = [self yx_creatWithFrame:CGRectMake(x, y, 0, 0) title:title fontSize:size titleColor:titleColor image:nil block:block];
    [btn.titleLabel sizeToFit];
    btn.size_yx = btn.titleLabel.size_yx;
    return btn;
}

+ (instancetype)yx_creatWithFrame:(CGRect)frame
                            title:(nullable NSString *)title fontSize:(CGFloat)size titleColor:(nullable UIColor *)titleColor
                            image:(nullable UIImage *)image
                            block:(nullable void (^)(id sender))block {
    UIButton *btn = [[self alloc] initWithFrame:frame];
    [btn setTitle:title forState:0];
    [btn setTitleColor:titleColor ? : YX_DarkTextColor() forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    [btn setImage:image forState:0];
    [btn yx_addEventBlock:block forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - YXAdd

- (void)yx_layoutImageToTop:(CGFloat)spacing {
    CGSize imageViewSize = self.imageView.frame.size;
    CGSize titleLabelSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleLabelSize.width + 0.5 < frameSize.width) {
        titleLabelSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageViewSize.height + titleLabelSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageViewSize.height), 0.0, 0.0, - titleLabelSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageViewSize.width, - (totalHeight - titleLabelSize.height), 0);
}

- (void)yx_layoutImageToLeft:(CGFloat)spacing {
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -spacing);
}

- (void)yx_layoutImageToBottom:(CGFloat)spacing {
    CGSize imageViewSize = self.imageView.frame.size;
    CGSize titleLabelSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleLabelSize.width + 0.5 < frameSize.width) {
        titleLabelSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageViewSize.height + titleLabelSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, - (totalHeight - imageViewSize.height), - titleLabelSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(- (totalHeight - titleLabelSize.height), - imageViewSize.width, 0, 0);
}

- (void)yx_layoutImageToRight:(CGFloat)spacing {
    CGSize imageViewSize = self.imageView.frame.size;
    CGSize titleLabelSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleLabelSize.width + 0.5 < frameSize.width) {
        titleLabelSize.width = frameSize.width;
    }
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0, - (titleLabelSize.width * 2  + spacing));
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - (imageViewSize.width * 2  +spacing), 0, 0);
}

/** 设置背景色 */
- (void)yx_setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage yx_imageWithColor:color] forState:state];
}

@end
