//
//  GlobalManager.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/10.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GlobalManager.h"

#define FIRST_LAUNCH @"firstLaunch"
#define HAS_SELECT_COMMUNITY @"selectNewCommunity"
#define REGISTER_CODE @"registerCode"
#define REGISTER_ACCOUNT @"registerACCOUNT"
#define REGISTER_PASSWORD @"REGISTER_PASSWORD"

@implementation GlobalManager

+ (void)setFirstLaunch
{
    [USER_DEFAULT setBool:YES forKey:FIRST_LAUNCH];
    [USER_DEFAULT synchronize];
}

+ (BOOL)isFirstLaunch
{
    BOOL isFirstLaunch =[USER_DEFAULT boolForKey:FIRST_LAUNCH];
    return isFirstLaunch;
}

+ (void)setRegisterCode:(NSString *)code
{
    [USER_DEFAULT setValue:code forKey:REGISTER_CODE];
    [USER_DEFAULT synchronize];
}

+(NSString*)registerCode
{
    return [USER_DEFAULT valueForKey:REGISTER_CODE];
}

+(void)setAccount:(NSString *)phoneNum
{
    [USER_DEFAULT setValue:phoneNum forKey:REGISTER_ACCOUNT];
    [USER_DEFAULT synchronize];
}

+(NSString*)account
{
    return [USER_DEFAULT valueForKey:REGISTER_ACCOUNT];
}

@end
