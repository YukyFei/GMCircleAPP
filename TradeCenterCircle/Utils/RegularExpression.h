//
//  RegularExpression.h
//  SsYjyLife
//
//  Created by weiwei-zhang on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularExpression : NSObject

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;

@end
