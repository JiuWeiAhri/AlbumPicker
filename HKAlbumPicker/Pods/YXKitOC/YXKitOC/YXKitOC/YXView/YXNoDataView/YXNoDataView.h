//
//  CA_NoDataView.h
//  ChongAi
//
//  Created by GreatTree on 16/8/15.
//  Copyright © 2016年 GreatTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXDefineHeader.h"

typedef void(^ClickBlock)(void);

typedef NS_ENUM(NSUInteger, YXNoDataViewType) {
    YXNoDataViewTypeNoData,   // 无数据
    YXNoDataViewTypeNoNet,    // 无网络
    YXNoDataViewTypeNoService,// 接口异常
};

@interface YXNoDataViewConfig : NSObject

@property (nonatomic, strong) UIImage *noDataImage; /**< 没有数据图片 */
@property (nonatomic, strong) UIImage *noNetImage; /**< 没有网络图片 */
@property (nonatomic, strong) UIImage *errorImage; /**< 请求失败图片 */

YX_ShareInstance_h(YXNoDataViewConfig)

@end

@interface YXNoDataView : UIView

@property (nonatomic, assign) YXNoDataViewType type; /**< 类型 */
@property (nonatomic, copy) NSString *message; /**< 提示语 */
@property (nonatomic, strong) UIImage *image; /**< 图片 */
@property (nonatomic, copy) ClickBlock block; /**< block */
@property (nonatomic, strong) UIView *customView; /**< 自定义视图 */

- (void)handleClick:(ClickBlock)block;

@end
