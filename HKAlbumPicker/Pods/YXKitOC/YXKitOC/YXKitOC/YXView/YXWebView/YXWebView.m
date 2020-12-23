//
//  YXWebView.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/7/8.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXWebView.h"
#import "YXCookieManager.h"

@interface YXWebView ()

@property (nonatomic, strong) NSDictionary *cookie; /**< 当前Cookie */

@end

@implementation YXWebView

- (instancetype)initWithFrame:(CGRect)frame cookie:(NSDictionary *)cookie {
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    configuration.processPool = [[WKProcessPool alloc] init];
    // 加cookie给h5识别，表明在ios端打开该地址
    WKUserContentController *userContentController = WKUserContentController.new;
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:[YXCookieManager convertCookieStringForWKUserScriptWithCookie:cookie] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    configuration.userContentController = userContentController;
    
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        self.cookie = cookie;
    }
    return self;
}

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request {
    if (request.URL.scheme.length > 0 && self.cookie) {
        NSMutableURLRequest *requestWithCookie = request.mutableCopy;
        [requestWithCookie addValue:[YXCookieManager convertCookieStringForURLRequestWithCookie:self.cookie] forHTTPHeaderField:@"Cookie"];
        return [super loadRequest:requestWithCookie];
    }

    return [super loadRequest:request];
}

@end
