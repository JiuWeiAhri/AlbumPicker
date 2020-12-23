//
//  YXInLine.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#ifndef YXInline_h
#define YXInline_h

#import "YXTool.h"
#import "YXDeviceInfo.h"

/** 随机Bool值 */
CG_INLINE CGFloat YX_RandomBool() {
    return arc4random() % 2;
}

/** 分割线偏移量（防止渲染分割线时出现重影，详情参考：http://www.cnblogs.com/smileEvday/p/iOS_PixelVsPoint.html） */
CG_INLINE CGFloat YX_LineOffset() {
    return (1 / [UIScreen mainScreen].scale) / 2;
}

/** 分割线宽度（防止渲染分割线时出现重影，详情参考：http://www.cnblogs.com/smileEvday/p/iOS_PixelVsPoint.html） */
CG_INLINE CGFloat YX_LineWidth() {
    return 1 / [UIScreen mainScreen].scale;
}

/** 获取图片 */
CG_INLINE UIImage* YX_ImageNamed(NSString *imageName) {
    return [UIImage imageNamed:imageName];
}

/** 动态适配不同尺寸的比例, width为375下的宽度 */
CG_INLINE float YX_Scale375() {
    return YX_ScreenW() / 375.f;
}

/** 复制文字到剪切板 */
CG_INLINE void YX_CopyText(NSString *text) {
    [UIPasteboard generalPasteboard].string = text;
}

/** 拨打电话 */
CG_INLINE void YX_CallPhone(NSString *phone) {
    [YXTool callPhone:phone];
}

#endif /* YXInline_h */
