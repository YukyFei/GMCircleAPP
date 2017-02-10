//
//  ShopCartViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "ShopCartViewController.h"

@interface ShopCartViewController ()<UIWebViewDelegate>{
    //用于判断是否是第一次进入初始化页面
    BOOL    isIntoVC;
}

@property(nonatomic,strong) GMQWebView  *webView;

@end

@implementation ShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideNaviback:YES];
}

- (void)setDataSource{
    [self initWebView];
    [self addJavascriptInterface];
}

-(void)initWebView
{
    _webView = [[GMQWebView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-[SizeUtility textFontSize:default_TabBar_height_size])];
    _webView.scalesPageToFit=YES;
    _webView.delegate=self;
    _webView.dataDetectorTypes=UIDataDetectorTypeNone;
    _webView.backgroundColor=[UIColor whiteColor];
    _webView.scrollView.showsVerticalScrollIndicator=NO;
    _webView.scrollView.showsHorizontalScrollIndicator=NO;
    _webView.userInteractionEnabled=YES;
    _webView.scrollView.bounces=NO;
    
    //清除Webview缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?token=%@&user_id=%@&platform=app&app_name=gmq&community_id=%@",demoWebURLL,@"yiishop/cart/index",[USER_DEFAULT objectForKey:kLoginToken],[USER_DEFAULT objectForKey:kUserId],[USER_DEFAULT objectForKey:kCommunityId]]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0]];
    
    [self.view addSubview:_webView];
    
//    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?token=%@&user_id=%@&platform=app",demoWebURLL,@"yiishop/cart/index",[USER_DEFAULT objectForKey:kLoginToken],[USER_DEFAULT objectForKey:kUserId]]] encoding:NSUTF8StringEncoding error:nil];
//    
//    NSLog(@"获取的html数据为=====%@",htmlString);
}

-(void)gmqToSettlement:(BOOL)isnull{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
   [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void)addJavascriptInterface
{
    ShopCartViewController * shop = [[ShopCartViewController alloc]init];
    [self.webView addJavascriptInterfaces:shop WithName:@"gmq"];
}

/**
 * 回到首页
 */
-(void)gmqTohome
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationSwitchHome object:nil  userInfo:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showInView:self.view status:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    [self setNaviBarTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [SVMessageHUD dismissWithError:@"加载失败" afterDelay:1.0f] ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertView object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
