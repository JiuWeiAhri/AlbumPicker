//
//  YXBaseCodingModel.h
//  YXKitDemo
//
//  Created by zhuxuewei on 2018/7/13.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#import "YXModel.h"

/**
 归档并保存一个对象
 
 @param object An Object
 @param filePath 保存的文件名（可以包含文件所在的相对路径）
 @return 是否保存成功
 
 Example:
 
 YXBaseCodingModel *model = [YXBaseCodingModel yx_modelWithDictionary:dict];
 NSArray *modelsArray = [YXBaseCodingModel yx_modelsWithArray:dataArray];
 // 归档
 YX_ArchiveObject(model, @"fileName1");
 YX_ArchiveObject(modelsArray, @"path/fileName1");
 
 */
FOUNDATION_EXTERN BOOL YX_ArchiveObject(id <NSCoding> _Nullable object, NSString * _Nonnull filePath);

/**
 解档一个保存在名为 fileName （可以包含文件所在的相对路径）的文件中的对象
 
 @param filePath 保存对象的文件路径
 @return An Object
 
 Example:
 
 id = YX_UnarchiveObject(@"path/fileName1");
 */
FOUNDATION_EXTERN id _Nullable YX_UnarchiveObject(NSString * _Nonnull filePath);

/**
 删除 filePath 的归档文件，当 filePath 为某一文件夹时，删除该文件夹
 
 @param filePath 文件路径
 @return 是否删除成功
 */
FOUNDATION_EXTERN BOOL YX_DeleteArchiveFile(NSString * _Nonnull filePath);

/**
 删除所有归档文件
 
 @return 是否删除成功
 */
FOUNDATION_EXTERN BOOL YX_DeleteAllArchiveFile(void);

/**
 沙盒中是否有归档文件
 
 @return 是否存在
 */
FOUNDATION_EXTERN BOOL YX_IsExistArchiveFile(NSString * _Nonnull filePath);


/**
 归档文件是否过期
 
 @param filePath 缓存文件
 @param cacheTime 缓存时长（秒）
 @return 是否过期
 */

FOUNDATION_EXTERN BOOL YX_IsExpiredArchiveFile(NSString * _Nonnull filePath, NSInteger cacheTime);


@protocol YXCoding <NSCoding, NSCopying>

+ (BOOL)yx_archiveCodingObject:(id <NSCoding>_Nonnull)object filePath:(NSString *_Nonnull)filePath;
+ (nullable id)yx_unarchiveObjectWithFilePath:(NSString *_Nonnull)filePath;
+ (BOOL)yx_deleteArchiveWithFilePath:(NSString *_Nonnull)filePath;
+ (BOOL)yx_deleteAllArchiveFile;
+ (BOOL)yx_isExistArchiveFile:(NSString *_Nonnull)filePath;
+ (BOOL)yx_isExpiredArchiveFile:(NSString *_Nonnull)filePath cacheTime:(NSInteger)cacheTime;

@end

@interface YXBaseCodingModel : YXModel<YXCoding>

@end
