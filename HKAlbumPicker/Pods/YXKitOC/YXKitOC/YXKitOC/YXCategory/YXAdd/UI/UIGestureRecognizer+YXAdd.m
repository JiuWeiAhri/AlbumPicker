//
//  UIGestureRecognizer+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "UIGestureRecognizer+YXAdd.h"
#import <YYCategories/UIGestureRecognizer+YYAdd.h>

@implementation UIGestureRecognizer (YXAdd)

- (instancetype)yx_initWithActionBlock:(void (^)(id sender))block {
    return [self initWithActionBlock:block];
}

- (void)yx_addActionBlock:(void (^)(id sender))block {
    [self addActionBlock:block];
}

- (void)yx_removeAllActionBlocks {
    [self removeAllActionBlocks];
}

@end
