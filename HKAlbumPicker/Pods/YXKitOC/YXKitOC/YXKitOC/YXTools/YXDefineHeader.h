//
//  YXDefineHeader.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#ifndef YXDefineHeader_h
#define YXDefineHeader_h
#import <UIKit/UIKit.h>

/** DLog */
#ifndef DLog
#if DEBUG
#define DLog(id, ...) printf("---%p%s Line:%d---%s\n", self, __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:(id), ##__VA_ARGS__] UTF8String] );
#else
#define DLog(id, ...);
#endif
#endif

/** YX_Try Catch */
#define $YX_Try    @try {
#define $YX_Catch    }\
@catch (NSException *exception) {\
NSString *exceptionInfo = [NSString stringWithFormat:@"exception = %@\n Class = %@\n SEL = %@\n ",exception,self,NSStringFromSelector(_cmd)];\
DLog(@"%@",exceptionInfo);\
}

/** YXWeakSelf */
#define YX_WeakSelf __weak typeof(self) weakSelf = self;
#define YX_StrongSelf  __strong typeof(weakSelf) self = weakSelf;
#define YX_WeakObject(id)  __weak typeof(id) weak##id = id;
#define YX_StrongObject(id)  __strong typeof(id) id = weak##id;

/** 单例 */
// .h
#define YX_ShareInstance_h(classname)\
+ (classname *)shared##classname; \

// .m
#define YX_ShareInstance_m(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}

#endif /* YXDefineHeader_h */
