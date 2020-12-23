//
//  UILabel+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "UILabel+YXAdd.h"

@implementation UILabel (YXAdd)

+ (instancetype)creatWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)size color:(nullable UIColor *)color textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.textColor = color ? : [UIColor darkTextColor];
    label.font = [UIFont systemFontOfSize:size == 0 ? 17 : size];
    label.textAlignment = alignment;
    return label;
}

+ (instancetype)creatWithMinX:(CGFloat)x minY:(CGFloat)y title:(NSString *)title fontSize:(CGFloat)size {
    UILabel *label = [UILabel creatWithFrame:CGRectMake(x, y, 0, 0) title:title fontSize:size color:nil textAlignment:NSTextAlignmentLeft];
    [label sizeToFit];
    return label;
}

+ (instancetype)creatWithMinX:(CGFloat)x minY:(CGFloat)y title:(NSString *)title {
    UILabel *label = [UILabel creatWithFrame:CGRectMake(x, y, 0, 0) title:title fontSize:0 color:nil textAlignment:NSTextAlignmentLeft];
    [label sizeToFit];
    return label;
}

+ (instancetype)creatWithMinX:(CGFloat)x minY:(CGFloat)y title:(NSString *)title fontSize:(CGFloat)size color:(nullable UIColor *)color {
    UILabel *label = [UILabel creatWithFrame:CGRectMake(x, y, 0, 0) title:title fontSize:size color:color textAlignment:NSTextAlignmentLeft];
    [label sizeToFit];
    return label;
}

+ (instancetype)creatWithMinX:(CGFloat)x minY:(CGFloat)y title:(NSString *)title fontSize:(CGFloat)size color:(nullable UIColor *)color textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [UILabel creatWithFrame:CGRectMake(x, y, 0, 0) title:title fontSize:size color:color textAlignment:NSTextAlignmentLeft];
    [label sizeToFit];
    return label;
}

#pragma mark - YXAdd

/// 添加删除线
- (void)yx_setStrikethrough {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.text
                                                                                attributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle),
                                                                                             NSBaselineOffsetAttributeName : @(0)}];
    self.attributedText = attrStr;
}

/// 添加下划线
- (void)yx_setUnderline {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.text
                                                                                attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
    self.attributedText = attrStr;
}

/** 设置行间距 */
- (void)yx_setLineSpacing:(CGFloat)lineSpacing {
    [self yx_setLineSpacing:lineSpacing range:NSMakeRange(0, self.text.length)];
}

/** 设置行间距 */
- (void)yx_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
 
    NSDictionary *paragraphStyleInfo = [self.attributedText attributesAtIndex:0 effectiveRange:&range];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphStyle:[paragraphStyleInfo objectForKey:NSParagraphStyleAttributeName]];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;
    
}

/// 设置部分文字颜色和字体，设置nil时不变
- (void)yx_setTextColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    if (font) [attributedString addAttribute:NSFontAttributeName value:font range:range];
    if (color) [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = attributedString;
}

@end
