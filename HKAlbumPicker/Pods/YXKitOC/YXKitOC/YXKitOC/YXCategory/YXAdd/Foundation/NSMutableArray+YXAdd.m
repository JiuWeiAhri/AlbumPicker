//
//  NSMutableArray+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "NSMutableArray+YXAdd.h"
#import <BlocksKit/NSMutableArray+BlocksKit.h>

@implementation NSMutableArray (YXAdd)

#pragma mark - YXAdd

/// 安全移除某个元素
- (void)yx_removeObjectAtSafeIndex:(NSUInteger)index {
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

/// 移除第一个元素
- (void)yx_removeFirstObject {
    [self yx_removeObjectAtSafeIndex:0];
}

/// 移除最后一个元素
- (void)yx_removeLastObject {
    [self yx_removeObjectAtSafeIndex:self.count - 1];
}

/// 添加NSArray到index-0
- (void)yx_addObjectsToFirst:(NSArray *)objects {
    [self yx_insertObjects:objects atIndex:0];
}

/// 添加NSArray到指定Index
- (void)yx_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    
    if (objects.count == 0) {
        return;
    }
    
    if (index < self.count) {
        for (int i = 0; i < objects.count; i++) {
            [self insertObject:objects[objects.count - i - 1] atIndex:index];
        }
    } else if (index == self.count) {
        [self addObjectsFromArray:objects];
    }
}

/// 翻转数组 前 @[ @1, @2, @3 ], 后 @[ @3, @2, @1 ].
- (void)yx_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

/// 随机排序（洗牌）
- (void)yx_shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

#pragma mark - YXBlock

/// 筛选符合条件的元素
- (void)yx_saveMatchObjects:(BOOL (^)(id obj))block {
    [self bk_performSelect:block];
}

/// 筛选不符合条件的元素
- (void)yx_removeRejectObjects:(BOOL (^)(id obj))block {
    [self bk_performReject:block];
}

/// 遍历替换元素
- (void)yx_replaceForMatch:(id (^)(id obj))block {
    [self bk_performMap:block];
}

@end
