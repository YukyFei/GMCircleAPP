
#import <Foundation/Foundation.h>
#import "PayRequsestHandler.h"
/*
 服务器请求操作处理
 */
@implementation PayRequsestHandler

//初始化函数
//-(BOOL) init:(NSString *)app_id mch_id:(NSString *)mch_id;
//{
//    //初始构造函数
//    payUrl     = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
//    appid   = app_id;
//    mchid   = mch_id;
//    return YES;
//}
//设置商户密钥
-(void) setKey:(NSString *)key
{
    spkey  = [NSString stringWithString:key];
}
//获取debug信息
-(NSString*) getDebugifo
{
    return @"支付失败";
}
//获取最后服务返回错误代码
-(NSString *) getLasterrCode
{
    return[NSString stringWithFormat:@"%ld",last_errcode];
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    [contentString appendFormat:@"key=%@", spkey];
    NSString *md5Sign =[WXUtil md5:contentString];
    

    return md5Sign;
}

////获取package带参数的签名包
//-(NSString *)genPackage:(NSMutableDictionary*)packageParams
//{
//    NSString *sign;
//    NSMutableString *reqPars=[NSMutableString string];
//    sign  = [self createMd5Sign:packageParams];
//    NSArray *keys = [packageParams allKeys];
//    [reqPars appendString:@"<xml>\n"];
//    for (NSString *categoryId in keys) {
//        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [packageParams objectForKey:categoryId],categoryId];
//    }
//    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
//    return [NSString stringWithString:reqPars];
//}

////提交预支付
//-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams
//{
//    NSString *prepayid = nil;
//    NSString *send      = [self genPackage:prePayParams];
//    NSData *res = [WXUtil httpSend:payUrl method:@"POST" data:send];
//    XMLHelper *xml  = [XMLHelper alloc] ;
//    [xml startParse:res];
//    NSMutableDictionary *resParams = [xml getDict];
//    NSString *return_code   = [resParams objectForKey:@"return_code"];
//    NSString *result_code   = [resParams objectForKey:@"result_code"];
//    if ( [return_code isEqualToString:@"SUCCESS"] )
//    {
//        NSString *sign      = [self createMd5Sign:resParams ];
//        NSString *send_sign =[resParams objectForKey:@"sign"] ;
//        if( [sign isEqualToString:send_sign]){
//            if( [result_code isEqualToString:@"SUCCESS"]) {
//                prepayid    = [resParams objectForKey:@"prepay_id"];
//                return_code = 0;
//            }
//        }else{
//            last_errcode = 1;
//        }
//    }else{
//        last_errcode = 2;
//    }
//    return prepayid;
//}

- ( NSMutableDictionary *)sendTopup:(NSDictionary *)params andName:(NSString *)name withorderno:(NSString *)orderno;
{
//    NSString *order_name    = name;
//    NSString *order_price   = [NSString stringWithFormat:@"%.0f",[money floatValue]*100];
//    srand( (unsigned)time(0) );
//    NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
//    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
//    [packageParams setObject: appid             forKey:@"appid"];       //开放平台appid
//    [packageParams setObject: mchid             forKey:@"mch_id"];      //商户号
//    [packageParams setObject: @"APP-001"        forKey:@"device_info"];
//    [packageParams setObject: noncestr          forKey:@"nonce_str"];   //随机串
//    [packageParams setObject: @"APP"            forKey:@"trade_type"];
//    [packageParams setObject: order_name        forKey:@"body"];
//    NSString *notifyUrl = [name isEqualToString:@"账号"]?NOTIFY_URL:NOTIFY_URL2;
//    [packageParams setObject: notifyUrl        forKey:@"notify_url"];
//    [packageParams setObject: orderno           forKey:@"out_trade_no"];//商户订单号
//    [packageParams setObject: @"196.168.1.1"    forKey:@"spbill_create_ip"];
//    [packageParams setObject: order_price       forKey:@"total_fee"];
//    NSString *prePayid;
//    prePayid    = [self sendPrepay:packageParams];
    
    if ( params[@"package"] != nil) {
        NSString    *package, *time_stamp, *nonce_str;
        time_t now;
        time(&now);
        time_stamp  = [NSString stringWithFormat:@"%ld", now];
        package     = @"Sign=WXPay";
        nonce_str	= [WXUtil md5:time_stamp];
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: WXAPP_ID        forKey:@"appid"];
        [signParams setObject: nonce_str     forKey:@"noncestr"];
        [signParams setObject: package      forKey:@"package"];
        [signParams setObject: MCH_ID        forKey:@"partnerid"];
        [signParams setObject: time_stamp   forKey:@"timestamp"];
        NSString *prepay_id = [params objectForKey:@"package"];
        NSArray *array = [prepay_id componentsSeparatedByString:@"="];
        [signParams setObject: [array lastObject]     forKey:@"prepayid"];

         NSString *sign  = [self createMd5Sign:signParams];
        [signParams setObject: sign         forKey:@"sign"];
        
        return signParams;
    }
    return nil;
}

@end