//
//  HttpService.m
//  YourMate
//
//  Created by Tang Shilei on 14-12-5.
//  Copyright (c) 2014年 Yourmate. All rights reserved.
//

#import "HttpService.h"
#import "JSONKit.h"
#import "AppSettings.h"
@implementation HttpService

//文件post
+(void)filePostWithServiceCode:(NSString*)serviceCode params:(NSDictionary *)paramDict andImageDatas:(NSMutableArray*)imageArray success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock
{
    if(serviceCode.length==0)
        return;

    [AppSettings httpSetCookies];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    NSString *uslStr =[hostURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:serviceCode forKey:@"A"];
    [dict setValue:[paramDict JSONString] forKey:@"P"];
    NSLog(@"%@",dict) ;
    [manager POST:uslStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         for(int i=0;i<imageArray.count;i++)
         {
             NSData *data=UIImageJPEGRepresentation(imageArray[i], 0.5);
             [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"File[]"] fileName:[NSString stringWithFormat:@"pic%d.png",i+1] mimeType:@"image/jpeg"];
         }
         
         
     } success:^(AFHTTPRequestOperation *operation,id responseObject) {
         
         successBlock(operation,responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
         errorBlock(operation, error);
         NSLog(@"%@",error);
     }];
}

//声音请求
+(void)photoImagePost:(NSString*)serviceCode paramDict:(NSDictionary *)paramDict andImageDatas:(NSMutableArray*)imageArray andVoiceData:(NSString *)filePath  success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock
{
    [AppSettings httpSetCookies];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    //设置多个文件的分隔符
    unsigned int random = arc4random();
    NSString * boundary = [NSString stringWithFormat:@"%d",random];
    
    NSString *contentType = [NSString stringWithFormat:@"boundary=%@",boundary];
    [manager.requestSerializer setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    NSString *uslStr =[hostURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 放开这三行
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:serviceCode forKey:@"A"];
    [dict setValue:[paramDict JSONString] forKey:@"P"];
    
    [manager POST:uslStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
//         // 图片处理
//         for(int i=0;i<imageArray.count;i++)
//         {
//             NSData *data=UIImageJPEGRepresentation(imageArray[i], 0.2);
//             [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"Pictures[]"] fileName:[NSString stringWithFormat:@"pic%d.jpg",i+1] mimeType:@"image/*"];
//         }
         
         for(int i=0;i<imageArray.count;i++)
         {
             NSData *data=UIImageJPEGRepresentation(imageArray[i], 0.5);
             [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"File[]"] fileName:[NSString stringWithFormat:@"pic%d.png",i+1] mimeType:@"image/jpeg"];
         }
         // 语音处理
         //方法1
         NSFileManager* fm=[NSFileManager defaultManager];
         
         NSData *data = nil;
         
         //路径是传进来的
         if([fm fileExistsAtPath:filePath]){
             
             data = [NSData dataWithContentsOfFile:filePath];
             //    NSLog(@"%@",data);
         }
         
         [formData appendPartWithFileData:data name:@"File[]" fileName:@"temp.mp3" mimeType:@"amr/mp3/wmr"];
         
     } success:^(AFHTTPRequestOperation *operation,id responseObject) {
         
         successBlock(operation,responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
         errorBlock(operation, error);
         NSLog(@"%@",error);
     }];
    
}

