//
//  UIImageView+YXWebImage.h
//  YXKitDemo
//
//  Created by zx on 2018/7/9.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, YXWebImageOptions) {
    /**
     * By default, when a URL fail to be downloaded, the URL is blacklisted so the library won't keep trying.
     * This flag disable this blacklisting.
     */
    YXWebImageRetryFailed = 1 << 0,
    
    /**
     * By default, image downloads are started during UI interactions, this flags disable this feature,
     * leading to delayed download on UIScrollView deceleration for instance.
     */
    YXWebImageLowPriority = 1 << 1,
    
    /**
     * This flag disables on-disk caching after the download finished, only cache in memory
     */
    YXWebImageCacheMemoryOnly = 1 << 2,
    
    /**
     * This flag enables progressive download, the image is displayed progressively during download as a browser would do.
     * By default, the image is only displayed once completely downloaded.
     */
    YXWebImageProgressiveDownload = 1 << 3,
    
    /**
     * Even if the image is cached, respect the HTTP response cache control, and refresh the image from remote location if needed.
     * The disk caching will be handled by NSURLCache instead of SDWebImage leading to slight performance degradation.
     * This option helps deal with images changing behind the same request URL, e.g. Facebook graph api profile pics.
     * If a cached image is refreshed, the completion block is called once with the cached image and again with the final image.
     *
     * Use this flag only if you can't make your URLs static with embedded cache busting parameter.
     */
    YXWebImageRefreshCached = 1 << 4,
    
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */
    YXWebImageContinueInBackground = 1 << 5,
    
    /**
     * Handles cookies stored in NSHTTPCookieStore by setting
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    YXWebImageHandleCookies = 1 << 6,
    
    /**
     * Enable to allow untrusted SSL certificates.
     * Useful for testing purposes. Use with caution in production.
     */
    YXWebImageAllowInvalidSSLCertificates = 1 << 7,
    
    /**
     * By default, images are loaded in the order in which they were queued. This flag moves them to
     * the front of the queue.
     */
    YXWebImageHighPriority = 1 << 8,
    
    /**
     * By default, placeholder images are loaded while the image is loading. This flag will delay the loading
     * of the placeholder image until after the image has finished loading.
     */
    YXWebImageDelayPlaceholder = 1 << 9,
    
    /**
     * We usually don't call transformDownloadedImage delegate method on animated images,
     * as most transformation code would mangle it.
     * Use this flag to transform them anyway.
     */
    YXWebImageTransformAnimatedImage = 1 << 10,
    
    /**
     * By default, image is added to the imageView after download. But in some cases, we want to
     * have the hand before setting the image (apply a filter or add it with cross-fade animation for instance)
     * Use this flag if you want to manually set the image in the completion when success
     */
    YXWebImageAvoidAutoSetImage = 1 << 11,
    
    /**
     * By default, images are decoded respecting their original size. On iOS, this flag will scale down the
     * images to a size compatible with the constrained memory of devices.
     * If `SDWebImageProgressiveDownload` flag is set the scale down is deactivated.
     */
    YXWebImageScaleDownLargeImages = 1 << 12,
    
    /**
     * By default, we do not query disk data when the image is cached in memory. This mask can force to query disk data at the same time.
     * This flag is recommend to be used with `SDWebImageQueryDiskSync` to ensure the image is loaded in the same runloop.
     */
    YXWebImageQueryDataWhenInMemory = 1 << 13,
    
    /**
     * By default, we query the memory cache synchronously, disk cache asynchronously. This mask can force to query disk cache synchronously to ensure that image is loaded in the same runloop.
     * This flag can avoid flashing during cell reuse if you disable memory cache or in some other cases.
     */
    YXWebImageQueryDiskSync = 1 << 14,
    
    /**
     * By default, when the cache missed, the image is download from the network. This flag can prevent network to load from cache only.
     */
    YXWebImageFromCacheOnly = 1 << 15,
    /**
     * By default, when you use `SDWebImageTransition` to do some view transition after the image load finished, this transition is only applied for image download from the network. This mask can force to apply view transition for memory and disk cache as well.
     */
    YXWebImageForceTransition = 1 << 16
};

typedef NS_ENUM(NSInteger, YXImageCacheType) {
    /**
     * The image wasn't available the SDWebImage caches, but was downloaded from the web.
     */
    YXImageCacheTypeNone,
    /**
     * The image was obtained from the disk cache.
     */
    YXImageCacheTypeDisk,
    /**
     * The image was obtained from the memory cache.
     */
    YXImageCacheTypeMemory
};

@interface YXImageViewConfig : NSObject

@property (nonatomic, strong) UIImage * _Nullable defaultPlaceholderImage; /**< 默认占位图，设置后，所有图片都默认带此效果，不支持约束布局 */
@property (nonatomic, assign) CGSize defaultPlaceholderMinSize; /**< 默认占位图生效的最小尺寸 */
@property (nonatomic, assign) CGSize defaultPlaceholderMaxSize; /**< 默认占位图生效的最大尺寸 */

YX_ShareInstance_h(YXImageViewConfig)

@end


@interface UIImageView (YXWebImage)

typedef void(^YXExternalCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error, YXImageCacheType cacheType, NSURL * _Nullable imageURL);

- (void)yx_setImageWithURL:(nullable NSURL *)url;

- (void)yx_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder;

- (void)yx_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(YXWebImageOptions)options
                 completed:(nullable YXExternalCompletionBlock)completedBlock;

- (void)yx_setImageWithURLString:(nullable NSString *)url;

- (void)yx_setImageWithURLString:(nullable NSString *)url
                placeholderImage:(nullable UIImage *)placeholder;

- (void)yx_setImageWithURLString:(nullable NSString *)url
                placeholderImage:(nullable UIImage *)placeholder
                         options:(YXWebImageOptions)options
                       completed:(nullable YXExternalCompletionBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
