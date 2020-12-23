//
//  NSMutableArray+YXFilterObject.h
//  MarsCar
//
//  Created by 张鑫 on 2020/6/24.
//  Copyright © 2020 TaoChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (YXFilterObject)

- (void)removeFilterObjectsAtPageIndex:(NSInteger)pageIndex;

@end

NS_ASSUME_NONNULL_END
