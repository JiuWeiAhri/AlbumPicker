//
//  UIImage+YXAdd.h
//  CaiYunXiaoKa
//
//  Created by zx on 2020/1/18.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YXAdd)

+ (nullable UIImage *)yx_imageWithColor:(UIColor *)color;

+ (nullable UIImage *)yx_imageWithColor:(UIColor *)color size:(CGSize)size;

/** 保存到相册 */
- (void)yx_saveToAlbumWithCompletionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
