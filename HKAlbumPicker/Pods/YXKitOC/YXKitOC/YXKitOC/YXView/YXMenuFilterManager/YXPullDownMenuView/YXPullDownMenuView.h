//
//  YXPullDownMenuView.h
//  YXKitOC
//
//  Created by 李鹏飞 on 2020/4/2.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXPullDownMenuView;

@protocol YXPullDownMenuViewDataSource <NSObject>

@required

/// 菜单的DataSource 通过index区分每个按钮下拉赋值的view
/// @param pullDownMenu YXPullDownMenuView
/// @param menuIndex 菜单的index
- (UIView *)itemViewForPullDownMenu:(YXPullDownMenuView *)pullDownMenu menuIndex:(NSInteger)menuIndex;

@end

@interface YXPullDownMenuView : UIView

@property (nonatomic, strong) UIColor *selectedColor; /**< 选中之后的颜色 */
@property (nonatomic, strong) UIColor *normalColor; /** 初始颜色 */

@property (nonatomic, copy) NSArray *titles; /** 标题数组 */

@property (nonatomic, assign) id<YXPullDownMenuViewDataSource>dataSource; /** 菜单的DataSource */

- (void)finished;

@end

@interface CALayer (HKAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath;

@end
