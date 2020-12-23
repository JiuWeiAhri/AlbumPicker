//
//  UIControl+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "UIControl+YXAdd.h"
#import <YYCategories/UIControl+YYAdd.h>

@implementation UIControl (YXAdd)

- (void)yx_addEventBlock:(void (^)(id sender))handler {
    [self addBlockForControlEvents:UIControlEventTouchUpInside block:handler];
}

- (void)yx_addEventBlock:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents {
    [self addBlockForControlEvents:controlEvents block:handler];
}

@end
