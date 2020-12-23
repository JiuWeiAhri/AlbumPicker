//
//  UIView+YXAdd.m
//  CaiYunXiaoKa
//
//  Created by zx on 2020/1/5.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "UIView+YXAdd.h"
#import "YXColor.h"
#import <BlocksKit/UIView+BlocksKit.h>
#import "YXTools.h"
#import <Masonry/Masonry.h>
#import "UIView+YXFrame.h"

@implementation YXViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alignment = YXHorizontalAlignment_Center;
    }
    return self;
}

@end

@implementation UIView (YXAdd)

#pragma mark - YXCreat

#pragma mark - YXAdd

- (CGFloat)minX_yx {
    return self.frame.origin.x;
}

- (void)setMinX_yx:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)minY_yx {
    return self.frame.origin.y;
}

- (void)setMinY_yx:(CGFloat)minY_yx {
    CGRect frame = self.frame;
    frame.origin.y = minY_yx;
    self.frame = frame;
}

- (CGFloat)maxX_yx {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMaxX_yx:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x - frame.size.width;
    self.frame = frame;
}

- (CGFloat)maxY_yx {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMaxY_yx:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX_yx {
    return self.center.x;
}

- (void)setCenterX_yx:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY_yx {
    return self.center.y;
}

- (void)setCenterY_yx:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width_yx {
    return self.frame.size.width;
}

- (void)setWidth_yx:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height_yx {
    return self.frame.size.height;
}

- (void)setHeight_yx:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin_yx {
    return self.frame.origin;
}

- (void)setOrigin_yx:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size_yx {
    return self.frame.size;
}

- (void)setSize_yx:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIViewController *)yx_currentVC {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)yx_alignmentCenterX {
    if (self.superview) {
        self.minX_yx = (self.superview.frame.size.width - self.frame.size.width) / 2.f;
    }
}

- (void)yx_alignmentCenterY {
    if (self.superview) {
        self.minY_yx = (self.superview.frame.size.height - self.frame.size.height) / 2.f;
    }
}

- (void)yx_alignmentCenter {
    [self yx_alignmentCenterX];
    [self yx_alignmentCenterY];
}

- (void)yx_removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

/// 旋转180动画
- (void)yx_transformAnimation:(float)f {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI * f);
    }];
}

/** 截屏 */
- (UIImage *)yx_captureScreen {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height), NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

/// 当前控制器
- (UIViewController*)yx_viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/** 竖向排列子视图，横向居中,使用约束（便于修改子视图高度时，后续视图自动变化） */
- (void)yx_sortSubviewsByAutoLayout:(NSArray *)subviews {
    
    UIView *superView = [self isKindOfClass:[UIScrollView class]] ? [[UIView alloc] init] : self;
    
    UIView *lastView = nil;
    for (int i = 0; i < subviews.count; i++) {
        UIView *view = subviews[i];
        CGRect frame = view.frame;
        [superView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(frame.size.width));
        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView ? lastView.mas_bottom : @0).offset(frame.origin.y);
            make.left.equalTo(@(frame.origin.x));
        }];
        
        lastView = view;
    }
    
    if (lastView) {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
        }];
    }
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        [self addSubview:superView];
        [superView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.equalTo(self);
        }];
    }
    
    [self layoutIfNeeded];
}

/** 竖向排列子视图，横向居中,使用Frame约束 */
- (void)yx_sortSubviewsByFrame:(NSArray *)subviews {
    UIView *lastView = nil;
    for (int i = 0; i < subviews.count; i++) {
        UIView *view = subviews[i];
        [self addSubview:view];
        CGFloat space = view.minY_yx;
        view.minY_yx = lastView.maxY_yx + space;
        [view yx_alignmentCenterX];
        lastView = view;
    }
}

/// 竖向排列子视图，横向居中 paddings：视图垂直方向的间距
/// 竖向排列子视图，横向居中 paddings：视图垂直方向的间距
- (void)yx_sortSubviewsByFrame:(NSArray<UIView *> *)subviews paddings:(NSArray<NSNumber *> *)paddings configBlock:(void(^)(YXViewConfig *config))configBlock {
    
    YXViewConfig *config = [[YXViewConfig alloc] init];
    
    if (configBlock) {
        configBlock(config);
    }
    
    UIView *lastView = nil;
    for (int i = 0; i < subviews.count; i++) {
        UIView *view = subviews[i];
        [self addSubview:view];
        CGFloat space = [[paddings yx_objectAtSafeIndex:i] floatValue];
        view.minY_yx = lastView.maxY_yx + space;
        
        if (config.alignment == YXHorizontalAlignment_Left) {
            view.minX = config.leading;
        } else if (config.alignment == YXHorizontalAlignment_Center) {
            [view yx_alignmentCenterX];
            view.minX += config.leading;
            view.minX -= config.trailing;
        } else if (config.alignment == YXHorizontalAlignment_Right) {
            view.maxX = self.width;
            view.maxX -= config.trailing;
        }
        
        lastView = view;
    }
}

