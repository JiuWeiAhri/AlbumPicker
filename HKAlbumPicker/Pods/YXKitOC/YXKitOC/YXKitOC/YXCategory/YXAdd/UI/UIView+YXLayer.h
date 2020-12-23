//
//  UIView+Layer.h
//  YXKitDemo
//
//  Created by zx on 2018/3/14.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YXLayer)

// Layer properties, they can use in xib/storyboard file.
@property (nonatomic) IBInspectable CGFloat yx_cornerRadius;
@property (nonatomic) IBInspectable CGFloat yx_borderWidth;
@property (nonatomic) IBInspectable UIColor *yx_borderColor;
@property (nonatomic) IBInspectable UIColor *yx_shadowColor;
@property (nonatomic) IBInspectable float yx_shadowOpacity;
@property (nonatomic) IBInspectable CGSize yx_shadowOffset;
@property (nonatomic) IBInspectable CGFloat yx_shadowRadius;
@property (nonatomic) IBInspectable BOOL yx_onePixHeight;
@property (nonatomic) IBInspectable BOOL yx_onePixWidth;

@end
