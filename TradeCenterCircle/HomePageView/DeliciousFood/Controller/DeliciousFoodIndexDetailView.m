//
//  DeliciousFoodIndexDetailView.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "DeliciousFoodIndexDetailView.h"
#import "RefreshManager.h"
#import "WeiPayUtil.h"
#import "OrderDetailViewController.h"



@interface DeliciousFoodIndexDetailView ()<UIWebViewDelegate>{
    
    BOOL isFirstTo;       //是否是第一次进入初始化的页面
    BOOL isBackClick;     //是否点击了返回按钮
}

@property(nonatomic,strong) GMQWebView  *webView;
@property(copy,nonatomic)   NSString *order_id;

@end

@implementation DeliciousFoodIndexDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initController];
}

-(void)initController{
    [self initWebView];
    [self registerJavaScriptInterface];
    [self notification] ;
}

-(void)backClick
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)registerJavaScriptInterface
{
    __weak DeliciousFoodIndexDetailView * weakSelf = self ;
    
    [self.webView addJavascriptInterfaces:weakSelf WithName:@"gmq"];
}

/**
 * 微信支付的交互方法
 */
-(void)csqPay:(NSString *)orderId :(int)type
{
    self.order_id = orderId;
    NSDictionary *dictParam = [[NSDictionary alloc]init];
    dictParam = @{@"order_id":orderId,@"pay_platform":@"app",@"platform":@"ios",APP_ID:ZP_ID};
    [HttpService csqPricePostWithParams:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        
        NSDictionary *dict = (NSDictionary *)jsonObj;
        NSDictionary *dictData = [dict objectForKey:@"Data"];
        NSLog(@"dictData%@",dictData);
        if ([dict validateOk]) {
            //原来的Name是彩社区
            [[WeiPayUtil shareWeipay]weipayWithParams:dictData withNo:orderId andName:@"国贸圈" withSuccess:^(NSDictionary *resp) {
                NSLog(@"=====支付成功");
            }];
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    NSLog(@"----------");
}


/**
 *  接收支付结果的通知
 */
-(void)notification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderSuccess) name:KNotificationOrderPayNotification object:nil];
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderFail) name:KNotificationOrderPayFail object:nil];
}

-(void)orderSuccess
{
    NSLog(@"order_id%@",self.order_id);
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"orderPaySuccess('%@')",self.order_id]];
}

-(void)orderFail
{
     NSLog(@"order_id%@",self.order_id);
    OrderDetailViewController * order = [[OrderDetailViewController alloc]init];
    order.orderId = self.order_id ;
    order.signStr = @"3" ;
    [self.navigationController pushViewController:order animated:YES];
}
/**
 * 回到首页
 */
-(void)gmqTohome
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationSwitchHome object:nil  userInfo:nil];
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

        if ([self.wailianURL isEqualToString:@""]) {
            if ([self.signStr isEqualToString:@"1"]) {
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoWebURLL,[NSString stringWithFormat:@"yiishop/Products/Detail?product_id=%@&token=%@&user_id=%@&platform=app&app_name=gmq&community_id=%@",self.productId,[USER_DEFAULT objectForKey:kLoginToken],[USER_DEFAULT objectForKey:kUserId],[USER_DEFAULT objectForKey:kCommunityId]]]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0]];
                NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",demoWebURLL,[NSString stringWithFormat:@"yiishop/Products/Detail?product_id=%@&token=%@&user_id=%@&platform=app&app_name=gmq&community_id=%@",self.productId,[USER_DEFAULT objectForKey:kLoginToken],[USER_DEFAULT objectForKey:kUserId],[USER_DEFAULT objectForKey:kCommunityId]]]) ;
            }else{
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoWebURLL,[NSString stringWithFormat:@"yiishop/Products/Detail?product_id=%@&platform=app&app_name=gmq&community_id=%@",self.productId,[USER_DEFAULT objectForKey:kCommunityId]]]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0]];
            }
            }else{
         [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.wailianURL]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0]];
        }
        [self.view addSubview:_webView];
    }
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
    //网页加载失败 调用此方法
    [self hideNaviBar:NO];
    [self setNaviBarTitle:@"商品详情"];
    [SVProgressHUD dismiss];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:KNotificationOrderPayNotification forKeyPath:@"success"];
     [[NSNotificationCenter defaultCenter] removeObserver:KNotificationOrderPayNotification forKeyPath:@"success"];
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
