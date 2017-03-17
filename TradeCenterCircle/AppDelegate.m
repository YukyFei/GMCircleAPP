 //
//  AppDelegate.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "GMQTabBarController.h"
#import "GMQNavigationController.h"
#import "LoginViewController.h"
#import "UMessage.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "PayRequsestHandler.h"
#import "OrderDetailViewController.h"
#import <objc/runtime.h>
#import "ShopCartViewController.h"

#import "MyBaoshiViewController.h"
#import "MyShopCartViewController.h"

#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate>
{
    UIImageView *bgImageView  ;

}

@property(nonatomic,strong)GMQTabBarController         *tabbarController;
@property(nonatomic,strong)LoginViewController         *longinViewController;
@property(nonatomic,strong)GMQNavigationController     *navigationController;

@property(nonatomic,strong) NSDictionary * pushDic ;



@end

@implementation AppDelegate

/*
 
 13651062984=0000123456
 13601188574=0000123457
 13701389799=0000123458
 18911987658=0000123459
 15811265061=0000123460
 18911987510=0000123461
 13717917814=0000123462
 13910801440=0000123463
 13911719607=0000123464
 13910215761=0000123465
 13911718056=0000123466
 15011508521=0000123467
 #323753
 13693008026=0000123468
 #613728
 18511636347=0000123469
 */
- (NSMutableArray *)phoneNum_cardNum
{
    if (!_phoneNum_cardNum) {
        
        _phoneNum_cardNum = [NSMutableArray array];
        
        [_phoneNum_cardNum addObject:@{@"13651062984":@"123456"}];
        [_phoneNum_cardNum addObject:@{@"13601188574":@"123457"}];
        [_phoneNum_cardNum addObject:@{@"13701389799":@"123458"}];
        [_phoneNum_cardNum addObject:@{@"18911987658":@"123459"}];
        [_phoneNum_cardNum addObject:@{@"15811265061":@"123460"}];
        [_phoneNum_cardNum addObject:@{@"18911987510":@"123461"}];
        [_phoneNum_cardNum addObject:@{@"13717917814":@"123462"}];
        [_phoneNum_cardNum addObject:@{@"13910801440":@"123463"}];
        [_phoneNum_cardNum addObject:@{@"13911719607":@"123464"}];
        [_phoneNum_cardNum addObject:@{@"13910215761":@"123465"}];
        [_phoneNum_cardNum addObject:@{@"13911718056":@"123466"}];
        [_phoneNum_cardNum addObject:@{@"15011508521":@"123467"}];
        [_phoneNum_cardNum addObject:@{@"13693008026":@"123468"}];
        [_phoneNum_cardNum addObject:@{@"18511636347":@"123469"}];
        [_phoneNum_cardNum addObject:@{@"13910269588":@"123470"}];
        [_phoneNum_cardNum addObject:@{@"18511917728":@"123471"}];
    }
    return _phoneNum_cardNum;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:3];//设置启动页面时间
    
    NSLog(@"%d",[@"0000123469" intValue]);
    
     [self loadVersion];
    /***友盟推送相关**/
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:UmengAppkey launchOptions:launchOptions];
    
    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
    [UMessage registerForRemoteNotifications];
    
    //开启调试模式
    [UMessage setLogEnabled:YES];
    
    
     //微信支付
     [WXApi registerApp:WXAPP_ID withDescription:@"GMQ"];

    //状态栏的样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    
    [self configAppAction];
    //初始化数据
    [self initAppData];
    
    [self.window makeKeyAndVisible];
    
    //    //键盘管理
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:5];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];

    
#warning ------BluetoothInit-------
    
    [self bluetoothInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothOpenDoorSuccess) name:@"bluetoothOpenDoorSuccess" object:nil];

    if ([self bluetoothStartOpenDoor]) {
        
        NSLog(@"开始监控");
    }
    else
        NSLog(@"未处于登录状态，或者没有注册要监控的区域");
    
    
    return YES;
}

