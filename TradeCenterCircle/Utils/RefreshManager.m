//
//  RefreshManager.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/9/21.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "RefreshManager.h"

static RefreshManager *manager = nil;

@implementation RefreshManager

/*
+(RefreshManager *)manager
{
    RefreshManager * manager = nil ;
    if (!manager) {
        manager = [[RefreshManager alloc]init] ;
    }
    return  manager ;
}
 */

/*修改*/
+(RefreshManager *)manager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[RefreshManager alloc] init];
    });
    return manager;
}

/*判断token是否失效*/
-(void)isRefreshToken
{
    [HttpService getWithUrl:RefreshTokenURL success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict = (NSDictionary *)jsonObj;

        if ([dict[@"code"] integerValue]==400) {
            //返回400说明token失效
            [self refreshToken];
        }else{
            NSLog(@"没失效,不做处理");
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

/*token失效后重新刷新token*/
-(void)refreshToken
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kLoginRefreshToken] forKey:@"Login_refresh_token"];
    [dic setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"];
    [dic setValue:[USER_DEFAULT objectForKey:kTokenExpire] forKey:@"Token_expire"];
    //增加APP字段判断登录的APP地址
    [dic setValue:@"gmq" forKey:@"App_name"] ;
    [HttpService postWithServiceCode:kUserRefreshToken params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;

        NSDictionary *dict = dicresult[@"Data"];
        
        if ([dicresult validateOk]) {
            
            NSString *login_token=[dict objectForKey:kLoginToken];
            NSString *login_refresh_token=[dict objectForKey:kLoginRefreshToken];
            
            [USER_DEFAULT setObject:login_token forKey:kLoginToken];
            [USER_DEFAULT setObject:login_refresh_token forKey:kLoginRefreshToken];
            
            [USER_DEFAULT synchronize];
            
            [self isUserLogin];
            
        }else{
            if ([[dicresult objectForKey:@"Status"] isEqualToString:@"error"]) {
                
                //登录失败去登录
                [self popAlertView];
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)isUserLogin
{
    NSLog(@"userlogin===%@=======token======%@",[USER_DEFAULT objectForKey:kUserId],[USER_DEFAULT objectForKey:kLoginToken]);
    NSLog(@"%@",[NSString stringWithFormat:@"%@user_id=%@&token=%@&app_name=gmq&community_id=%@",RefreshTokenISLOPGINURL,[USER_DEFAULT objectForKey:kUserId],[USER_DEFAULT objectForKey:kLoginToken],[USER_DEFAULT objectForKey:kCommunityId]]) ;
    
    [HttpService getWithUrl:[NSString stringWithFormat:@"%@user_id=%@&token=%@&app_name=gmq&community_id=%@",RefreshTokenISLOPGINURL,[USER_DEFAULT objectForKey:kUserId],[USER_DEFAULT objectForKey:kLoginToken],[USER_DEFAULT objectForKey:kCommunityId]] success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict = (NSDictionary *)jsonObj;

        if ([dict[@"code"] integerValue]==400) {
            //登录失败去登录
            [self popAlertView];
        }else{
            //登录成功不做处理200
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

/*网页加载异常弹出提示框*/
-(void)popAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"数据加载有误，请重新登录" message:@"亲，登录成功后才能浏览页面哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [USER_DEFAULT setBool:NO forKey:kLoginSuccess];
    [USER_DEFAULT removeObjectForKey:kGetIntoVC];
    [USER_DEFAULT synchronize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationSwitchUserLogin object:nil userInfo:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertView object:nil];
}

@end
