//
//  AppSettings.h
//  YourMate
//
//  Created by Tang Shilei on 15/6/16.
//  Copyright (c) 2015年 Yourmate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

//登录成功存储cookies
+(void)setCookies;

+(void)httpSetCookies;

@end
