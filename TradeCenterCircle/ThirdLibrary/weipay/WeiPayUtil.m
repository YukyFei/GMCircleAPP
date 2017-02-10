//
//  WeiPayUtil.m
//  WaterDeliVer
//
//  Created by Bean on 15-7-11.
//  Copyright (c) 2015年 CodeSpace. All rights reserved.
//

#import "WeiPayUtil.h"

static WeiPayUtil *weipayUtil;

@interface WeiPayUtil ()
@property (strong,nonatomic) void(^successBlock)(NSDictionary * resp);
@property (strong,nonatomic) NSString *no;
@end

@implementation WeiPayUtil

+ (WeiPayUtil *)shareWeipay
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weipayUtil = [[WeiPayUtil alloc]init];
    });
    return weipayUtil;
}

- (void)weipayWithParams:(NSDictionary *)params withNo:(NSString *)no andName:(NSString *)name withSuccess:(void(^)(NSDictionary* resp))success
{
    self.no = no;
    self.successBlock = success;
    PayRequsestHandler *req = [PayRequsestHandler alloc];
//    [req init:WXAPP_ID mch_id:MCH_ID];
    [req setKey:PARTNER_ID];
    NSMutableDictionary *dict = [req sendTopup:params andName:name withorderno:self.orderOn];
    if(dict == nil){
        NSString *debug = [req getLasterrCode];
        KShowAlert(@"提示", @"该订单已支付完～");
        
    }else{
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
}

//-(void) onResp:(BaseResp*)resp
//{
//    
////    self.successBlock(resp);
//    NSDictionary *dic = @{
//                          @"order_id":self.no,
//                          };
//    [JDBaseHttpTool sendWXPayStatusRequestWith:dic WithSuccess:^(id responseObj) {
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"payFinish" object:nil userInfo:responseObj];
//        
//    } failure:^(NSError *error) {
//        
//    }];
//    
//}

// 生成微信订单号
//- (NSString *)generateTradeWeiPayNO
//{
//    NSString *sourceStr = @"0123456789";
//    NSDate *date = [NSDate date];
//    NSDateFormatter *ff = [[NSDateFormatter alloc]init];
//    ff.dateFormat = @"yyyyMMddHHmmss";
//    NSMutableString *resultStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@",@"wxb",[ff stringFromDate:date]]];
//    for (int i = 0; i < 5; i++)
//    {
//        unsigned index = arc4random()%sourceStr.length;
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    self.orderOn = resultStr;
//    return resultStr;
//}


@end
