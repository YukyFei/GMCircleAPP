//
//  AppSettings.m
//  YourMate
//
//  Created by Tang Shilei on 15/6/16.
//  Copyright (c) 2015年 Yourmate. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings


+(void)setCookies
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        // Here I see the correct rails session cookie
        NSLog(@"cookie: %@", cookie);
    }
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: cookies];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}

+(void)httpSetCookies
{
    NSArray *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in arcCookies){
        [cookieStorage setCookie: cookie];
    }
    
}

@end
