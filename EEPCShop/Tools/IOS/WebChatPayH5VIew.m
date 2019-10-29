//
//  WebChatPayH5VIew.m
//  One
//
//  Created by MJL on 2018/1/12.
//  Copyright © 2018年 MJL. All rights reserved.
//

#import "WebChatPayH5VIew.h"

@interface WebChatPayH5VIew ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *myWebView;

@property (assign, nonatomic) BOOL isLoading;

@end

@implementation WebChatPayH5VIew

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.myWebView = [[UIWebView alloc] initWithFrame:self.frame];
        [self addSubview:self.myWebView];
        self.myWebView.delegate = self;
    }
    return self;
}

#pragma mark 加载地址
- (void)loadingURL:(NSString *)url withIsWebChatURL:(BOOL)isLoading {
    //首先要设置为NO
    self.isLoading = isLoading;
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSString *newUrl = url.absoluteString;
    if (!self.isLoading) {
        if ([newUrl rangeOfString:@"weixin://wap/pay"].location != NSNotFound ) {
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            [self.myWebView loadRequest:request];
            self.isLoading = YES;
            return NO;
        }else if([newUrl hasPrefix:@"alipay://alipayclient"]){
            NSString *newURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:@"alipays" withString:@"ds.shijihema.cn"];   //替换支付宝原scheme为自己的
            BOOL bSucc = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newURL]];
            if (!bSucc) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"未检测到支付宝客户端，请安装后重试。"
                                                              delegate:self
                                                     cancelButtonTitle:@"立即安装"
                                                     otherButtonTitles:nil];
                [alert show];
            }
    
            return NO;

        }
    } else {
        if ([newUrl rangeOfString:@"weixin://wap/pay"].location != NSNotFound ) {
            self.myWebView = nil;
            UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            [self addSubview:web];
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            [web loadRequest:request];
//            [[self getCurrentVC] showhide];
            return YES;
        }else if([newUrl hasPrefix:@"alipay://alipayclient"]){
            self.myWebView = nil;

            return YES;
        }
    }
    
    NSDictionary *headers = [request allHTTPHeaderFields];
    BOOL hasReferer = [headers objectForKey:@"Referer"] != nil;
    if (hasReferer) {
        return YES;
    } else {
        // relaunch with a modified request
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *url = [request URL];
                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                //设置授权域名
                [request setValue:@"ds.shijihema.cn://" forHTTPHeaderField: @"Referer"];
                [self.myWebView loadRequest:request];
            });
        });
        return NO;
    }
    
    if ([request.URL.absoluteString hasPrefix:@"alipay://alipayclient"]) {
        //支付宝
        NSString *newURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:@"alipays" withString:@"shop.shijihema.cn"];   //替换支付宝原scheme为自己的
        BOOL bSucc = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newURL]];                      //调起支付宝
        
        // NOTE: 如果跳转失败，则跳转itune下载支付宝App
        if (!bSucc) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"未检测到支付宝客户端，请安装后重试。"
                                                          delegate:self
                                                 cancelButtonTitle:@"立即安装"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else {
            //支付完成通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dbPayFinishedNotification" object:self userInfo:@{@"type":@(2)}];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [[self getCurrentVC] showhide];
//    [[self getCurrentVC] showAlertWithTitle:@"调取微信失败" message:nil complete:nil];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}


@end
