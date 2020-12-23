//
//  YXAttributeMaker.m
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/3/18.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "YXAttributeMaker.h"

@interface YXAttributeMaker ()

@property (nonatomic, strong) NSMutableDictionary<NSAttributedStringKey, id> *attributesInfo; /**< 属性信息 */

@end

@implementation YXAttributeMaker

/** 设置行间距 */
- (YXAttributeMaker * (^)(CGFloat))lineSpacingEqualTo {
    return ^id(CGFloat lineSpacing) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setParagraphStyle:[self.attributesInfo objectForKey:NSParagraphStyleAttributeName]];
        [paragraphStyle setLineSpacing:lineSpacing];
        [self.attributesInfo setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
        return self;
    };
}

/** 计算宽高 */
- (CGSize)size {
    return [self.text boundingRectWithSize:self.maxSize
                                   options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:self.attributesInfo context:nil].size;
}

#pragma mark - Getter

- (NSMutableDictionary<NSAttributedStringKey,id> *)attributesInfo {
    if (!_attributesInfo) {
        _attributesInfo = [[NSMutableDictionary alloc] init];
    }
    return _attributesInfo;
}

#pragma mark - Setter

/** 设置字体 */
- (void)setFont:(UIFont *)font {
    _font = font;
    [self.attributesInfo setValue:font forKey:NSFontAttributeName];
}

@end
