//
//  NSObject+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YXAdd)

/// 返回类属性字典
- (NSDictionary *)yx_properties_aps;

/// swizzle类方法
+ (void)yx_swizzleClassMethodOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

/// swizzle类实例方法
+ (void)yx_swizzleClassInstanceMethodWithOriginSel:(SEL)oriSel swizzleSel:(SEL)swiSel;

/// 添加KVO（Block）
- (void)yx_addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(id _Nonnull obj, id _Nonnull oldVal, id _Nonnull newVal))block;

/// 移除KVO（Block）
- (void)yx_removeObserverBlocksForKeyPath:(NSString *)keyPath;

/// 移除所有KVO（Block）
- (void)yx_removeObserverBlocks;

/// 动态添加关联强引用属性
- (void)yx_setAssociateValue:(nullable id)value withKey:(void *)key;

/// 动态设置关联弱引用属性
- (void)yx_setAssociateWeakValue:(nullable id)value withKey:(void *)key;

/// 动态取关联属性值
- (nullable id)yx_getAssociatedValueForKey:(void *)key;

/// 移除所有动态关联属性
- (void)yx_removeAssociatedValues;

/** 删除NSArray、NSDictionary中的Null */
- (id)yx_removeNullObject;

/** 返回多个当前对象 */
- (NSArray *)yx_copyCount:(NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
