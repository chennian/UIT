//
//  ViewController.m
//  dingba
//
//  Created by Mac Pro on 2019/1/14.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

#import "PayWebViewController.h"
#import "WebChatPayH5VIew.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width  //屏幕宽
#define ScreenH [UIScreen mainScreen].bounds.size.height //屏幕高
#define isiPhoneX   (ScreenW == 375.0 && ScreenH == 812.0)

#define isiPhoneXR   (ScreenW == 414.0 && ScreenH == 896.0)

#define LL_StatusBarExtraHeight  ((isiPhoneX || isiPhoneXR) ? 24.0 : 0.0)

#define LL_NavigationBarHeight   44.0

#define LL_TabbarHeight   ((isiPhoneX || isiPhoneXR)  ? (49.0+34.0) : 49.0)

#define LL_TabbarSafeBottomMargin  ((isiPhoneX || isiPhoneXR)  ? 34.0 : 0.0)

#define LL_StatusBarAndNavigationBarHeight   ((isiPhoneX || isiPhoneXR)  ? 88.0 : 64.0)


@interface PayWebViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIWebView *webview;

@end

@implementation PayWebViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW,ScreenH - LL_StatusBarAndNavigationBarHeight - LL_TabbarSafeBottomMargin)];
    [self.view addSubview:self.webview];
    self.webview.delegate = self;
    
    NSString *str = [NSString stringWithFormat:@"http://app.shijihema.cn/common/confirmOrder/%@/%@",self.uid,self.shop_id];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    [self.webview loadRequest:request];
    
//    //监听支付完成通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(db_payFinished:) name:@"dbPayFinishedNotification" object:nil];
}

////收到支付完成通知
//- (void)db_payFinished:(NSNotification *)aNotification
//{
////    NSNumber *type = aNotification.userInfo[@"type"]; //type 1微信 2支付宝
//
//    UIView *tempWebView = [self.view viewWithTag:115];
//    [tempWebView removeFromSuperview];
//
//    //重定向到订单页面
//    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://shop.shijihema.cn/common/success"]]];
//}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // NOTE: ------  对alipays:相关的scheme处理 -------
    // NOTE: 若遇到支付宝相关scheme，则跳转到本地支付宝App
    NSString* reqUrl = request.URL.absoluteString;
//    if ([reqUrl rangeOfString:@"https://wx.tenpay.com"].location != NSNotFound ) {
//        //这里把webView设置成一个像素点，主要是不影响操作和界面，主要的作用是设置referer和调起微信
//        WebChatPayH5VIew *h5View = [[WebChatPayH5VIew alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
//        h5View.tag = 115;
//        //newUrl是没有拼接redirect_url微信h5支付链接
//        [h5View loadingURL:reqUrl withIsWebChatURL:NO];
//        [self.view addSubview:h5View];
//
//        return NO;
//    }
    if ([reqUrl rangeOfString:@"https://wx.tenpay.com"].location != NSNotFound || [reqUrl hasPrefix:@"alipay://alipayclient"]) {
        //这里把webView设置成一个像素点，主要是不影响操作和界面，主要的作用是设置referer和调起微信
        WebChatPayH5VIew *h5View = [[WebChatPayH5VIew alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        //newUrl是没有拼接redirect_url微信h5支付链接
        [h5View loadingURL:reqUrl withIsWebChatURL:NO];
        [self.view addSubview:h5View];
        
        return NO;
    }
    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
         // NOTE: 跳转支付宝App
         BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
         
         // NOTE: 如果跳转失败，则跳转itune下载支付宝App
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
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // NOTE: 跳转itune下载支付宝App
    NSString* urlStr = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
    NSURL *downloadUrl = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication]openURL:downloadUrl];
}

//URL编码
+ (NSString *)db_URLEncode:(NSString *)str
{
    if (!str) {
        return nil;
    }
    //@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| " 网络上的标准,不敢替换,怕受影响
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@+$,/%#[]% &"] invertedSet];  //新增了&符,注意观察各个项目是否受影响 2018.9.6
    NSString *newStr = [str stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    return newStr;
}

@end
