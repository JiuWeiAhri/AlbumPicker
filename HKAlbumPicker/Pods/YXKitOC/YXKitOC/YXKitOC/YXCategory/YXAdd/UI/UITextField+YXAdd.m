//
//  UITextField+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "UITextField+YXAdd.h"
#import <BlocksKit/UITextField+BlocksKit.h>

@implementation UITextField (YXAdd)

@dynamic yx_shouldBeginEditingBlock, yx_didBeginEditingBlock, yx_shouldEndEditingBlock, yx_didEndEditingBlock, yx_shouldChangeCharactersInRangeWithReplacementStringBlock, yx_shouldClearBlock, yx_shouldReturnBlock;

+ (instancetype)creatWithPlaceholder:(NSString *)placeholder fontSize:(CGFloat)size color:(nullable UIColor *)color {
    return [self creatWithFrame:CGRectZero placeholder:placeholder fontSize:size color:color leftView:nil rightView:nil];
}

+ (instancetype)creatWithFrame:(CGRect)frame placeholder:(NSString *)placeholder fontSize:(CGFloat)size color:(nullable UIColor *)color {
    return [self creatWithFrame:frame placeholder:placeholder fontSize:size color:color leftView:nil rightView:nil];
}

+ (instancetype)creatWithFrame:(CGRect)frame placeholder:(NSString *)placeholder fontSize:(CGFloat)size color:(nullable UIColor *)color leftView:(nullable UIView *)leftView rightView:(nullable UIView *)rightView {
    UITextField *textField = [[[self class] alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.textColor = color ? color : [UIColor darkTextColor];
    textField.font = [UIFont systemFontOfSize:size];
    textField.leftView = leftView;
    textField.rightView = rightView;
    textField.leftViewMode = leftView ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
    textField.rightViewMode = rightView ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
    return textField;
}

#pragma mark - YXBlock

- (void)setYx_shouldBeginEditingBlock:(BOOL (^)(UITextField * _Nonnull))yx_shouldBeginEditingBlock {
    self.bk_shouldBeginEditingBlock = yx_shouldBeginEditingBlock;
}

- (void)setYx_didBeginEditingBlock:(void (^)(UITextField * _Nonnull))yx_didBeginEditingBlock {
    self.bk_didBeginEditingBlock = yx_didBeginEditingBlock;
}

- (void)setYx_shouldEndEditingBlock:(BOOL (^)(UITextField * _Nonnull))yx_shouldEndEditingBlock {
    self.bk_shouldEndEditingBlock = yx_shouldEndEditingBlock;
}

- (void)setYx_shouldChangeCharactersInRangeWithReplacementStringBlock:(BOOL (^)(UITextField * _Nonnull, NSRange, NSString * _Nonnull))yx_shouldChangeCharactersInRangeWithReplacementStringBlock {
    self.bk_shouldChangeCharactersInRangeWithReplacementStringBlock = yx_shouldChangeCharactersInRangeWithReplacementStringBlock;
}

- (void)setYx_shouldClearBlock:(BOOL (^)(UITextField * _Nonnull))yx_shouldClearBlock {
    self.bk_shouldClearBlock = yx_shouldClearBlock;
}

- (void)setYx_shouldReturnBlock:(BOOL (^)(UITextField * _Nonnull))yx_shouldReturnBlock {
    self.bk_shouldReturnBlock = yx_shouldReturnBlock;
}

- (void)setYx_didEndEditingBlock:(void (^)(UITextField * _Nonnull))yx_didEndEditingBlock {
    self.bk_didEndEditingBlock = yx_didEndEditingBlock;
}

@end
