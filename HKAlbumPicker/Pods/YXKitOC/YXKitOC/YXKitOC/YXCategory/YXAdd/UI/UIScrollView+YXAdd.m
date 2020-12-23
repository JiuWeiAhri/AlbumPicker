//
//  UIScrollView+YXAdd.m
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/3/18.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "UIScrollView+YXAdd.h"
#import "UIView+YXAdd.h"

@implementation UIScrollView (YXAdd)

/** 不自动偏移 */
- (void)yx_setScrollViewContentInsetAdjustmentNever {
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        [self yx_currentVC].automaticallyAdjustsScrollViewInsets = NO;
    }
}

@end
