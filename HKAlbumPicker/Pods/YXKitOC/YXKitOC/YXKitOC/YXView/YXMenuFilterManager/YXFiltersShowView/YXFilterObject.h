//
//  YXFilterObject.h
//  YXKitOC
//
//  Created by 李鹏飞 on 2020/6/11.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXFilterObject : YXModel

@property (nonatomic, assign) BOOL isDefault; /**< 是默认值的话不展示 */
@property (nonatomic, strong) NSArray *titles; /**< 显示的title数组 */
@property (nonatomic, strong) NSArray *values; /**< 选中值的数组 */
@property (nonatomic, strong) NSArray *relationKeys; /**< 关联key,用于例如品牌关联筛选的时候删除中间关联项或者删除起始项的时候同时删除后面的关联项 */
@property (nonatomic, copy) NSString *key; /**< 每个view的唯一值,一个VC内不能重复 */
@property (nonatomic, assign) NSInteger filterPageIndex; /**< 筛选页索引,默认NSNotFound */
@property (nonatomic, strong) NSDictionary *customObject; /**< 扩展字段，可以自定义实现特殊功能 */

@end

NS_ASSUME_NONNULL_END
