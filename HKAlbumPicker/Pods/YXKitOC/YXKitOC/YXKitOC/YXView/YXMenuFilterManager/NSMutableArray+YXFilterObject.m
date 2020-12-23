//
//  NSMutableArray+YXFilterObject.m
//  MarsCar
//
//  Created by 张鑫 on 2020/6/24.
//  Copyright © 2020 TaoChe. All rights reserved.
//

#import "NSMutableArray+YXFilterObject.h"
#import "YXFilterObject.h"

@implementation NSMutableArray (YXFilterObject)

- (void)removeFilterObjectsAtPageIndex:(NSInteger)pageIndex {
    for (YXFilterObject *object in [self copy]) {
        if (object.filterPageIndex == pageIndex) {
            [self removeObject:object];
        }
    }
}

@end
