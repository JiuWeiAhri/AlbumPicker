//
//  YXAttributeMaker.h
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/3/18.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXAttributeMaker : NSObject

@property (nonatomic, copy) NSString *text; /**< 计算Size的文本 */
@property (nonatomic, assign) CGSize maxSize; /**< 最大宽高 */
@property (nonatomic, strong) UIFont *font; /**< 字体 */

/** 设置行间距 */
- (YXAttributeMaker * (^)(CGFloat))lineSpacingEqualTo;

/** 计算宽高 */
- (CGSize)size;

@end

NS_ASSUME_NONNULL_END
