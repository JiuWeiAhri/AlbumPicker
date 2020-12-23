//
//  YXPullDownMenuView.m
//  YXKitOC
//
//  Created by 李鹏飞 on 2020/4/2.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXPullDownMenuView.h"
#import "YXKitOC.h"
#import "YXMenuFilterConfig.h"

@interface YXPullDownMenuView () {
    
}

@property (nonatomic, strong) NSMutableArray *indicators; /**< 箭头数组 */
@property (nonatomic, strong) NSMutableArray *titleLayers; /**< title layer数组 */

@property (nonatomic, strong) UIView *backgroundView; /**< 下拉背景View */

@property (nonatomic, assign) NSInteger numberOfMenu; /**< 菜单个数 */
@property (nonatomic, assign) NSInteger currentSelectedMenuIndex; /**< 选中的上一个index */

@property (nonatomic, assign) BOOL show; /**< 当前菜单是否展开的状态 */

@property (nonatomic, assign) BOOL narrowFont;/**< 缩小字体 */

@end

@implementation YXPullDownMenuView

#pragma mark - life cycle

- (id)init {
    self = [super init];
    if (self) {
        [self loadDefaultData];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadDefaultData];
    }
    return self;
}

#pragma mark - private methods

- (void)confiMenuWithSelectRow:(NSInteger)row
{
    CATextLayer *title = (CATextLayer *)self.titleLayers[_currentSelectedMenuIndex];
    title.string = [[self.titles objectAtIndex:_currentSelectedMenuIndex] objectAtIndex:row];
    __weak typeof(self)weakSelf = self;
    [self animateIdicator:self.indicators[_currentSelectedMenuIndex] background:self.backgroundView view:nil title:self.titleLayers[_currentSelectedMenuIndex] forward:NO complecte:^{
        weakSelf.show = NO;
    }];
    
    CAShapeLayer *indicator = (CAShapeLayer *)self.indicators[_currentSelectedMenuIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}

- (void)loadDefaultData {
    _normalColor = [YXMenuFilterConfig sharedYXMenuFilterConfig].normalTextColor;
    _selectedColor = [YXMenuFilterConfig sharedYXMenuFilterConfig].selectedTextColor;
    _currentSelectedMenuIndex = -1;
    _show = NO;
}

- (void)loadView {
    self.indicators = [NSMutableArray array];
    self.titleLayers = [NSMutableArray array];
    CGFloat itemWidth = self.frame.size.width;
    _numberOfMenu = self.titles.count;
    
    CGFloat textLayerInterval = itemWidth / ( _numberOfMenu * 2);
    /** 暂时去掉中间的分割线，留着以后用到再打开
    CGFloat separatorLineInterval = itemWidth / _numberOfMenu;
     */
    
    for (int i = 0; i < _numberOfMenu; i++) {
        
        if (_numberOfMenu > 4) {
            self.narrowFont = YES;
        }
        
        CGPoint position = CGPointMake((i * 2 + 1) * textLayerInterval - 5, self.frame.size.height / 2);
        
        CATextLayer *title = [self creatTextLayerWithNSString:self.titles[i]
                                                    withColor:_normalColor
                                                  andPosition:position];
        [self.layer addSublayer:title];
        [self.titleLayers addObject:title];
        
        CAShapeLayer *indicator = [self creatIndicatorWithColor:_normalColor andPosition:CGPointMake(position.x + title.bounds.size.width / 2 + 5 + 5, self.frame.size.height / 2)];
        
        [self.layer addSublayer:indicator];
        [self.indicators addObject:indicator];
        
        /** 暂时去掉中间的分割线，留着以后用到再打开
        if (i != (_numberOfMenu - 1)) {
            CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height / 2);
            CAShapeLayer *separator = [self creatSeparatorLineWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
         */
    }
    
    UILabel *line = [UILabel new];
    line.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    line.backgroundColor = YX_Color16(0xeeeeee);
    [self addSubview:line];
    
    self.backgroundColor = YX_Color16(0xFFFFFF);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    tapGesture = nil;
}

#pragma mark - public methods

- (void)finished {
    __weak typeof(self)weakSelf = self;
    if (_show) {
        [self animateIdicator:self.indicators[_currentSelectedMenuIndex]
                   background:_backgroundView
                         view:[self.dataSource itemViewForPullDownMenu:self
                                                             menuIndex:_currentSelectedMenuIndex]
                        title:self.titleLayers[_currentSelectedMenuIndex]
                      forward:NO
                    complecte:^{
            weakSelf.show = NO;
        }];
    }
}

#pragma mark - event methods

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    
    NSInteger tapIndex = touchPoint.x / ((self.frame.size.width) / _numberOfMenu);
    if (tapIndex >= self.titles.count) {
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    UIView *itemView = [self.dataSource itemViewForPullDownMenu:self menuIndex:tapIndex];
    
    for (int i = 0; i < _numberOfMenu; i++) {
        if (i != tapIndex) {
            UIView *view = [self.dataSource itemViewForPullDownMenu:self menuIndex:i];
            [self animateIdicator:self.indicators[i]
                       background:self.backgroundView
                             view:view
                            title:self.titleLayers[i]
                          forward:NO
                        complecte:^{
            }];
        } else {
            
            if (tapIndex != _currentSelectedMenuIndex) {
                if (_currentSelectedMenuIndex != -1) {
                    _show = NO;
                }
            }
            [self animateIdicator:self.indicators[tapIndex]
                       background:self.backgroundView
                             view:itemView
                            title:self.titleLayers[tapIndex]
                          forward:!weakSelf.show
                        complecte:^{
                weakSelf.show = !weakSelf.show;
            }];
            
            
        }
    }
    
    _currentSelectedMenuIndex = tapIndex;
}

- (void)handleTapBackgroundView:(UITapGestureRecognizer *)tap {
    UIView *view = [self.dataSource itemViewForPullDownMenu:self menuIndex:_currentSelectedMenuIndex];
    __weak typeof(self)weakSelf = self;
    
    [self animateIdicator:self.indicators[_currentSelectedMenuIndex]
               background:self.backgroundView
                     view:view
                    title:self.titleLayers[_currentSelectedMenuIndex]
                  forward:NO
                complecte:^{
        weakSelf.show = NO;
    }];
}

#pragma mark - animation

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background view:(UIView *)view title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)(void))complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackgroundView:background show:forward complete:^{
                [self animateItemView:view show:forward complete:^{
                    
                }];
            }];
        }];
    }];
    
    complete();
}

