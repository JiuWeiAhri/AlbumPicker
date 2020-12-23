//
//  YXAlert.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/16.
//  Copyright © 2020 张鑫. All rights reserved.
//

#ifndef YXAlert_h
#define YXAlert_h

#import "UIAlertController+YXAdd.h"
#import "NSArray+YXAdd.h"
#import "PopoverView.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Alert

/// 显示提示Alert提示框，只有好的按钮
CG_INLINE void YX_ShowPromptAlert(NSString *title, _Nullable YX_ClickBlock confirmBlock) {
    [UIAlertController yx_showAlertWithTitle:title message:nil cancel:nil destructive:nil others:@[@"好的"] tapBlock:nil customUIBlock:^(UIAlertController * _Nonnull alertVC) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
}

/// 显示确认Alert提示框，有确定和取消2个按钮
CG_INLINE void YX_ShowConfirmAlert(NSString *title, _Nullable YX_ClickBlock confirmBlock, _Nullable YX_ClickBlock cancelBlock) {
    [UIAlertController yx_showAlertWithTitle:title message:nil cancel:@"取消" destructive:nil others:@[@"确定"] tapBlock:^(NSString * _Nonnull title, NSInteger buttonIndex, BOOL isCancel, BOOL isDestructive) {
        /// 取消
        if (isCancel && cancelBlock) {
            cancelBlock();
        }
        /// 确定
        else if (!isCancel && confirmBlock) {
            confirmBlock();
        }
    } customUIBlock:nil];
}

/// 显示Alert提示框
CG_INLINE void YX_ShowAlert(NSString * _Nullable title,  NSString * _Nullable message, NSString * _Nullable cancel, NSArray * _Nullable others, YX_ClickBtnBlock clickBtnBlock) {
    [UIAlertController yx_showAlertWithTitle:title message:message cancel:cancel destructive:nil others:others tapBlock:^(NSString * _Nonnull title, NSInteger buttonIndex, BOOL isCancel, BOOL isDestructive) {
        if (clickBtnBlock) {
            clickBtnBlock(title, buttonIndex, isCancel, isDestructive);
        }
    } customUIBlock:nil];
}

/// 显示自定义Alert提示框
CG_INLINE void YX_ShowCustomAlert(NSString * _Nullable title, NSString * _Nullable message, NSString * _Nullable cancel, NSArray * _Nullable others, YX_ClickBtnBlock clickBtnBlock, _Nullable YX_CustomUIBlock customUIBlock) {
    [UIAlertController yx_showAlertWithTitle:title message:message cancel:cancel destructive:nil others:others tapBlock:^(NSString * _Nonnull title, NSInteger buttonIndex, BOOL isCancel, BOOL isDestructive) {
        if (clickBtnBlock) {
            clickBtnBlock(title, buttonIndex, isCancel, isDestructive);
        }
    } customUIBlock:customUIBlock];
}

#pragma mark - ActionSheet

/// 显示ActionSheet提示框
CG_INLINE void YX_ShowActionSheet(NSString * _Nullable title, NSString * _Nullable message, NSArray *titles, YX_ClickBtnBlock block, _Nullable YX_CustomUIBlock customUIBlock) {
    [UIAlertController yx_showActionSheetWithTitle:title message:message cancel:@"取消" destructive:nil others:titles tapBlock:block customUIBlock:customUIBlock];
}

#pragma mark - PopMenu

/// 显示菜单提示框，基于某个视图，自动定位（类似于微信右上角的加号）
CG_INLINE void YX_ShowPopMenu(UIView *showToView, NSArray * _Nullable titles, NSArray * _Nullable images, YX_ClickPopBtnBlock block) {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++) {
        
        UIImage *image = [images yx_objectAtSafeIndex:i];
        PopoverAction *action = [PopoverAction actionWithImage:image title:titles[i] handler:^(PopoverAction *action) {
            if (block) {
                block(action.title, i);
            }
        }];
        
        [array addObject:action];
    }
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.hideAfterTouchOutside = NO;
    [popoverView showToView:showToView withActions:array];
}

/// 显示菜单提示框，指定位置（类似于微信右上角的加号）
CG_INLINE void YX_ShowPopMenuToPoint(CGPoint showToPoint, NSArray *titles, NSArray *images, YX_ClickPopBtnBlock block) {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++) {
        
        UIImage *image = [images yx_objectAtSafeIndex:i];
        PopoverAction *action = [PopoverAction actionWithImage:image title:titles[i] handler:^(PopoverAction *action) {
            if (block) {
                block(action.title, i);
            }
        }];
        
        [array addObject:action];
    }
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.hideAfterTouchOutside = NO;
    [popoverView showToPoint:showToPoint withActions:array];
}

NS_ASSUME_NONNULL_END

#endif /* YXAlert_h */

