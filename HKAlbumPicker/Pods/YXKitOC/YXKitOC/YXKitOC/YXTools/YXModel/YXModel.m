//
//  YXModel.m
//  YXKitDemo
//
//  Created by zhuxuewei on 2019/3/27.
//  Copyright © 2019年 a186f13. All rights reserved.
//

#import "YXModel.h"
#import <YYModel/YYModel.h>
#import <BlocksKit/BlocksKit.h>

@implementation YXModel

+ (nullable instancetype)yx_modelWithJSON:(id)json {
    YXModel *new = [self yy_modelWithJSON:json];
    [new yx_updateCoverModel];
    return new;
}

+ (nullable instancetype)yx_modelWithDictionary:(id)dict {
    YXModel *new = [self yy_modelWithJSON:dict];
    [new yx_updateCoverModel];
    return new;
}

+ (nullable NSArray *)yx_modelsWithArray:(NSArray *)array {
    NSArray *temp = [NSArray yy_modelArrayWithClass:self json:array];
    return [temp bk_map:^id(id obj) {
        [obj yx_updateCoverModel];
        return obj;
    }];
}

- (void)yx_updateWithDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:NSDictionary.class]) {
        return;
    }
    [self setValuesForKeysWithDictionary:dict];
}

- (void)yx_updateCoverModel {
    [self yx_update];
    NSDictionary *propertyGeneric = [self.class yx_modelContainerPropertyGenericClass];
    if (![propertyGeneric isKindOfClass:[NSDictionary class]]) return;
    
    [propertyGeneric bk_each:^(NSString *key, id obj) {
        if (![key isKindOfClass:[NSString class]]) return;
        Class meta = object_getClass(obj);
        if (!meta) return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (class_isMetaClass(meta) || [obj isKindOfClass:[NSString class]]) {
            SEL getProperty = NSSelectorFromString(key);
            if ([self respondsToSelector:getProperty]) {
                id property = [self performSelector:getProperty];
                if ([property isKindOfClass:YXModel.class]) {
                    [property yx_updateCoverModel];
                } else if ([property isKindOfClass:[NSArray class]]) {
                    [(NSArray *)property bk_each:^(id obj) {
                        if ([obj isKindOfClass:YXModel.class]) {
                            [obj yx_updateCoverModel];
                        }
                    }];
                } else if ([property isKindOfClass:[NSDictionary class]]) {
                    [(NSDictionary *)property bk_each:^(id key, id obj) {
                        if ([obj isKindOfClass:YXModel.class]) {
                            [obj yx_updateCoverModel];
                        }
                    }];
                }
            }
        }
    }];
#pragma clang diagnostic pop
}

- (void)yx_update {
    
}

#pragma mark - YXModelProtocol

+ (nullable NSArray<NSString *> *)yx_propertyBlacklist {
    return nil;
}

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
    return [self yx_propertyBlacklist];
}

+ (nullable NSArray<NSString *> *)yx_propertyWhitelist {
    return nil;
}

+ (nullable NSArray<NSString *> *)modelPropertyWhitelist {
    return [self yx_propertyWhitelist];
}

- (nullable NSArray<NSString *> *)yx_modelPropertyWhitelist {
    return nil;
}

+ (nullable NSDictionary<NSString *, id> *)yx_modelCustomPropertyMapper {
    return nil;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return [self yx_modelCustomPropertyMapper];
}

+ (nullable NSDictionary<NSString *, id> *)yx_modelContainerPropertyGenericClass {
    return nil;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return [self yx_modelContainerPropertyGenericClass];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone*)zone {
    return [self yy_modelCopy];
}

- (nullable id)yx_modelCopy {
    return [self yy_modelCopy];
}

- (NSUInteger)yx_modelHash {
    return [self yy_modelHash];
}

- (BOOL)yx_modelIsEqual:(id)model {
    return [self yy_modelIsEqual:model];
}

#pragma mark - KVO

- (void)setValue:(id)value forKey:(NSString *)key {
    if (key) {
        [super setValue:value forKey:key];
    } else {
#if DEBUG
        NSLog(@"%@-setValue for nilKey", NSStringFromClass(self.class));
#endif
    }
}

- (id)valueForKey:(NSString *)key {
    if (key) {
        return [super valueForKey:key];
    } else {
#if DEBUG
        NSLog(@"%@-Value for nilKey", NSStringFromClass(self.class));
#endif
        return nil;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
#if DEBUG
    NSLog(@"%@不存在的key - %@", NSStringFromClass(self.class), key);
#endif
}

- (id)valueForUndefinedKey:(NSString *)key {
#if DEBUG
    NSLog(@"%@不存在的key - %@", NSStringFromClass(self.class), key);
#endif
    return nil;
}

@end

@implementation NSObject (YXModel)

- (NSString *)yx_modelDescription {
    return [self yy_modelDescription];
}

- (nullable id)yx_modelToJSONObject {
    id jsonObj = [self yy_modelToJSONObject];
    if ([self isKindOfClass:YXModel.class]) {
        return [self jsonFilterWhiteList:jsonObj];
    }
    return jsonObj;
}

- (id)jsonFilterWhiteList:(id)jsonObj {
    if ([jsonObj isKindOfClass:[NSDictionary class]]) {
        NSArray *whiteList = nil;
        NSArray *blackList = nil;
        if ([self respondsToSelector:@selector(yx_modelPropertyWhitelist)]) {
            whiteList = [(YXModel *)self yx_modelPropertyWhitelist];
        }
        if ([self respondsToSelector:@selector(yx_modelPropertyBlacklist)]) {
            blackList = [(YXModel *)self yx_modelPropertyBlacklist];
        }
        if (([whiteList isKindOfClass:[NSArray class]] && whiteList.count) ||
            ([blackList isKindOfClass:[NSArray class]] && blackList.count)) {
            return [(NSDictionary *)jsonObj bk_select:^BOOL(id key, id obj) {
                if (whiteList && blackList) {
                    return [whiteList containsObject:key] && ![blackList containsObject:key];
                } else if (whiteList) {
                    return [whiteList containsObject:key];
                } else {
                    return ![blackList containsObject:key];
                }
            }];
        }
    }
    return jsonObj;
}

- (nullable id)yx_safeObject {
    if ([self isKindOfClass:NSNull.class]) {
        return nil;
    } else if ([self isKindOfClass:NSArray.class]) {
        return [(NSArray *)self bk_select:^BOOL(id subObj) {
            return [subObj yx_safeObject];
        }];
    } else if ([self isKindOfClass:NSDictionary.class]) {
        return [(NSDictionary *)self bk_select:^BOOL(id key, id subObj) {
            return [subObj yx_safeObject];
        }];
    }
    return self;
}

@end
