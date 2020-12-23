//
//  YXMenuFilterConfig.h
//  YXKitOC
//
//  Created by zhxin on 2020/8/12.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXMenuFilterConfig : NSObject

@property (nonatomic, strong) UIColor *selectedTextColor; /**< 选中之后的颜色 */
@property (nonatomic, strong) UIColor *normalTextColor; /** 初始颜色 */

YX_ShareInstance_h(YXMenuFilterConfig)

@end

NS_ASSUME_NONNULL_END
