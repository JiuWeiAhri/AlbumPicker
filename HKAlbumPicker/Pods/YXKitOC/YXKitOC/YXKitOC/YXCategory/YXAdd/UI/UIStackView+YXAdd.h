//
//  UIStackView+YXAdd.h
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/3/18.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIStackView (YXAdd)

/** 隐藏或隐藏所有排列的视图 */
- (void)yx_setAllArrangedSubviewsHidden:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
