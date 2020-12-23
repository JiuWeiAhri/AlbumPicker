//
//  NSArray+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (YXAdd)

#pragma mark - YXAdd

/// 按给定字符串拼接
- (nullable NSString *)yx_mergeAllObjectsByString:(NSString * _Nullable)string;

/// 返回一个类似Xml格式的NSString（快速查看结构）
- (nullable NSString *)yx_plistString;

/// 随机取一个元素
- (nullable id)yx_randomObject;

/// 返回指定Index的元素，但不会数组越界Crash，获取不到内容时返回nil
- (nullable id)yx_objectAtSafeIndex:(NSUInteger)index;

/// 返回NSString，只支持NSString/NSNumber/NSDictionary/NSArray
- (nullable NSString *)yx_jsonStringEncoded;

/// 返回NSString（格式化），只支持NSString/NSNumber/NSDictionary/NSArray
- (nullable NSString *)yx_jsonPrettyStringEncoded;

/// 过滤相同元素
- (NSArray *)yx_filterSameObject;

/// 快速排序
+ (void)yx_quickSort:(NSMutableArray <NSDictionary *>*)array low:(NSInteger)low high:(NSInteger)high key:(NSString *)key;

/// 获取每个Dictionary指定Key的Value集合，该数组必须每个元素是Dictionary类型
- (NSArray *)yx_valuesInEachObjectForKey:(NSString *)key;

#pragma mark - YXBlock

/// 顺序遍历
- (void)yx_each:(void (^)(id obj))block;

/// 快速多线程遍历 无序
- (void)yx_apply:(void (^)(id obj))block;

/// 返回数组中匹配的第一个对象
- (id)yx_match:(BOOL (^)(id obj))block;

/// 筛选符合条件的元素集合
- (NSArray *)yx_select:(BOOL (^)(id obj))block;

/// 筛选不符合条件的元素集合
- (NSArray *)yx_reject:(BOOL (^)(id obj))block;

/// 遍历替换元素集合
- (NSArray *)yx_map:(id (^)(id obj))block;

/// 是否有符合条件的元素
- (BOOL)yx_any:(BOOL (^)(id obj))block;

/// 是否所有元素都不满足条件
- (BOOL)yx_none:(BOOL (^)(id obj))block;

/// 是否所有元素均符合条件
- (BOOL)yx_all:(BOOL (^)(id obj))block;

/// 对比两个数组是否全部符合条件
- (BOOL)yx_corresponds:(NSArray *)list withBlock:(BOOL (^)(id obj1, id obj2))block;

@end

NS_ASSUME_NONNULL_END
