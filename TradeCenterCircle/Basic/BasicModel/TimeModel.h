//
//  TimeModel.h
//  YourMate
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 Yourmate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeModel : NSObject

@property (nonatomic, strong) NSArray *time;
@property (nonatomic, copy) NSString *day;

+ (instancetype)timeWithDict:(NSDictionary *)dict;

@end