//初始化 app data 是否第一次启动
-(void)initAppData
{
    //com.yuemao365.yourmate
    if(![GlobalManager isFirstLaunch])
    {
        [GlobalManager setFirstLaunch];
        
    }
    
    BOOL loginStatus=[USER_DEFAULT boolForKey:kLoginSuccess];
    if(loginStatus){
        //判断token是否失效
        [[RefreshManager manager] isRefreshToken];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchHome)
                                                 name:KNotificationSwitchHome object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchUserLogin)
                                                 name:KNotificationSwitchUserLogin object:nil];
}


/**
 *  根据登录状态，跳转不同界面
 */
-(void)configAppAction
{
    BOOL loginStatus=[USER_DEFAULT boolForKey:kLoginSuccess];
    if(loginStatus)
    {
        GMQTabBarController *mainView = [[GMQTabBarController alloc] init];
        GMQNavigationController *nav = [[GMQNavigationController alloc] initWithRootViewController:mainView];
        mainView.delegate = self;
        self.window.rootViewController = nav;
    }
    else
    {
        LoginViewController *loginView = [[LoginViewController alloc] init];
        GMQNavigationController *nav = [[GMQNavigationController alloc] initWithRootViewController:loginView];
        self.window.rootViewController = nav;
    }
}

/*
 ** UITabBarControllerDelegate
 */
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController.tabBarItem.tag==2){

        MyShopCartViewController *shopCarView = [[MyShopCartViewController alloc] init];
        shopCarView.differentStr = @"2";
        
        GMQNavigationController *nav = [[GMQNavigationController alloc] initWithRootViewController:shopCarView];
        
        if ([USER_DEFAULT objectForKey:kGetIntoVC] == nil) {
            
            shopCarView.signStr = @"1";
            
        }else{
            shopCarView.signStr = @"2";
        }
        
        self.window.rootViewController = nav;
    }
    
    return YES;
}

//切换到主页
- (void)switchHome
{
    GMQTabBarController *mainView = [[GMQTabBarController alloc] init];
    GMQNavigationController *nav = [[GMQNavigationController alloc] initWithRootViewController:mainView];
    mainView.delegate = self ;
    self.window.rootViewController = nav;
}