//身份验证请求
+(void)fileIDCardPostWithServiceCode:(NSString*)serviceCode params:(NSDictionary *)paramDict andImageDatas:(NSMutableArray*)imageArray success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock
{
    if(serviceCode.length==0)
        return;
    [AppSettings httpSetCookies];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    NSString *uslStr =[hostURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:serviceCode forKey:@"A"];
    [dict setValue:[paramDict JSONString] forKey:@"P"];
    [manager POST:uslStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         
         //根据当前系统时间生成图片名称
         NSDate *date = [NSDate date];
         NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
         [formatter setDateFormat:@"yyyy年MM月dd日"];
         NSString *dateString = [formatter stringFromDate:date];
         
         for(int i=0;i<imageArray.count;i++)
         {

             NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
             NSData *data=UIImageJPEGRepresentation(imageArray[i], 0.5);
             
             if (i == 0) {
                 
                 [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"id_card"] fileName:fileName mimeType:@"image/jpeg"];
             }else{
                 
                 [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"other"] fileName:fileName mimeType:@"image/jpeg"];
             }
             
         }
         
         
     } success:^(AFHTTPRequestOperation *operation,id responseObject) {
         
         successBlock(operation,responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
         errorBlock(operation, error);
         NSLog(@"%@",error);
     }];
}


//普通的post请求
+(void)postWithServiceCode:(NSString*)serviceCode params:(NSDictionary*)paramDict success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock
{
    if(serviceCode.length==0)
        return;
    [AppSettings httpSetCookies];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //[manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString * urlStr=[hostURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:serviceCode forKey:@"A"];
    [dict setValue:[paramDict  JSONString]  forKey:@"P"];
    
    NSLog(@"%@",[dict JSONString]);
    
    //WS(ws);
    [manager POST:urlStr parameters:dict  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [ws cancelRequest];
//            NSLog(@"取消请求啦。。。。。。");
//        });
        successBlock(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           errorBlock(operation, error);
    }];
}


//没有AP结构普通的post请求
+(void)postWithParams:(NSDictionary*)paramDict success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock
{
    
    [AppSettings httpSetCookies];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //[manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //请求网址是没有AP的域名
    NSString * urlStr=[hostURLNotAP stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:0];
//    [dict setValue:[paramDict  JSONString]  forKey:@"P"];
    
    NSLog(@"%@  ",[paramDict JSONString]);
    NSString * str = [NSString stringWithFormat:@"%@%@",urlStr,[paramDict JSONString]] ;
    NSLog(@"%@",str) ;
    //WS(ws);
    [manager POST:urlStr parameters:[paramDict  JSONString]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [ws cancelRequest];
        //            NSLog(@"取消请求啦。。。。。。");
        //        });
        successBlock(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(operation, error);
    }];
}


//demo普通的post请求
+(void)demoPostWithServiceCode:(NSString*)serviceCode params:(NSDictionary*)paramDict success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock
{
    if(serviceCode.length==0)
        return;
    [AppSettings httpSetCookies];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //[manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString * urlStr=[demoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:serviceCode forKey:@"A"];
    [dict setValue:[paramDict  JSONString]  forKey:@"P"];
    
    NSLog(@"%@",[dict JSONString]);
    
    //WS(ws);
    [manager POST:urlStr parameters:dict  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [ws cancelRequest];
        //            NSLog(@"取消请求啦。。。。。。");
        //        });
        successBlock(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(operation, error);
    }];
}

//支付加载页面
+(void)csqPricePostWithParams:(NSDictionary*)paramDict success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock
{
   
    [AppSettings httpSetCookies];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //[manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString * urlStr=[CsqPrice stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:0];
//    [dict setValue:paramDict  forKey:@"P"];
    
    NSLog(@"%@",[dict JSONString]);
    
    //WS(ws);
    [manager POST:urlStr parameters:paramDict  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [ws cancelRequest];
        //            NSLog(@"取消请求啦。。。。。。");
        //        });
        successBlock(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(operation, error);
    }];
}

+(void)getWithUrl:(NSString *)url success:(mSuccessBlock)successBlock errorBlock:(mErrorBlock)errorBlock
{
    
    [AppSettings httpSetCookies];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //[manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager POST:url parameters:nil  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [ws cancelRequest];
        //            NSLog(@"取消请求啦。。。。。。");
        //        });
        successBlock(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(operation, error);
    }];

//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//         successBlock(operation,responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        errorBlock(operation, error);
//
//    }];
    
}

+(void)cancelRequest{
    [[AFHTTPRequestOperationManager manager].operationQueue cancelAllOperations];
}
@end
