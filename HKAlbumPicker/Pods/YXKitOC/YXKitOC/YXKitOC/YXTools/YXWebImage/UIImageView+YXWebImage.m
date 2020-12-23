//
//  UIImageView+YXWebImage.m
//  YXKitDemo
//
//  Created by zx on 2018/7/9.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#import "UIImageView+YXWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YXImageViewConfig

YX_ShareInstance_m(YXImageViewConfig)

@end

@implementation UIImageView (YXWebImage)

- (void)yx_setImageWithURL:(nullable NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:[self defaultPlaceholderImage]];
}

- (void)yx_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder {
    
    [self sd_setImageWithURL:url placeholderImage:placeholder ? : [self defaultPlaceholderImage]];
}

- (void)yx_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(YXWebImageOptions)options
                 completed:(nullable YXExternalCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder ? : [self defaultPlaceholderImage] options:(SDWebImageOptions)options completed:(SDExternalCompletionBlock)completedBlock];
}

- (void)yx_setImageWithURLString:(nullable NSString *)url {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[self defaultPlaceholderImage]];
}

- (void)yx_setImageWithURLString:(nullable NSString *)url
                placeholderImage:(nullable UIImage *)placeholder {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder ? : [self defaultPlaceholderImage]];
}

- (void)yx_setImageWithURLString:(nullable NSString *)url
                placeholderImage:(nullable UIImage *)placeholder
                         options:(YXWebImageOptions)options
                       completed:(nullable YXExternalCompletionBlock)completedBlock {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder ? : [self defaultPlaceholderImage] options:(SDWebImageOptions)options completed:(SDExternalCompletionBlock)completedBlock];
}

#pragma mark - Private Func

- (UIImage *)defaultPlaceholderImage {
    
    // 没有设置默认占位图，不加载
    UIImage *placeholder = [YXImageViewConfig sharedYXImageViewConfig].defaultPlaceholderImage;
    if (!placeholder) {
        return nil;
    }
    
    // 小于占位图最小尺寸，不加载
    BOOL isLessThan = self.frame.size.width < [YXImageViewConfig sharedYXImageViewConfig].defaultPlaceholderMinSize.width || self.frame.size.height < [YXImageViewConfig sharedYXImageViewConfig].defaultPlaceholderMinSize.height;
    if (isLessThan) {
        return nil;
    }
    
    // 大于占位图最小尺寸，不加载
    BOOL isLargeThan = self.frame.size.width > [YXImageViewConfig sharedYXImageViewConfig].defaultPlaceholderMaxSize.width || self.frame.size.height > [YXImageViewConfig sharedYXImageViewConfig].defaultPlaceholderMaxSize.height;
    if (isLargeThan) {
        return nil;
    }
    
    // 满足条件，加载默认占位图
    return placeholder;
}

@end
