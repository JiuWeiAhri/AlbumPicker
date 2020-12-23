//
//  UITextField+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (YXAdd)

#pragma mark - YXCreat

+ (instancetype)creatWithPlaceholder:(NSString *)placeholder fontSize:(CGFloat)size color:(nullable UIColor *)color;

+ (instancetype)creatWithFrame:(CGRect)frame placeholder:(NSString *)placeholder fontSize:(CGFloat)size color:(nullable UIColor *)color;

+ (instancetype)creatWithFrame:(CGRect)frame placeholder:(NSString *)placeholder fontSize:(CGFloat)size color:(nullable UIColor *)color leftView:(nullable UIView *)leftView rightView:(nullable UIView *)rightView;

#pragma mark - YXAdd

#pragma mark - YXBlock

@property (nonatomic, copy) BOOL(^yx_shouldBeginEditingBlock)(UITextField *textField);

@property (nonatomic, copy) void(^yx_didBeginEditingBlock)(UITextField *textField);

@property (nonatomic, copy) BOOL(^yx_shouldEndEditingBlock)(UITextField *textField);

@property (nonatomic, copy) void(^yx_didEndEditingBlock)(UITextField *textField);

@property (nonatomic, copy) BOOL(^yx_shouldChangeCharactersInRangeWithReplacementStringBlock)(UITextField *textField, NSRange range, NSString *string);

@property (nonatomic, copy) BOOL(^yx_shouldClearBlock)(UITextField *textField);

@property (nonatomic, copy) BOOL(^yx_shouldReturnBlock)(UITextField *textField);

@end

NS_ASSUME_NONNULL_END
