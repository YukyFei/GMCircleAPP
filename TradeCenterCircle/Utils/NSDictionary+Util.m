//
//  NSDictionary+Util.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/10.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "NSDictionary+Util.h"

@implementation NSDictionary (Util)

-(BOOL)validateOk
{
    if([[self objectForKey:@"Status"] isEqualToString:@"success"])
    {
        return YES;
    }
    return NO;
}
@end
