//
//  NSError+YXAdd.h
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/2/16.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (YXAdd)

+ (NSError *)yx_errorWithCode:(NSInteger)code errorMessage:(NSString*)errorMsg;

@end

NS_ASSUME_NONNULL_END
