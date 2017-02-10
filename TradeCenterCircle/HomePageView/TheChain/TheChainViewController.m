//
//  TheChainViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "TheChainViewController.h"

@interface TheChainViewController ()<UIWebViewDelegate>

@property(nonatomic,strong) GMQWebView  *webView;

@end

@implementation TheChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNaviBarTitle:self.titleStr];
    
    [self initWebView];
}

-(void)backClick
{
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
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
        _webView.backgroundColor=[UIColor whiteColor];
        _webView.scrollView.showsVerticalScrollIndicator=NO;
        _webView.scrollView.showsHorizontalScrollIndicator=NO;
        _webView.userInteractionEnabled=YES;
        _webView.scrollView.bounces=NO;
        
        //清除Webview缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];

        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.Shop_url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0]];
        [self.view addSubview:_webView];
    }
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
