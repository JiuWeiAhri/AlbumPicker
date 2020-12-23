//
//  UIImage+YXAdd.m
//  CaiYunXiaoKa
//
//  Created by zx on 2020/1/18.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "UIImage+YXAdd.h"
#import <YYCategories/UIImage+YYAdd.h>
#import <Photos/PHAssetChangeRequest.h>

@implementation UIImage (YXAdd)

+ (nullable UIImage *)yx_imageWithColor:(UIColor *)color {
    return [UIImage imageWithColor:color];
}

+ (nullable UIImage *)yx_imageWithColor:(UIColor *)color size:(CGSize)size {
    return [UIImage imageWithColor:color size:size];
}

/** 保存到相册 */
- (void)yx_saveToAlbumWithCompletionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:self];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(success, error);
            });
        }
    }];
}

@end
