//
//  NSArray+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "NSArray+YXAdd.h"
#import <BlocksKit/NSArray+BlocksKit.h>
#import <YYCategories/NSArray+YYAdd.h>
#import "NSData+YXAdd.h"

@implementation NSArray (YXAdd)

/// 按给定字符串拼接
- (NSString *)yx_mergeAllObjectsByString:(NSString *)string {
    
    if (!([string isKindOfClass:[NSString class]] || [string isKindOfClass:[NSMutableString class]])) {
        return nil;
    }
    
    NSMutableString *mergeString = [NSMutableString string];
    for (int i = 0; i < self.count; i++) {
        NSString *temp_string = self[i];
        if (([temp_string isKindOfClass:[NSString class]] || [string isKindOfClass:[NSMutableString class]]) && temp_string.length > 0) {
            [mergeString appendFormat:@"%@%@", string, self[i]];
        }
    }
    if (mergeString.length > 0) {
        [mergeString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return mergeString;
}

/// 返回一个类似Xml格式的NSString（快速查看结构）
- (NSString *)yx_plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.yx_utf8String;
    return nil;
}

/// 随机取一个元素
- (id)yx_randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

/// 返回指定Index的元素，但不会数组越界Crash，获取不到内容时返回nil
- (id)yx_objectAtSafeIndex:(NSUInteger)index {
    return [self objectOrNilAtIndex:index];
}

/// 返回NSString，只支持NSString/NSNumber/NSDictionary/NSArray
- (nullable NSString *)yx_jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

/// 返回NSString（格式化），只支持NSString/NSNumber/NSDictionary/NSArray
- (nullable NSString *)yx_jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

/// 过滤相同元素
- (NSArray *)yx_filterSameObject {
    NSMutableSet *set = [NSMutableSet set];
    for (NSObject *obj in self) {
        [set addObject:obj];
    }
    
    NSMutableArray *newArr = [NSMutableArray array];
    for (NSObject *obj in set) {
        [newArr addObject:obj];
    }
    return (NSArray *)newArr;
}

/// 快速排序
+ (void)yx_quickSort:(NSMutableArray <NSDictionary *>*)array low:(NSInteger)low high:(NSInteger)high key:(NSString *)key {
    if(array == nil || array.count == 0){
        return;
    }
    if (low >= high) {
        return;
    }
    
    NSInteger middle = low + (high - low)/2;
    NSString *prmt = array[middle][key];
    NSInteger i = low;
    NSInteger j = high;
    while (i <= j) {
        while ([array[i][key] intValue] > [prmt intValue]) {
            i++;
        }
        while ([array[j][key] intValue] < [prmt intValue]) {
            j--;
        }
        
        if(i <= j){
            [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            i++;
            j--;
        }
    }
    
    if (low < j) {
        [self yx_quickSort:array low:low high:j key:key];
    }
    if (high > i) {
        [self yx_quickSort:array low:i high:high key:key];
    }
}

/// 获取每个元素指定Key的Value集合
- (NSArray *)yx_valuesInEachObjectForKey:(NSString *)key {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.count; i++) {
        id obj = [self objectAtIndex:i];
        id value = [obj valueForKey:key];
        if (value) {
            [array addObject:value];
        }
    }
    return array;
}

#pragma mark - YXBlock

/// 顺序遍历
- (void)yx_each:(void (^)(id obj))block {
    [self bk_each:block];
}

/// 快速多线程遍历 无序
- (void)yx_apply:(void (^)(id obj))block {
    [self bk_apply:block];
}

/// 返回数组中匹配的第一个对象
- (id)yx_match:(BOOL (^)(id obj))block {
    return [self bk_match:block];
}

/// 筛选符合条件的元素集合
- (NSArray *)yx_select:(BOOL (^)(id obj))block {
    return [self bk_select:block];
}

/// 筛选不符合条件的元素集合
- (NSArray *)yx_reject:(BOOL (^)(id obj))block {
    return [self bk_reject:block];
}

/// 遍历替换元素集合
- (NSArray *)yx_map:(id (^)(id obj))block {
    return [self bk_map:block];
}

/// 是否有符合条件的元素
- (BOOL)yx_any:(BOOL (^)(id obj))block {
    return [self bk_any:block];
}

/// 是否所有元素都不满足条件
- (BOOL)yx_none:(BOOL (^)(id obj))block {
    return [self bk_none:block];
}

/// 是否所有元素均符合条件
- (BOOL)yx_all:(BOOL (^)(id obj))block {
    return [self bk_all:block];
}

/// 对比两个数组是否全部符合条件
- (BOOL)yx_corresponds:(NSArray *)list withBlock:(BOOL (^)(id obj1, id obj2))block {
    return [self bk_corresponds:list withBlock:block];
}

@end
