//
//  YXBaseCodingModel.m
//  YXKitDemo
//
//  Created by zhuxuewei on 2018/7/13.
//  Copyright © 2018年 a186f13. All rights reserved.
//  一个支持归档解档的Model基类

#import "YXBaseCodingModel.h"
#import <YYCategories/YYCategories.h>
#import <BlocksKit/BlocksKit.h>
#import <YYModel/YYModel.h>
#import "YXDeviceInfo.h"

BOOL YX_ArchiveObject(id <NSCoding> object, NSString *filePath) {
    return [YXBaseCodingModel yx_archiveCodingObject:object filePath:filePath];
}

id YX_UnarchiveObject(NSString *filePath) {
    return [YXBaseCodingModel yx_unarchiveObjectWithFilePath:filePath];
}

BOOL YX_DeleteArchiveFile(NSString *filePath) {
    return [YXBaseCodingModel yx_deleteArchiveWithFilePath:filePath];
}

BOOL YX_DeleteAllArchiveFile(void) {
    return [YXBaseCodingModel yx_deleteAllArchiveFile];
}

BOOL YX_IsExistArchiveFile(NSString * _Nonnull filePath) {
    return [YXBaseCodingModel yx_isExistArchiveFile:filePath];
}

BOOL YX_IsExpiredArchiveFile(NSString * _Nonnull filePath, NSInteger cacheTime) {
    return [YXBaseCodingModel yx_isExpiredArchiveFile:filePath cacheTime:cacheTime];
}

@implementation YXBaseCodingModel

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

+ (BOOL)yx_archiveCodingObject:(id <NSCoding>)object filePath:(NSString *)filePath {
    if (filePath.length == 0) {
        return NO;
    }
    NSString *componentPath = [self getFolderPathWithFilePath:filePath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:componentPath]) {
        BOOL blCreateFolder= [fileManager createDirectoryAtPath:componentPath withIntermediateDirectories:YES attributes:nil error:NULL];
        if (!blCreateFolder) {
            return NO;
        }
    }
    return [NSKeyedArchiver archiveRootObject:object toFile:[self getEncryptFilePathWithFilePath:filePath]];
}

+ (nullable id)yx_unarchiveObjectWithFilePath:(NSString *)filePath {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getEncryptFilePathWithFilePath:filePath]];
}

+ (BOOL)yx_deleteAllArchiveFile {
    NSString *path = [YX_Library_Path() stringByAppendingPathComponent:@"yx_archive"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (blHave) {
        return [fileManager removeItemAtPath:path error:nil];
    }
    return YES;
}

+ (BOOL)yx_deleteArchiveWithFilePath:(NSString *)filePath {
    NSString *encrytFilePath = [self getEncryptFilePathWithFilePath:filePath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:encrytFilePath];
    if (blHave) {
        return [fileManager removeItemAtPath:encrytFilePath error:nil];
    }
    return YES;
}

/** 获取加密后的归档文件存储路径 */
+ (NSString *)getEncryptFilePathWithFilePath:(NSString *)filePath {
    NSString *componentPath = [YX_Library_Path() stringByAppendingPathComponent:@"yx_archive"];
    NSArray *paths = [filePath componentsSeparatedByString:@"/"];
    NSArray *subPaths = [paths bk_select:^BOOL(NSString *obj) {
        return obj.length > 0;
    }];
    if (subPaths.count > 0) {
        NSArray *encryptPaths = [subPaths bk_map:^NSString *(NSString *obj) {
            return [obj md5String];
        }];
        return [componentPath stringByAppendingPathComponent:[encryptPaths componentsJoinedByString:@"/"]];
    } else {
        return componentPath;
    }
}

/** 获取归档文件存放的文件夹路径 */
+ (NSString *)getFolderPathWithFilePath:(NSString *)filePath {
    NSString *componentPath = [YX_Library_Path() stringByAppendingPathComponent:@"yx_archive"];
    NSArray *paths = [filePath componentsSeparatedByString:@"/"];
    NSMutableArray *subPaths = [paths bk_select:^BOOL(NSString *obj) {
        return obj.length > 0;
    }].mutableCopy;
    if (subPaths.count > 1) {
        [subPaths removeLastObject];
        NSArray *encryptPaths = [subPaths bk_map:^NSString *(NSString *obj) {
            return [obj md5String];
        }];
        return [componentPath stringByAppendingPathComponent:[encryptPaths componentsJoinedByString:@"/"]];
    } else {
        return componentPath;
    }
}

+ (BOOL)yx_isExistArchiveFile:(NSString *)filePath {
    if (filePath.length == 0) {
        return NO;
    }
    NSString *componentPath = [self getEncryptFilePathWithFilePath:filePath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:componentPath];
}

+ (BOOL)yx_isExpiredArchiveFile:(NSString *)filePath cacheTime:(NSInteger)cacheTime {
    if (filePath.length == 0) {
        return YES;
    }
    NSError *error = nil;
    NSString *componentPath = [self getEncryptFilePathWithFilePath:filePath];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:componentPath error:&error];
    if (error || !fileAttributes) {
        return YES;
    }
    // 文件修改日期
    NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
    NSTimeInterval modTime = [fileModDate timeIntervalSince1970];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    return modTime + cacheTime < nowTime;
}

@end
