//
//  YXWebVC.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/7/8.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXWebVC : YXBaseVC

@property (nonatomic, strong) NSURL *url; /**< 请求地址 */
@property (nonatomic, strong) NSDictionary *cookie; /**< 设置Cookie */

@end

NS_ASSUME_NONNULL_END
