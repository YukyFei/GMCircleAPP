//
//  MyShopCartViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyShopCartViewController.h"
#import "GMQTabBarController.h"

@interface MyShopCartViewController ()<UIWebViewDelegate>

@property(nonatomic,strong) GMQWebView  *webView;

@end

@implementation MyShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setDataSource];
}

- (void)setDataSource{
    [self initWebView];
    [self addJavascriptInterface] ;
}

//重写返回按钮的方法
-(void)backClick
{
    if ([self.differentStr isEqualToString:@"1"]) {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if([self.differentStr isEqualToString:@"2"]){
        if ([self.webView canGoBack]) {
            [self.webView goBack];
            
        }else{
            
            GMQTabBarController *shopCarView = [[GMQTabBarController alloc] init];
            [self.navigationController pushViewController:shopCarView animated:YES];
        }
    }else{
        if ([self.webView canGoBack]) {
            [self.webView goBack];
            
        }else{
            
            GMQTabBarController *shopCarView = [[GMQTabBarController alloc] init];
            [self.navigationController pushViewController:shopCarView animated:YES];
        }
    }
}

-(void)initWebView
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    if (!_webView) {
        _webView = [[GMQWebView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
        _webView.scalesPageToFit=YES;
        _webView.delegate=self;
        _webView.dataDetectorTypes=UIDataDetectorTypeNone;
        _webView.scrollView.showsVerticalScrollIndicator=NO;
        _webView.scrollView.showsHorizontalScrollIndicator=NO;
        _webView.userInteractionEnabled=YES;
        _webView.scrollView.bounces=NO;
        
        //清除Webview缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        if ([self.signStr isEqualToString:@"1"]) {
            
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?token=%@&user_id=%@&platform=app&app_name=gmq&community_id=%@",demoWebURLL,@"yiishop/cart/index",[USER_DEFAULT objectForKey:kLoginToken],[USER_DEFAULT objectForKey:kUserId],[USER_DEFAULT objectForKey:kCommunityId]]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0]];
            NSLog(@"%@",[NSString stringWithFormat:@"%@/%@?token=%@&user_id=%@&platform=app&app_name=gmq&community_id=%@",demoWebURLL,@"yiishop/cart/index",[USER_DEFAULT objectForKey:kLoginToken],[USER_DEFAULT objectForKey:kUserId],[USER_DEFAULT objectForKey:kCommunityId]]) ;
        }else{
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@&app_name=gmq&community_id=%@",demoWebURLL,@"yiishop/cart/index?platform=app",[USER_DEFAULT objectForKey:kCommunityId]]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0]];
            NSLog(@"%@",[NSString stringWithFormat:@"%@/%@&app_name=gmq&community_id=%@",demoWebURLL,@"yiishop/cart/index?platform=app",[USER_DEFAULT objectForKey:kCommunityId]]) ;
        }
        
        [self.view addSubview:_webView];
    }
}

-(void)addJavascriptInterface
{
    MyShopCartViewController * shop = [[MyShopCartViewController alloc]init];
    [self.webView addJavascriptInterfaces:shop WithName:@"gmq"] ;
}

/**
 * 回到首页
 */
-(void)gmqTohome
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationSwitchHome object:nil  userInfo:nil];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
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
