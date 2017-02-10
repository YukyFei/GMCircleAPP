//
//  GlobalManager.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/10.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface GlobalManager : GMQBasicModel

//设置第一次启动
+ (void)setFirstLaunch;
//是否第一次启动
+ (BOOL)isFirstLaunch;

//账户
+ (void)setAccount:(NSString*)phoneNum;
+ (NSString*)account;

//注册码
+ (void)setRegisterCode:(NSString*)code;
+ (NSString*)registerCode;

@end
