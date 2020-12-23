//
//  NSObject+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "NSObject+YXAdd.h"
#import <objc/runtime.h>
#import <YYCategories/NSObject+YYAddForKVO.h>
#import <YYCategories/NSObject+YYAdd.h>

@implementation NSObject (YXAdd)

/// 返回类属性字典
- (NSDictionary *)yx_properties_aps {
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

/// swizzle类方法
+ (void)yx_swizzleClassMethodOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    Method originClassMethod = class_getClassMethod(cls, oriSel);
    Method swizzleClassMethod = class_getClassMethod(cls, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originClassMethod swizzledSel:swiSel swizzledMethod:swizzleClassMethod class:cls];
}

/// swizzle类实例方法
+ (void)yx_swizzleClassInstanceMethodWithOriginSel:(SEL)oriSel swizzleSel:(SEL)swiSel {
    Method originClassMethod = class_getInstanceMethod(self, oriSel);
    Method swizzleClassMethod = class_getInstanceMethod(self, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originClassMethod swizzledSel:swiSel swizzledMethod:swizzleClassMethod class:self];
}

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}

/// 添加KVOBlock
- (void)yx_addObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(id _Nonnull obj, id _Nonnull oldVal, id _Nonnull newVal))block {
    [self addObserverBlockForKeyPath:keyPath block:block];
}

/// 移除KVO（Block）
- (void)yx_removeObserverBlocksForKeyPath:(NSString *)keyPath {
    [self removeObserverBlocksForKeyPath:keyPath];
}

/// 移除所有KVO（Block）
- (void)yx_removeObserverBlocks {
    [self removeObserverBlocks];
}

/// 动态关联强引用属性
- (void)yx_setAssociateValue:(nullable id)value withKey:(void *)key {
    [self setAssociateValue:value withKey:key];
}

/// 动态关联弱引用属性
- (void)yx_setAssociateWeakValue:(nullable id)value withKey:(void *)key {
    [self setAssociateWeakValue:value withKey:key];
}

/// 动态取关联对象值
- (nullable id)yx_getAssociatedValueForKey:(void *)key {
    return [self getAssociatedValueForKey:key];
}

/// 移除所有动态关联属性
- (void)yx_removeAssociatedValues {
    [self removeAssociatedValues];
}

- (id)yx_removeNullObject {
    
    id myObj = self;
    
    if ([myObj isKindOfClass:[NSDictionary class]]) return [NSDictionary nullDic:myObj];
    
    else if ([myObj isKindOfClass:[NSArray class]]) return [NSArray nullArr:myObj];
    
    else if ([myObj isKindOfClass:[NSString class]]) return [NSString stringToString:myObj];
    
    else if ([myObj isKindOfClass:[NSNull class]]) return [NSNull nullToString];
    
    else return myObj;
}

#pragma mark - Private Func

+ (NSDictionary *)nullDic:(NSDictionary *)myDic {
    
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    
    [myDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        id Obj = [self yx_removeNullObject];
        
        [resDic setValue:Obj forKey:key];
    }];
    
    return resDic;
    
}

+ (NSArray *)nullArr:(NSArray *)myArr {
    
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    
    [myArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id Obj = [self yx_removeNullObject];
        
        [resArr addObject:Obj];
    }];
    
    return resArr;
}

+ (NSString *)stringToString:(NSString *)string {
    return string;
}

+ (NSString *)nullToString {
    return nil;
}

/** 返回多个当前对象 */
- (NSArray *)yx_copyCount:(NSUInteger)count {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        [array addObject:self];
    }
    return array;
}

@end
