//
//  YXTransfer_HUD.h
//  YXKitDemo
//
//  Created by zx on 2018/3/30.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#ifndef YXHUDTransfer_h
#define YXHUDTransfer_h

#import <UIKit/UIKit.h>
#import "YXHUD.h"
#import "UIViewController+YXAdd.h"

/** window层上显示加载框（菊花、全局、不会自动消失，与YX_HUDHide()配对使用） */
CG_INLINE YXHUD* YX_HUDShow() {
    return [[YXHUD share] showLoading];
}

/** 关闭window层上的加载框（与YX_HUDShow()配对使用） */
CG_INLINE void YX_HUDHide() {
    [[YXHUD share] hide];
}

/** 在指定view上显示加载框（菊花、不会自动消失，与YX_HUDHideInView(UIView *view)配对使用） */
CG_INLINE YXHUD* YX_HUDShowInView(UIView *view) {
    YXHUD *yxHUD = [[YXHUD alloc] init];
    [yxHUD showLoading].hud_showInView(view);
    return yxHUD;
}

/** 隐藏指定view上的加载框（与YX_HUDShowInView(UIView *view)配对使用） */
CG_INLINE void YX_HUDHideInView(UIView *view) {
    [YXHUD hideInView:view];
}

/** window层上显示文字提示框，默认2秒消失 */
CG_INLINE YXHUD* YX_HUDShowMessage(NSString *message) {
    return [[YXHUD shareMessage] showMessage:message];
}

/** window层上显示文字提示框，默认2秒消失, 默认增加三个叹号，识别本地提示框 */
CG_INLINE YXHUD* YX_HUDShowLocalMessage(NSString *message) {
    return [[YXHUD shareMessage] showMessage:[message stringByAppendingString:@"!!!"]];
}

#endif /* YXTransfer_HUD_h */
