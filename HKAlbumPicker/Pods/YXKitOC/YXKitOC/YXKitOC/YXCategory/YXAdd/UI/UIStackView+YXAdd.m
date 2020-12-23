//
//  UIStackView+YXAdd.m
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/3/18.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "UIStackView+YXAdd.h"

@implementation UIStackView (YXAdd)

/** 隐藏或隐藏所有排列的视图 */
- (void)yx_setAllArrangedSubviewsHidden:(BOOL)isHidden {
    for (UIView *view in self.arrangedSubviews) {
        view.hidden = isHidden;
    }
}

@end
