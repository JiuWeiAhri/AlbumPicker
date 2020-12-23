//
//  NSArray+YXFilterObject.m
//  YXKitOC
//
//  Created by 李鹏飞 on 2020/6/11.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "NSArray+YXFilterObject.h"
#import "NSArray+YXAdd.h"

@implementation NSArray (YXFilterObject)

- (NSArray *)filterObjectTitlesForKey:(NSString *)key {
    for (YXFilterObject *obj in self) {
        if ([obj.key isEqualToString:key]) {
            return obj.titles;
        }
    }
    return nil;
}

- (NSArray *)filterObjectValuesForKey:(NSString *)key {
    for (YXFilterObject *obj in self) {
        if ([obj.key isEqualToString:key]) {
            return obj.values;
        }
    }
    return nil;
}

- (NSArray *)filterObjectsAtPageIndex:(NSInteger)pageIndex {
    NSArray *filterObjects = [self yx_select:^BOOL(YXFilterObject *  _Nonnull obj) {
        return obj.filterPageIndex == pageIndex;
    }];
    return filterObjects;
}

@end
