//
//  WeiPayUtil.h
//  WaterDeliVer
//
//  Created by Bean on 15-7-11.
//  Copyright (c) 2015年 CodeSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "PayRequsestHandler.h"
@interface WeiPayUtil : NSObject<WXApiDelegate>
@property (strong,nonatomic) NSString *orderOn;


+ (WeiPayUtil *)shareWeipay;


- (void)weipayWithParams:(NSDictionary *)params withNo:(NSString *)no andName:(NSString *)name withSuccess:(void(^)(NSDictionary* resp))success;

//- (NSString *)generateTradeWeiPayNO;
@end