/// 快速添加多组文字
- (NSArray<UILabel *> *)yx_addSubLabelsWithTitles:(NSArray<NSString *> *)titles colors:(NSArray<UIColor *> *)colors fonts:(NSArray<UIFont *> *)fonts paddings:(NSArray<NSNumber *> *)paddings textAlignments:(NSArray<NSNumber *> *)textAlignments verticalAlignment:(YXVerticalAlignment)verticalAlignment contentEdgeInset:(UIEdgeInsets)contentEdgeInset {
    NSMutableArray<UILabel *> *array = [NSMutableArray array];
    UILabel *lastView = nil;
    for (int i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(contentEdgeInset.left, lastView.maxY + (i == 0 ? contentEdgeInset.top : [paddings[i - 1] floatValue]), self.width - contentEdgeInset.left - contentEdgeInset.right, 0)];
        label.numberOfLines = 0;
        label.text = titles[i];
        label.textColor = colors[i];
        label.font = fonts[i];
        label.textAlignment = [textAlignments[i] integerValue];
        label.height = [label sizeThatFits:CGSizeMake(label.width, CGFLOAT_MAX)].height;
        label.maxY -= contentEdgeInset.bottom;
        [self addSubview:label];
        lastView = label;
        [array addObject:label];
    }
    
    for (UILabel *label in array) {
        /** 纵向剧中 */
        if (verticalAlignment == YXVerticalAlignment_Middle) {
            label.minY += (self.height - array.lastObject.maxY) / 2.f;
        }
        /** 纵向底部对齐 */
        else if (verticalAlignment == YXVerticalAlignment_Bottom) {
            label.minY += self.height - array.lastObject.maxY;
        }
    }
    
    return array;
}

- (UIView *)yx_subviewWithFirstResponder {
    if ([self isFirstResponder])
        return self;
    
    for (UIView *subview in self.subviews) {
        UIView *view = [subview yx_subviewWithFirstResponder];
        if (view) return view;
    }
    
    return nil;
}

- (UIView *)yx_subviewWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* subview in self.subviews) {
        UIView* view = [subview yx_subviewWithClass:cls];
        if (view) return view;
    }
    
    return nil;
}

- (UIView *)yx_superviewWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview yx_superviewWithClass:cls];
    } else {
        return nil;
    }
}

- (NSArray *)yx_subviewsWtihClass:(Class)cls {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ([self isKindOfClass:cls])
        [array addObject:self];
    
    for (UIView *subview in self.subviews) {
        NSArray *array_Temp = [subview yx_subviewsWtihClass:cls];
        if (array_Temp.count > 0)
            [array addObjectsFromArray:array_Temp];
    }
    return array;
}

#pragma mark - 分割线 & 虚线

/// 添加横向分割线
- (UIView *)yx_addHorizontalLineWithMinX:(CGFloat)minX minY:(CGFloat)minY width:(CGFloat)width {
    CGFloat minY_temp = (minY + YX_LineOffset()) > self.height ? (minY - YX_LineOffset()) : (minY + YX_LineOffset());
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(minX, minY_temp, width, YX_LineWidth())];
    view.backgroundColor = YX_LineColor();
    [self addSubview:view];
    return view;
}

/// 添加纵向分割线
- (UIView *)yx_addVerticalLineWithMinY:(CGFloat)minY minX:(CGFloat)minX height:(CGFloat)height {
    CGFloat minX_temp = (minX + YX_LineOffset()) > self.width ? (minX - YX_LineOffset()) : (minX + YX_LineOffset());
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(minX_temp, minY, YX_LineWidth(), height)];
    view.backgroundColor = YX_LineColor();
    [self addSubview:view];
    return view;
}

/// 添加分割线
- (CALayer *)yx_addLineOfPostion:(YXLineViewPosition)position {
    
    CGFloat minX = 0, minY = 0, width = 0, height = 0;
    if (position == YXLineViewPosition_Top) {
        minX = YX_LineOffset();
        minY = 0;
        width = self.width_yx;
        height = YX_LineWidth();
    } else if (position == YXLineViewPosition_Left) {
        minX = YX_LineOffset();
        minY = 0;
        width = YX_LineWidth();
        height = self.height_yx;
    } else if (position == YXLineViewPosition_Bottom) {
        minX = 0;
        minY = self.height_yx - YX_LineOffset();
        width = self.width_yx;
        height = YX_LineWidth();
    } else if (position == YXLineViewPosition_Right) {
        minX = self.width_yx - YX_LineOffset();
        minY = 0;
        width = YX_LineWidth();
        height = self.height_yx;
    }
    
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.backgroundColor = YX_LineColor().CGColor;
    lineLayer.frame = CGRectMake(minX, minY, width, height);
    [self.layer addSublayer:lineLayer];
    
    return lineLayer;
}

/// 添加虚线
- (void)yx_addDashLineWithPointArray:(NSArray *)array
                           lineWidth:(int)lineWidth
                        spacingWidth:(int)spacingWidth
                           lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为lineColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineWidth], [NSNumber numberWithInt:spacingWidth], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint point = CGPointFromString(array[0]);
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    
    for (NSInteger i=1; i<array.count; i++) {
        CGPoint point = CGPointFromString(array[i]);
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}

#pragma mark - 圆角

/// 添加圆角 UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight|UIRectCornerAllCorners
- (void)yx_addCorner:(UIRectCorner)corner cornerRadius:(CGFloat)cornerRadius {
    CGRect frame = CGRectMake(0, 0, self.width_yx, self.height_yx);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame
                                               byRoundingCorners:corner
                                                     cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = frame;
    layer.path = path.CGPath;
    
    self.layer.mask = layer;
}

/// 添加圆角UIRectCornerAllCorners
- (void)yx_setCornerRadius:(CGFloat)cornerRadius {
    [self yx_addCorner:UIRectCornerAllCorners cornerRadius:cornerRadius];
}

#pragma mark - YXBlock

/// 添加点击block
- (void)yx_addTappedBlock:(void (^)(void))block {
    [self bk_whenTapped:block];
}

/// 添加双击block
- (void)yx_addDoubleTapped:(void (^)(void))block {
    [self bk_whenDoubleTapped:block];
}

@end
