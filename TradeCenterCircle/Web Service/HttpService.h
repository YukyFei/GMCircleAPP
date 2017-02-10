//
//  HttpService.h
//  YourMate
//
//  Created by Tang Shilei on 14-12-5.
//  Copyright (c) 2014年 Yourmate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//回调 成功的方法
typedef void (^mSuccessBlock)(AFHTTPRequestOperation *operation,id jsonObj);
//回调失败
typedef void (^mErrorBlock)(AFHTTPRequestOperation *operation,NSError *error);

//http 请求服务
@interface HttpService : NSObject

//普通的post请求
+(void)postWithServiceCode:(NSString*)serviceCode params:(NSDictionary*)paramDict success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock;
//没有AP结构的普通post请求
+(void)postWithParams:(NSDictionary*)paramDict success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock ;

//文件上传post 请求
+(void)filePostWithServiceCode:(NSString*)serviceCode params:(NSDictionary *)paramDict andImageDatas:(NSMutableArray*)imageArray success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock;

//demo的post请求
+(void)demoPostWithServiceCode:(NSString*)serviceCode params:(NSDictionary*)paramDict success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock;

+(void)fileIDCardPostWithServiceCode:(NSString*)serviceCode params:(NSDictionary *)paramDict andImageDatas:(NSMutableArray*)imageArray success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock;

//普通的get请求
+(void)getWithUrl:(NSString *)url success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock;

//支付加载页面
+(void)csqPricePostWithParams:(NSDictionary*)paramDict success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock;

//声音请求
+(void)photoImagePost:(NSString*)serviceCode paramDict:(NSDictionary *)paramDict andImageDatas:(NSMutableArray*)imageArray andVoiceData:(NSString *)filePath  success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock;

@end
