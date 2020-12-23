//
//  YXWebVC.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/7/8.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXWebVC.h"
#import "YXWebView.h"
#import "YXDeviceInfo.h"
#import "UIView+YXAdd.h"
#import "YXCookieManager.h"

@interface YXWebVC ()

@property (nonatomic, strong) YXWebView *yxWebView; /**< YXWebView,继承于第三方KKWebView，方便管理Cookie */

@end

@implementation YXWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.yxWebView];
    [self loadURL:self.url];
}

#pragma mark - Public Func

- (void)loadURL:(NSURL *)url {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:[YXCookieManager convertCookieStringForURLRequestWithCookie:self.cookie] forHTTPHeaderField:@"Cookie"];
    
    [self.yxWebView loadRequest:request];
}

#pragma mark - Private Func

#pragma mark - Getter

- (YXWebView *)yxWebView {
    if (!_yxWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [[WKUserContentController alloc] init];
        configuration.processPool = [[WKProcessPool alloc] init];
        // 加cookie给h5识别，表明在ios端打开该地址
        WKUserContentController *userContentController = WKUserContentController.new;
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:[YXCookieManager convertCookieStringForWKUserScriptWithCookie:self.cookie] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        configuration.userContentController = userContentController;
        
        _yxWebView = [[YXWebView alloc] initWithFrame:CGRectMake(0, YX_SafeArea_Top(), self.view.width_yx, self.view.height_yx - YX_SafeArea_Top()) configuration:configuration];
    }
    return _yxWebView;
}

@end