- (void)switchUserLogin
{
    LoginViewController *loginView = [[LoginViewController alloc] init];
    GMQNavigationController *nav = [[GMQNavigationController alloc] initWithRootViewController:loginView];
    self.window.rootViewController = nav;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    //用户可以在这个方法里面获取devicetoken
    
    NSString *device_Token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [USER_DEFAULT setObject:device_Token forKey:kDevice_Token];
    NSLog(@"%@",[USER_DEFAULT objectForKey:kDevice_Token]);
    [USER_DEFAULT synchronize];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:device_Token forKey:@"device_token"];
    [dic setValue:UmengAppkey forKey:@"plat_form"];
    [dic setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"];

    //设置设备号
    [HttpService postWithServiceCode:kSetDeviceToken params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;

        if ([dicresult validateOk]) {
            NSLog(@"发送devicetoken到服务器===%@",dicresult);
            
        }else{
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
}

 - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
 {
 //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
 //1.2.7版本开始自动捕获这个方法，log以application:didFailToRegisterForRemoteNotificationsWithError开头
     
     NSString *error_str = [NSString stringWithFormat: @"%@", error];
     NSLog(@"Failed to get token, error:%@", error_str);
 }



#pragma mark -  处理推送的逻辑   从后台点击推送进入
-(void)pushAction :(NSDictionary *)userInfo application:(UIApplication *)application{
    
    //关闭alert
    if ([userInfo[@"custom"][@"type"] isEqualToString:@"login_token"]) {
        [USER_DEFAULT setObject:userInfo[@"custom"][@"login_refresh_token"] forKey:kLoginRefreshToken] ;
        [USER_DEFAULT setObject:userInfo[@"custom"][@"login_token"] forKey:kLoginToken] ;
        
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    
}

/**
 *  推送处理
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    self.pushDic = [NSDictionary dictionary];
    self.pushDic = userInfo;
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //关闭alert
    if ([userInfo[@"custom"][@"type"] isEqualToString:@"login_token"]) {
        [USER_DEFAULT setObject:userInfo[@"custom"][@"login_refresh_token"] forKey:kLoginRefreshToken] ;
        [USER_DEFAULT setObject:userInfo[@"custom"][@"login_token"] forKey:kLoginToken] ;
    }
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:userInfo[@"aps"][@"alert"] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//       [alertView show];

    switch ([UIApplication sharedApplication].applicationState) {
            
        case UIApplicationStateActive: {
            
    
            if ([userInfo[@"custom"][@"type"] isEqualToString:@"shop"]) {
                    [alertView show];
                //发货通知
                objc_setAssociatedObject(alertView, "key", userInfo[@"order_sn"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([userInfo[@"custom"][@"type"] isEqualToString:@"gongdan"]){
            //抢单通知
                    [alertView show];
                objc_setAssociatedObject(alertView, "keya", userInfo[@"fuwu"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                alertView.tag = 20;
            }else if ([userInfo[@"custom"][@"type"] isEqualToString:@"address_ok"]){
            //审核通过
                 //更新本地审核状态
                if ([[USER_DEFAULT objectForKey:kSpace_id] isEqualToString: userInfo[@"custom"][@"sapce_id"]]) {
                    [USER_DEFAULT setObject:@"1" forKey:kAddress_valid_status] ;
                }

                    bgImageView = [[UIImageView alloc]init];
                    bgImageView.userInteractionEnabled = YES;
                    bgImageView.frame = CGRectMake(Origin_x, Origin_y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                    bgImageView.image = [UIImage imageNamed:@"login_bg"];
                    [self.window addSubview:bgImageView];
                
                    CGFloat marginX;
                    CGFloat marginY;
                    if ([UIScreen mainScreen].bounds.size.width == 320) {
                        marginX = 40;
                        marginY = 80;
                    }else{
                        marginX = 50;
                        marginY = 120;
                    }
                
                    CGFloat imageW = [UIScreen mainScreen].bounds.size.width-2*marginX;
                    CGFloat imageH = [UIScreen mainScreen].bounds.size.height-2*marginY;
                
                    UIImageView *IdimageView = [[UIImageView alloc]init];
                    IdimageView.userInteractionEnabled = YES;
                    IdimageView.frame = CGRectMake(marginX, marginY, [UIScreen mainScreen].bounds.size.width-2*marginX, [UIScreen mainScreen].bounds.size.height-2*marginY);
                    IdimageView.image = [UIImage imageNamed:@"dengjiyanzheng_bg"];
                    [bgImageView addSubview:IdimageView];
                
                    UILabel *mesLabel = [[UILabel alloc]init];
                    NSString *alertStr = [NSString stringWithFormat:@"您已经成功验证为%@的住户!",userInfo[@"custom"][@"space_name"]];
                    mesLabel.text = alertStr;
                    mesLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
                    mesLabel.textColor = [UIColor redColor];
                    mesLabel.numberOfLines = 0;
                
                    CGSize textSize = [self sizeWithText:mesLabel.text WithFont:mesLabel.font WithMaxSize:CGSizeMake(imageW-2*marginX, MAXFLOAT)];
                    mesLabel.frame = CGRectMake(marginX, imageH/2-textSize.height/2, textSize.width, textSize.height);
                    [IdimageView addSubview:mesLabel];
                    
                    UIButton *backBtn = [[UIButton alloc]init];
                    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_success"] forState:UIControlStateNormal];
                    CGSize btnSize = CGSizeMake(3*marginX, marginX);
                    backBtn.frame = CGRectMake((imageW-btnSize.width)/2, imageH-btnSize.height-marginX/2, btnSize.width, btnSize.height);
                    [backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [IdimageView addSubview:backBtn];
                
            }else if ([userInfo[@"custom"][@"type"] isEqualToString:@"address_no"]){
                //审核被拒
                //更新本地审核状态
                if ([[USER_DEFAULT objectForKey:kSpace_id] isEqualToString: userInfo[@"custom"][@"sapce_id"]]) {
                    [USER_DEFAULT setObject:@"2" forKey:kAddress_valid_status] ;
                }
                    bgImageView = [[UIImageView alloc]init];
                        bgImageView.userInteractionEnabled = YES;
                        bgImageView.frame = CGRectMake(Origin_x, Origin_y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                        bgImageView.image = [UIImage imageNamed:@"bg_fail"];
                        [self.window addSubview:bgImageView];
                
                        CGFloat marginX;
                        CGFloat marginY;
                        if ([UIScreen mainScreen].bounds.size.width == 320) {
                            marginX = 40;
                            marginY = 80;
                        }else{
                            marginX = 50;
                            marginY = 120;
                        }
                
                
                        CGFloat imageW = [UIScreen mainScreen].bounds.size.width-2*marginX;
                        CGFloat imageH = [UIScreen mainScreen].bounds.size.height-2*marginY;
                
                        UIImageView *IdimageView = [[UIImageView alloc]init];
                        IdimageView.userInteractionEnabled = YES;
                        IdimageView.frame = CGRectMake(marginX, marginY, [UIScreen mainScreen].bounds.size.width-2*marginX, [UIScreen mainScreen].bounds.size.height-2*marginY);
                        IdimageView.image = [UIImage imageNamed:@"dengjiyanzheng_bg"];
                        [bgImageView addSubview:IdimageView];
                
                        UILabel *mesLabel = [[UILabel alloc]init];
                        NSString *alertStr = [NSString stringWithFormat:@"您申请%@的住户未能成功",userInfo[@"custom"][@"space_name"]];
                        mesLabel.text = alertStr;
                        mesLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
                        mesLabel.textColor = [UIColor blackColor];
                        mesLabel.numberOfLines = 0;
                
                        CGSize textSize = [self sizeWithText:mesLabel.text WithFont:mesLabel.font WithMaxSize:CGSizeMake(imageW-2*marginX, MAXFLOAT)];
                        mesLabel.frame = CGRectMake(marginX, imageH/2-textSize.height/2, textSize.width, textSize.height);
                        [IdimageView addSubview:mesLabel];
                        
                        UIButton *backBtn = [[UIButton alloc]init];
                        [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_success"] forState:UIControlStateNormal];
                        CGSize btnSize = CGSizeMake(3*marginX, marginX);
                        backBtn.frame = CGRectMake((imageW-btnSize.width)/2, imageH-btnSize.height-marginX/2, btnSize.width, btnSize.height);
                        [backBtn addTarget:self action:@selector(errorBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [IdimageView addSubview:backBtn];
            }else{
                [alertView show] ;
            }

            break;
        }
            
        case UIApplicationStateInactive: {
            
            
            if ([userInfo[@"custom"][@"type"] isEqualToString:@"shop"]) {
                //发货通知
                    [alertView show];
                //应用在后台
                OrderDetailViewController *detailView = [[OrderDetailViewController alloc] init];
                detailView.signStr = @"2";
                detailView.orderId = userInfo[@"order_sn"];
                GMQNavigationController *nav = [[GMQNavigationController alloc] initWithRootViewController:detailView];
                self.window.rootViewController = nav;
            }else if ([userInfo[@"custom"][@"type"] isEqualToString:@"gongdan"]){
                  [alertView show];
                //抢单通知
                MyBaoshiViewController * mybaoshi = [[MyBaoshiViewController alloc]init];
                mybaoshi.signStr = @"2" ;
                GMQNavigationController * nav = [[GMQNavigationController alloc]initWithRootViewController:mybaoshi];
                self.window.rootViewController = nav ;
            }else if ([userInfo[@"custom"][@"type"] isEqualToString:@"address_ok"]){
                //审核通过
                //更新本地审核状态
                if ([[USER_DEFAULT objectForKey:kSpace_id] isEqualToString: userInfo[@"custom"][@"sapce_id"]]) {
                    [USER_DEFAULT setObject:@"1" forKey:kAddress_valid_status] ;
                }

                bgImageView = [[UIImageView alloc]init];
                bgImageView.userInteractionEnabled = YES;
                bgImageView.frame = CGRectMake(Origin_x, Origin_y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                bgImageView.image = [UIImage imageNamed:@"login_bg"];
                [self.window addSubview:bgImageView];
                
                CGFloat marginX;
                CGFloat marginY;
                if ([UIScreen mainScreen].bounds.size.width == 320) {
                    marginX = 40;
                    marginY = 80;
                }else{
                    marginX = 50;
                    marginY = 120;
                }
                
                CGFloat imageW = [UIScreen mainScreen].bounds.size.width-2*marginX;
                CGFloat imageH = [UIScreen mainScreen].bounds.size.height-2*marginY;
                
                UIImageView *IdimageView = [[UIImageView alloc]init];
                IdimageView.userInteractionEnabled = YES;
                IdimageView.frame = CGRectMake(marginX, marginY, [UIScreen mainScreen].bounds.size.width-2*marginX, [UIScreen mainScreen].bounds.size.height-2*marginY);
                IdimageView.image = [UIImage imageNamed:@"dengjiyanzheng_bg"];
                [bgImageView addSubview:IdimageView];
                
                UILabel *mesLabel = [[UILabel alloc]init];
                NSString *alertStr = [NSString stringWithFormat:@"您已经成功验证为%@的住户!",userInfo[@"custom"][@"space_name"]];
                mesLabel.text = alertStr;
                mesLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
                mesLabel.textColor = [UIColor redColor];
                mesLabel.numberOfLines = 0;
                
                CGSize textSize = [self sizeWithText:mesLabel.text WithFont:mesLabel.font WithMaxSize:CGSizeMake(imageW-2*marginX, MAXFLOAT)];
                mesLabel.frame = CGRectMake(marginX, imageH/2-textSize.height/2, textSize.width, textSize.height);
                [IdimageView addSubview:mesLabel];
                
                UIButton *backBtn = [[UIButton alloc]init];
                [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_success"] forState:UIControlStateNormal];
                CGSize btnSize = CGSizeMake(3*marginX, marginX);
                backBtn.frame = CGRectMake((imageW-btnSize.width)/2, imageH-btnSize.height-marginX/2, btnSize.width, btnSize.height);
                [backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
                [IdimageView addSubview:backBtn];
                
            }else if ([userInfo[@"custom"][@"type"] isEqualToString:@"address_no"]){
                //审核被拒
                //更新本地审核状态
                if ([[USER_DEFAULT objectForKey:kSpace_id] isEqualToString: userInfo[@"custom"][@"sapce_id"]]) {
                    [USER_DEFAULT setObject:@"2" forKey:kAddress_valid_status] ;
                }

                bgImageView = [[UIImageView alloc]init];
                bgImageView.userInteractionEnabled = YES;
                bgImageView.frame = CGRectMake(Origin_x, Origin_y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                bgImageView.image = [UIImage imageNamed:@"bg_fail"];
                [self.window addSubview:bgImageView];
                
                CGFloat marginX;
                CGFloat marginY;
                if ([UIScreen mainScreen].bounds.size.width == 320) {
                    marginX = 40;
                    marginY = 80;
                }else{
                    marginX = 50;
                    marginY = 120;
                }
                
                
                CGFloat imageW = [UIScreen mainScreen].bounds.size.width-2*marginX;
                CGFloat imageH = [UIScreen mainScreen].bounds.size.height-2*marginY;
                
                UIImageView *IdimageView = [[UIImageView alloc]init];
                IdimageView.userInteractionEnabled = YES;
                IdimageView.frame = CGRectMake(marginX, marginY, [UIScreen mainScreen].bounds.size.width-2*marginX, [UIScreen mainScreen].bounds.size.height-2*marginY);
                IdimageView.image = [UIImage imageNamed:@"dengjiyanzheng_bg"];
                [bgImageView addSubview:IdimageView];
                
                UILabel *mesLabel = [[UILabel alloc]init];
                NSString *alertStr = [NSString stringWithFormat:@"您申请%@的住户未能成功",userInfo[@"custom"][@"space_name"]];
                mesLabel.text = alertStr;
                mesLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
                mesLabel.textColor = [UIColor blackColor];
                mesLabel.numberOfLines = 0;
                
                CGSize textSize = [self sizeWithText:mesLabel.text WithFont:mesLabel.font WithMaxSize:CGSizeMake(imageW-2*marginX, MAXFLOAT)];
                mesLabel.frame = CGRectMake(marginX, imageH/2-textSize.height/2, textSize.width, textSize.height);
                [IdimageView addSubview:mesLabel];
                
                UIButton *backBtn = [[UIButton alloc]init];
                [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_success"] forState:UIControlStateNormal];
                CGSize btnSize = CGSizeMake(3*marginX, marginX);
                backBtn.frame = CGRectMake((imageW-btnSize.width)/2, imageH-btnSize.height-marginX/2, btnSize.width, btnSize.height);
                [backBtn addTarget:self action:@selector(errorBtn:) forControlEvents:UIControlEventTouchUpInside];
                [IdimageView addSubview:backBtn];
            }


            break;
        }
        default:
            break;
    }
    
}


//新增
//button 事件-成功
-(void)clickBackBtn:(UIButton *)btn {
    
    [bgImageView removeFromSuperview];

}
//新增
//button 事件-失败
-(void)errorBtn:(UIButton *)btn {
    //    修改
    [bgImageView removeFromSuperview];
    
}


-(void)loadVersion
{
        NSString *serviceCode=@"Owner_Version";
        NSDictionary *dict=@{@"Soft_type":@"2",APP_ID:@"gmq",@"Version_code":@"0"};
    
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //本地存储的版本号
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
        [HttpService postWithServiceCode:serviceCode params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
            NSDictionary *dict =(NSDictionary*)jsonObj;
    
            NSString *service_Version = [NSString stringWithFormat:@"%@",dict[@"Data"][@"SoftVersion"]];
    
            if([dict validateOk]){
    
                if ([service_Version compare:app_Version options:NSNumericSearch] == NSOrderedDescending)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"应用商店有新版本了" message:@"去App Store下载最新版本才能使用哦！" delegate:self cancelButtonTitle:@"前去下载" otherButtonTitles:nil, nil];
                    alertView.tag = 30 ;
                    [alertView show];
                }else{
    //                NSLog(@"已经是最新版本啦");
                }
    
            }
        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        }];
}


-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //这个方法用来做action点击的统计
    [UMessage sendClickReportForRemoteNotification:userInfo];
    //下面写identifier对各个交互式的按钮进行业务处理
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 30) {
        
        NSString *url = @"https://itunes.apple.com/us/app/guo-mao-quan/id1190214138?mt=8";
        //打开iTunes
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

    }else{
            NSString *orderNum = objc_getAssociatedObject(alertView, "key");
        if (alertView.tag == 10) {
            
            if (buttonIndex == 1) {
                OrderDetailViewController *detailView = [[OrderDetailViewController alloc] init];
                detailView.signStr = @"2";
                detailView.orderId = orderNum;
                GMQNavigationController *nav = [[GMQNavigationController alloc] initWithRootViewController:detailView];
                self.window.rootViewController = nav;
            }
        }else if (alertView.tag == 20){
            
            //报事单被抢单推送给业主
            if (buttonIndex == 1) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationEvaluationOwner object:nil userInfo:nil];
                
                MyBaoshiViewController * mybaoshi = [[MyBaoshiViewController alloc]init];
                mybaoshi.signStr = @"2" ;
                GMQNavigationController * nav = [[GMQNavigationController alloc]initWithRootViewController:mybaoshi];
                self.window.rootViewController = nav ;
                
            }
        }

    }
}



//微信支付       如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
-(void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"支付成功";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                NSNotification *notification = [NSNotification notificationWithName:KNotificationOrderPayNotification object:nil userInfo:@{@"1":strMsg}] ;
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
            default:{
                strMsg = [NSString stringWithFormat:@"支付未成功"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                NSNotification *notification = [NSNotification notificationWithName:KNotificationOrderPayFail object:nil userInfo:@{@"1":strMsg}] ;
                [[NSNotificationCenter defaultCenter] postNotification:notification];

                break;
            }
        }
     
    }

}

//onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
-(void)onReq:(BaseReq *)req
{


}
 


#pragma Public Method
- (UIViewController*)topMostViewContrller
{
    UIViewController *viewController=(UIViewController*)self.window.rootViewController;
    while (viewController.presentedViewController) {
        viewController=viewController.presentedViewController;
    }
    return viewController;
}
+(AppDelegate*)sharedInstance
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}



-(CGSize)sizeWithText:(NSString *)text WithFont:(UIFont *)font WithMaxSize:(CGSize )maxSize
{
    NSDictionary *attri = @{NSFontAttributeName :font};
    return  [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
}




- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

#pragma mark ---  蓝牙后台运行设置

#pragma mark 蓝牙设置
- (void)bluetoothInit {
    
    _openDoorTool = [OpenDoorTool shareOpenDoorTool];
    
}

// 开始扫描
- (BOOL)bluetoothStartOpenDoor
{
    BOOL loginStatus=[USER_DEFAULT boolForKey:kLoginSuccess];
    if (loginStatus) {
        
        if (self.openDoorTool.mBeaconRegions.count) {
            
            self.openDoorTool.isAccreditedBeaconRegion = YES; //授权可以监控ibeacon
            [self.openDoorTool beginMonitorBeacon];
            return YES;
        }
        
    }
    return NO;
}

// beacon结束监控
- (BOOL)bluetoothStopOpenDoor
{
    BOOL loginStatus=[USER_DEFAULT boolForKey:kLoginSuccess];
    if (loginStatus) {
        return NO;
    }
    [self.openDoorTool stopMonitorForRegion:nil];
    return YES;
}

// 蓝牙发送数据后，手机震动
- (void)bluetoothOpenDoorSuccess
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    NSLog(@"进入后台");
    [_openDoorTool bluetoothCentralManagerInit];
    
    if([self bluetoothStartOpenDoor])
    {
        NSLog(@"成功开启开门操作");
    }
    else
    {
        NSLog(@"未登录状态");
    }
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self pushAction:self.pushDic application:application] ;
    //判断token是否失效
    [[RefreshManager manager] isRefreshToken];
    
    NSLog(@"进入前台");
    
//    //1. 判断定位服务是否可用
//    if(![CLLocationManager locationServicesEnabled])
//    {
//        NSLog(@"定位服务未开启");
//    }
//    if (!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
//        
//        NSLog(@"持续定位服务未开启");
//        [self.openDoorTool.locationMgr requestWhenInUseAuthorization];
//        
//    }

    //2. 判断蓝牙服务是否可用
    
    
    [_openDoorTool bluetoothCentralManagerInit];
    if([self bluetoothStartOpenDoor])
    {
        NSLog(@"成功开启开门操作");
    }
    else
    {
        NSLog(@"未登录状态");
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.


}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //进程杀死调用该方法
    
    // 应用被杀死的时候，断开所有连接
    if([self.openDoorTool.babyBlueTooth findConnectedPeripherals].count)
       [self.openDoorTool.babyBlueTooth cancelAllPeripheralsConnection];
}

@end
