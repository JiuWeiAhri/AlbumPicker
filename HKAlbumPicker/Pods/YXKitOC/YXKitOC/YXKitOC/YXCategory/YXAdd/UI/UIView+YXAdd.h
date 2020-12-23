//
//  UIView+YXAdd.h
//  CaiYunXiaoKa
//
//  Created by zx on 2020/1/5.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXLineViewPosition) {
    YXLineViewPosition_Top,
    YXLineViewPosition_Left,
    YXLineViewPosition_Bottom,
    YXLineViewPosition_Right,
};

/** 添加Labels竖直方向的对齐方式 */
typedef NS_ENUM(NSUInteger, YXVerticalAlignment) {
    YXVerticalAlignment_Top,
    YXVerticalAlignment_Middle,
    YXVerticalAlignment_Bottom,
};

/** 水平方向的对齐方式 */
typedef NS_ENUM(NSUInteger, YXHorizontalAlignment) {
    YXHorizontalAlignment_Left,
    YXHorizontalAlignment_Center,
    YXHorizontalAlignment_Right,
};

@interface YXViewConfig : NSObject

@property (nonatomic, assign) CGFloat leading; /**< 居左距离 */
@property (nonatomic, assign) CGFloat trailing; /**< 居右距离 */
@property (nonatomic, assign) YXHorizontalAlignment alignment; /**< 对其方式 */

@end

@interface UIView (YXAdd)

#pragma mark - YXCreat

#pragma mark - YXAdd

/* frame.origin.x */
@property (nonatomic) CGFloat minX_yx;

/* frame.origin.y */
@property (nonatomic) CGFloat minY_yx;

/* frame.origin.x + frame.size.width */
@property (nonatomic) CGFloat maxX_yx;

/* frame.origin.y + frame.size.height */
@property (nonatomic) CGFloat maxY_yx;

/* frame.size.width */
@property (nonatomic) CGFloat width_yx;

/* frame.size.height */
@property (nonatomic) CGFloat height_yx;

/* center.x */
@property (nonatomic) CGFloat centerX_yx;

/* center.y */
@property (nonatomic) CGFloat centerY_yx;

/* frame.origin */
@property (nonatomic) CGPoint origin_yx;

/* frame.size */
@property (nonatomic) CGSize size_yx;

/// 当前所在ViewContoller
@property (nonatomic, weak, readonly) UIViewController *yx_currentVC;

/// 横向居中
- (void)yx_alignmentCenterX;

/// 纵向居中
- (void)yx_alignmentCenterY;

/// 横向+纵向居中
- (void)yx_alignmentCenter;

/// 移除所有子视图
- (void)yx_removeAllSubviews;

/// 旋转180动画
- (void)yx_transformAnimation:(float)f;

/// 当前控制器
- (UIViewController *)yx_viewController;

/// 竖向排列子视图，横向居中,使用约束（便于修改子视图高度时，后续视图自动变化）
- (void)yx_sortSubviewsByAutoLayout:(NSArray *)subviews;

/// 竖向排列子视图，横向居中,使用Frame约束
- (void)yx_sortSubviewsByFrame:(NSArray *)subviews;

/// 竖向排列子视图，横向居中 paddings：视图垂直方向的间距
- (void)yx_sortSubviewsByFrame:(NSArray<UIView *> *)subviews paddings:(NSArray<NSNumber *> *)paddings configBlock:(nullable void(^)(YXViewConfig *config))configBlock;

/// 快速添加多组文字
- (NSArray<UILabel *> *)yx_addSubLabelsWithTitles:(NSArray<NSString *> *)titles colors:(NSArray<UIColor *> *)colors fonts:(NSArray<UIFont *> *)fonts paddings:(NSArray<NSNumber *> *)paddings textAlignments:(NSArray<NSNumber *> *)textAlignments verticalAlignment:(YXVerticalAlignment)verticalAlignment contentEdgeInset:(UIEdgeInsets)contentEdgeInset;

- (UIView *)yx_subviewWithFirstResponder;
- (UIView *)yx_superviewWithClass:(Class)cls;
- (UIView *)yx_subviewWithClass:(Class)cls;
- (NSArray *)yx_subviewsWtihClass:(Class)cls;

#pragma mark - 分割线 & 虚线

/// 添加横向分割线
- (UIView *)yx_addHorizontalLineWithMinX:(CGFloat)minX minY:(CGFloat)minY width:(CGFloat)width;

/// 添加纵向分割线
- (UIView *)yx_addVerticalLineWithMinY:(CGFloat)minY minX:(CGFloat)minX height:(CGFloat)height;

/// 添加分割线
- (CALayer *)yx_addLineOfPostion:(YXLineViewPosition)position;

/// 添加虚线
- (void)yx_addDashLineWithPointArray:(NSArray *)array
                           lineWidth:(int)lineWidth
                        spacingWidth:(int)spacingWidth
                           lineColor:(UIColor *)lineColor;

/** 截屏 */
- (UIImage *)yx_captureScreen;

#pragma mark - 圆角

/// 添加圆角 UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight|UIRectCornerAllCorners
- (void)yx_addCorner:(UIRectCorner)corner cornerRadius:(CGFloat)cornerRadius;
/// 添加圆角UIRectCornerAllCorners
- (void)yx_setCornerRadius:(CGFloat)cornerRadius;

#pragma mark - YXBlock

/// 添加点击block
- (void)yx_addTappedBlock:(void (^)(void))block;

/// 添加双击block
- (void)yx_addDoubleTapped:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
