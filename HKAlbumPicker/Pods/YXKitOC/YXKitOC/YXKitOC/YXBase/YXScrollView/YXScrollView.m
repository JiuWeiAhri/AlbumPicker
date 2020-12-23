//
//  YXScrollView.m
//  YXKitOC
//
//  Created by zhxin on 2020/8/18.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXScrollView.h"
#import "UIScrollView+YXAdd.h"

@implementation YXScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self yx_setScrollViewContentInsetAdjustmentNever];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self yx_setScrollViewContentInsetAdjustmentNever];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self yx_setScrollViewContentInsetAdjustmentNever];
    }
    return self;
}

@end
