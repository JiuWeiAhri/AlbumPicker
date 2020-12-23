//
//  YXFiltersShowView.h
//  YXKitOC
//
//  Created by 李鹏飞 on 2020/4/3.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXFilterObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXFilterButtonObject : NSObject//为了展示或者移除已选的条件

@property (nonatomic, assign) BOOL isDefault; /**< 是默认值的话不展示 */
@property (nonatomic, copy) NSString *title; /**< 显示选中的内容 */
@property (nonatomic, strong) NSArray *relationKeys; /**< 关联key,用于例如品牌关联筛选的时候删除中间关联项或者删除起始项的时候同时删除后面的关联项 */
@property (nonatomic, copy) NSString *key; /**< 每个view的唯一值,一个VC内不能重复 */
@property (nonatomic, copy) NSString *value; /**< 选中的值 */
@property (nonatomic, assign) NSInteger filterPageIndex; /**< 筛选页索引,默认NSNotFound */
@property (nonatomic, strong) NSDictionary *customObject; /**< 扩展字段，可以自定义实现特殊功能 */

@end

@interface YXFilter : UIView

@property (nonatomic, copy, readonly) NSString *title;

@end

@class YXFiltersShowView;

@protocol YXFiltersShowViewDelegate <NSObject>

@optional
- (void)filterDidSelectedAtIndex:(NSInteger)index;
- (void)filterScrollViewClearSelected:(YXFiltersShowView *)filterView;

@end

@interface YXFiltersShowView : UIView

@property (nonatomic, strong, readonly) NSMutableArray<YXFilterButtonObject *> *listArray; /**< 数据源 */
@property (nonatomic, assign) id<YXFiltersShowViewDelegate> delegate;

/// 添加YXFilterObject，如果key和value都相同，进行替换
- (void)mergeFilterObjects:(NSArray<YXFilterButtonObject *> *)objects;

/// 删除YXFilterObject，并移除关联项
- (void)removeFilterButtonObject:(YXFilterButtonObject *)object;

- (void)reloadData;

@end


NS_ASSUME_NONNULL_END
