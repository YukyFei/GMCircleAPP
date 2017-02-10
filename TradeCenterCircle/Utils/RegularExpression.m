//
//  RegularExpression.m
//  SsYjyLife
//
//  Created by weiwei-zhang on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RegularExpression.h"

@implementation RegularExpression

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^[1][3|4|5|6|8|7|9]\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

@end
