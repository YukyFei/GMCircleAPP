//
//  GMQWebViewController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/16.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQWebViewController.h"
#import "WeiPayUtil.h"
#import "RefreshManager.h"
#import "OrderDetailViewController.h"

@interface GMQWebViewController ()<UIWebViewDelegate>

@property(copy,nonatomic)NSString *order_id;


@end

@implementation GMQWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if(IOS_VERSION>=7.0){
        
        self.navigationController.navigationBar.barTintColor=HexRGB(0xfafafa);
        //导航栏标题
        self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:HexRGB(0x00b4a2),NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
    }else{
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}];
        self.navigationController.navigationBar.tintColor=HexRGB(0xfafafa);
    }

//    if ([self.parameters isKindOfClass:[NSArray class]]) {
//        [self setNaviBarTitle:self.arr[1]];
//        _InPutUrl = self.arr[0] ;
//       
//    }else if([self.parameters isKindOfClass:[NSString class]]){
//         [self setNaviBarTitle:self.parameters];
//        _InPutUrl = self.parameters ;
//    }
    if ([self.wailianURL isEqualToString:@""]) {
           [self setNaviBarTitle:self.Webtitle];
    }
 
   [self createUI];
    [self notification] ;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
        self.navigationController.navigationBar.barTintColor= [UIColor colorWithHexString:@"#007542"] ;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.tabBarController.tabBar.hidden = YES;
}




-(void)registerJavaScriptInterface
{
    __weak GMQWebViewController * weakSelf = self ;
    
    [self.mWebView addJavascriptInterfaces:weakSelf WithName:@"gmq"];
    
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
    [self.mWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"orderPaySuccess('%@')",self.order_id]];
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


-(void)createUI
{

    [self.view addSubview:self.mWebView];
    [self registerJavaScriptInterface] ;
}



-(UIWebView*)mWebView
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    if(!_mWebView)
    {
        _mWebView=[[GMQWebView alloc] init];
        
//        if (self.navigationController.navigationBarHidden==NO) {
//            [_mWebView setFrame:CGRectMake(Origin_x, StatusBar_Height+TABBAR_HEIGHT, VIEW_W(self.view), VIEW_H(self.view)-NavigationBar_HEIGHT-StatusBar_Height-TABBAR_HEIGHT+100)];
//        }else{
//            [_mWebView setFrame:CGRectMake(Origin_x, -StatusBar_Height, VIEW_W(self.view), VIEW_H(self.view)-NavigationBar_HEIGHT+StatusBar_Height-TABBAR_HEIGHT+100)];
//        }
        _mWebView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
        _mWebView.scalesPageToFit=YES;
        _mWebView.delegate=self;
        //
        _mWebView.dataDetectorTypes=UIDataDetectorTypeNone;
        _mWebView.backgroundColor=[UIColor whiteColor];
        _mWebView.scrollView.showsVerticalScrollIndicator=NO;
        _mWebView.scrollView.showsHorizontalScrollIndicator=NO;
        _mWebView.userInteractionEnabled=YES;
        _mWebView.scrollView.bounces=NO;
        //_mWebView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        //清除Webview缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        if ([self.wailianURL isEqualToString:@""]) {
            NSString *url = [NSString stringWithFormat:@"%@/%@&app_name=gmq&community_id=%@",webCOntrollerURl,_InPutUrl,[USER_DEFAULT objectForKey:kCommunityId]];
            NSLog(@"url ======%@",url) ;
            
            [_mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }else{
            
            [_mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.wailianURL]]];
        }
       
            
    }
    return _mWebView;
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
 *  tocken 拼接错误的交互方法
 */
//window.gmq.gmqDataShowError() ;
-(void)gmqDataShowError
{
//1 返回原生列表页 2 showerror   3  刷新tocken  
    [MBProgressHUD showError:@"数据加载有误请重试"] ;
    [[RefreshManager manager] isRefreshToken] ;
    [self popVC];
    
}


#pragma mark -UIWebview delegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"加载开始");
       [SVProgressHUD showInView:self.view status:@"加载中..."];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载完成");
     [SVProgressHUD dismiss];
   
    //    self.left ;rBtn.hidden=!_mWebView.canGoBack;
    self.navigationItem.title = [_mWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (![self.wailianURL isEqualToString:@""]) {
        [self setNaviBarTitle:[_mWebView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    }
    //   self.navigationItem.title = @"我的订单";
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载失败");
   [SVProgressHUD dismiss];
    [MBProgressHUD showError:@"加载失败，请重试"];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:KNotificationOrderPayNotification forKeyPath:@"success"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
