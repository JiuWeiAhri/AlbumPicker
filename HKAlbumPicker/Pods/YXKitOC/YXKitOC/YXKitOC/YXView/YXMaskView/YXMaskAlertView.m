//
//  CustomAlertView.m
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/2/3.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "YXMaskAlertView.h"
#import "YXKitOC.h"

@interface YXMaskAlertView ()

@property (nonatomic, strong) UIScrollView *scrollView; /**< 最底部滑动视图 */
@property (nonatomic, strong) UIControl *backgraoundControl; /**< 黑色背景 */

@end

@implementation YXMaskAlertView

+ (instancetype)showWithContentView:(UIView *)contentView showType:(YXMaskAlertViewShowType)showType {
    
    UIViewController *topVC = [UIViewController yx_currentVC].navigationController ? : [UIViewController yx_currentVC];
    topVC = topVC.navigationController ? : topVC;
    topVC = topVC.tabBarController ? : topVC;
    
    return [self showWithContentView:contentView showType:showType showInVC:topVC];
}

+ (instancetype)showWithContentView:(UIView *)contentView showType:(YXMaskAlertViewShowType)showType showInVC:(UIViewController *)showInVC {
    
    UIViewController *vc = showInVC;
    if (!showInVC) {
        vc = [UIViewController yx_currentVC].navigationController ? : [UIViewController yx_currentVC];
        vc = vc.navigationController ? : vc;
        vc = vc.tabBarController ? : vc;
    }
    
    contentView.userInteractionEnabled = YES;
    
    YXMaskAlertView *alertView = [[YXMaskAlertView alloc] initWithFrame:showInVC.view.bounds];
    alertView.isCloseWhenClickBackground = YES;
    alertView.contentView = contentView;
    alertView.showType = showType;
    [showInVC.view addSubview:alertView];
    [alertView creatView];
    return alertView;
}

#pragma mark - Click Button

/** 点击背景关闭视图 */
- (void)clickBackgroundControl:(UIControl *)control {
    if (self.isCloseWhenClickBackground) {
        [self close];
    }
}

#pragma mark - Public Func

- (void)close {
    
    /** 黑色背景过度动画 */
    [UIView transitionWithView:self.contentView duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.contentView.minY_yx = self.scrollView.height_yx;
    } completion:^(BOOL finished) {
        [self->_scrollView yx_removeAllSubviews];
        self->_scrollView = nil;
        [self yx_removeAllSubviews];
        [self removeFromSuperview];
    }];
    
    [UIView transitionWithView:self.backgraoundControl duration:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgraoundControl.backgroundColor = YX_Color16A(0x000000, 0.0f);
    } completion:nil];
}

/** 自定义视图高度变化后刷新Frame */
- (void)reloadContentViewSize {
    /** ActionSheet样式 */
    if (self.showType == YXMaskAlertViewShowType_ActionSheet) {
        [self.contentView yx_addCorner:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:10];
        [self.contentView yx_alignmentCenterX];
        self.contentView.maxY_yx = self.scrollView.height_yx;
    }
    /** Alert样式 */
    else {
        [self.contentView yx_addCorner:UIRectCornerAllCorners cornerRadius:10];
        [self.contentView yx_alignmentCenter];
    }
}

#pragma mark - Private Func

- (void)creatView {
    [self addSubview:self.scrollView];
}

#pragma mark - Getter

- (UIControl *)backgraoundControl {
    if (!_backgraoundControl) {
        _backgraoundControl = [[UIControl alloc] initWithFrame:self.scrollView.bounds];
        _backgraoundControl.backgroundColor = YX_Color16A(0x000000, 0.4f);
        [_backgraoundControl addTarget:self action:@selector(clickBackgroundControl:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgraoundControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        [_scrollView addSubview:self.backgraoundControl];
        [_scrollView addSubview:self.contentView];
        
        /** 黑色背景过度动画 */
        self.backgraoundControl.backgroundColor = YX_Color16A(0x000000, 0.f);
        [UIView transitionWithView:self.backgraoundControl duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.backgraoundControl.backgroundColor = YX_Color16A(0x000000, 0.5f);
        } completion:nil];
        
        /** ActionSheet样式 */
        if (self.showType == YXMaskAlertViewShowType_ActionSheet) {
            [self.contentView yx_addCorner:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:10];
            
            self.contentView.minY_yx = self.scrollView.height_yx;
            [self.contentView yx_alignmentCenterX];
            [UIView transitionWithView:self.contentView duration:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.contentView.maxY_yx = self.scrollView.height_yx;
            } completion:nil];
        }
        /** Alert样式 */
        else {
            [self.contentView yx_addCorner:UIRectCornerAllCorners cornerRadius:10];
            [self.contentView yx_alignmentCenter];
        }
        
        self.scrollView.contentSize = self.scrollView.size_yx;
    }
    return _scrollView;
}

@end