- (void)animateItemView:(UIView *)view show:(BOOL)show complete:(void(^)(void))complete {
    
    UIView *superView;
    CGFloat offsetY = 0;
    
    superView = self.superview;
    
    if (show) {
        
        view.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height + offsetY, self.frame.size.width, 0);
        [superView addSubview:view];
        
        CGFloat tableViewHeight = (view.superview ? view.superview.frame.size.height : [UIScreen mainScreen].bounds.size.height) - view.frame.origin.y;
        
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height + offsetY, self.frame.size.width, tableViewHeight);
        }];
        
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height + offsetY, self.frame.size.width, 0);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        
        
    }
    complete();
}

- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)(void))complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim andValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    indicator.fillColor = forward ? _selectedColor.CGColor : _normalColor.CGColor;
    
    complete();
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)(void))complete {
    if (show) {
        title.foregroundColor = _selectedColor.CGColor;
    } else {
        title.foregroundColor = _normalColor.CGColor;
    }
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numberOfMenu) - 25) ? size.width : self.frame.size.width / _numberOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    complete();
}

- (void)animateBackgroundView:(UIView *)view show:(BOOL)show complete:(void (^)(void))complete {
    if (show) {
        
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
        
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        
    }
    complete();
}

#pragma mark - drawing

- (CAShapeLayer *)creatIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(5, 5)];
    [path addLineToPoint:CGPointMake(10, 0)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}

- (CATextLayer *)creatTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numberOfMenu) - 25) ? size.width : self.frame.size.width / _numberOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    
    if (self.narrowFont && ([UIScreen mainScreen].bounds.size.width == 375)) {
        layer.fontSize = 12;
    } else {
        layer.fontSize = 14;
    }
    
    layer.font = (__bridge CFTypeRef _Nullable)([UIFont systemFontOfSize:14]);
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

- (CAShapeLayer *)creatSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 20)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    [path closePath];
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    layer.position = point;
    
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string {
    CGFloat fontSize = 14.0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark - getters and setters

- (void)setTitles:(NSArray *)titles {
    _titles = [titles copy];
    [self loadView];
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        _backgroundView.opaque = NO;
        _backgroundView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBackgroundView:)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

@end

@implementation CALayer (HKAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath {
    [self addAnimation:anim forKey:keyPath];
    [self setValue:value forKeyPath:keyPath];
}

@end
