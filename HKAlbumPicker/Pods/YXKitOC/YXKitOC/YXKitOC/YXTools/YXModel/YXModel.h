//
//  YXModel.h
//  YXKitDemo
//
//  Created by zhuxuewei on 2019/3/27.
//  Copyright © 2019年 a186f13. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YXModelProtocol <NSObject>

@optional
/**
 序列化或反序列化 黑名单
 
 @return return value description
 */
+ (nullable NSArray<NSString *> *)yx_propertyBlacklist;

/**
 序列化或反序列化 白名单
 
 @return return value description
 */
+ (nullable NSArray<NSString *> *)yx_propertyWhitelist;

/**
 反序列化 白名单 （嵌套的模型不会生效，未完待续。。。）
 使用场景：对某个对象反序列化时，如果需要根据某种状态 反序列化不同的字段时使用,
 作为 + yx_propertyBlacklist、+ yx_propertyWhitelist 的补充方法使用
 此处设置的白名单，必须同时满足 包含于yx_propertyWhitelist 且不包含于yx_propertyBlacklist时才会生效
 
 例：model对象有个"type"字段，
 当 type = @"0" 时，反序列化需要 字段A,B,C ;
 当 type = @"1" 时，反序列化需要 字段C,D,E ;
 
 @return return value description
 */
- (nullable NSArray<NSString *> *)yx_modelPropertyWhitelist;


/**
 反序列化 黑名单名单 （嵌套的模型不会生效，未完待续。。。）
 使用场景与方式同 yx_modelPropertyWhitelist
 @return return value description
 */
- (nullable NSArray<NSString *> *)yx_modelPropertyBlacklist;

@end


NS_ASSUME_NONNULL_BEGIN

@interface YXModel : NSObject<YXModelProtocol, NSCopying>

+ (nullable instancetype)yx_modelWithJSON:(id)json;

/**
 通过字典初始化一个数据模型
 
 @param dict A json object in`NSDictionary`, `NSString` or `NSData`
 */
+ (nullable instancetype)yx_modelWithDictionary:(id)dict;

/**
 通过一个字典数组，初始化一组数据模型
 */
+ (nullable NSArray *)yx_modelsWithArray:(NSArray *)array;


/**
 通过字典更新数据模型（基于KVO）
 */
- (void)yx_updateWithDictionary:(NSDictionary *)dict;

/**
 返回一个自定义属性映射表, key为当前property name，value为json中的key
 Example:
 
 json:
 {
 "n":"Harry Pottery",
 "p": 256,
 "ext" : {
 "desc" : "A book written by J.K.Rowling."
 },
 "ID" : 100010
 }
 
 model:
 YXBook : NSObject
 @property NSString *name;
 @property NSInteger page;
 @property NSString *desc;
 @property NSString *bookID;
 @end
 
 @implementation YXBook
 + (NSDictionary *)yx_modelCustomPropertyMapper {
 return @{@"name"  : @"n",
 @"page"  : @"p",
 @"desc"  : @"ext.desc",
 @"bookID": @[@"id", @"ID", @"book_id"]};
 }
 @end
 */
+ (nullable NSDictionary<NSString *, id> *)yx_modelCustomPropertyMapper;

/**
 如果一个集合属性（NSArray/NSSet/NSDictionary）中的元素是一个object，通过此方法指定集合元素中所包含的元素类型，则集合中的元素也会自动序列化；
 key为集合属性的property name，value为集合中元素的类对象Class
 
 Example:
 
 YXAttributes:NSObject
 
 @property NSString *name;
 @property NSArray *shadows;
 @property NSSet *borders;
 @property NSDictionary *attachments;
 @end
 
 @implementation YXAttributes
 + (NSDictionary *)modelContainerPropertyGenericClass {
 return @{@"shadows" : [YXShadow class],
 @"borders" : YXBorder.class,
 @"attachments" : @"YXAttachment" };
 }
 @end
 
 @return A class mapper.
 */
+ (nullable NSDictionary<NSString *, id> *)yx_modelContainerPropertyGenericClass;

/**
 可以复写此方法，对某些属性计算或转换后重新赋值；也可以为字典中没有的属性单独进行赋值
 Example:
 
 json:
 {
 "time":"20180626",
 "bookType": "01"
 }
 
 model:
 YXBook : NSObject
 @property NSString *time;
 @property NSString *bookType;
 @property NSString *bookTypeTransfer;
 @end
 
 @implementation YXBook
 - (void)yx_update {
 self.time = @"2018-06-26";
 if ([bookType isEqualToString:@"01"]) {
 self.bookTypeTransfer = @"小说";
 }
 }
 @end
 */
- (void)yx_update;

/**
 copy一个NSObject
 */
- (nullable id)yx_modelCopy;

/**
 获取Hash值
 */
- (NSUInteger)yx_modelHash;

/**
 根据两个对象的所有的属性值，判断两个对象是否相等
 */
- (BOOL)yx_modelIsEqual:(id)model;

@end

@interface NSObject (YXModel)

/**
 用于格式化输出Model
 
 @return A string contain all propertys
 */
- (NSString *)yx_modelDescription;

/**
 将Model或Model数组转换为字典或者字典数组
 */
- (nullable id)yx_modelToJSONObject;


/**
 去除null

 @return return value description
 */
- (nullable id)yx_safeObject;

@end

NS_ASSUME_NONNULL_END
