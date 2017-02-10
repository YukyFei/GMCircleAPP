//
//  TimeModel.m
//  YourMate
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 Yourmate. All rights reserved.
//

#import "TimeModel.h"

@implementation TimeModel
+ (instancetype)timeWithDict:(NSDictionary *)dict
{
    TimeModel *time = [[TimeModel alloc] init];
    
    [time setValuesForKeysWithDictionary:dict];
    
    return time;
}

@end
