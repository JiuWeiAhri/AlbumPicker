//
//  NSArray+YXFilterObject.h
//  YXKitOC
//
//  Created by 李鹏飞 on 2020/6/11.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXFilterObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (YXFilterObject)

- (NSArray *)filterObjectTitlesForKey:(NSString *)key;

- (NSArray *)filterObjectValuesForKey:(NSString *)key;

- (NSArray *)filterObjectsAtPageIndex:(NSInteger)pageIndex;

@end

NS_ASSUME_NONNULL_END
