//
//  FileUtil.h
//  CSQ
//
//  Created by Tang Shilei on 15/3/7.
//  Copyright (c) 2015年 Yourmate. All rights reserved.
//

//文件IO
#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

AS_SINGLETON(FileUtil);


//获取document目录下文件路径
-(NSString*)getDocumentFilePath:(NSString*)fileName;
+(NSString*)getDocumentFilePath:(NSString*)fileName;
//获取Cache目录下文件路径
-(NSString *)getCachePath:(NSString*)filePath;
-(NSString *)getBundleFilePath:(NSString *)fileName;

//删除文件
-(void)delfile:(NSString *)filepath;
//文件是否存在
-(BOOL)file_exists:(NSString *)filePath;
+(BOOL)file_exists:(NSString *)filePath;
//读文件
-(NSString *)file_read:(NSString *)filePath;
//写文件
//file_write(string path,string dat,boolean append=false)
//path：待写入数据的文件全路径
//dat：待写入的数据内容
//append：true为追加写入，false为覆盖写入，默认为false
-(void)file_write:(NSString *)path :(NSString *)dat :(NSString *)append;

//在指定路径下创建目录
-(void)createDirectoryAtPath:(NSString*)path;
//指定路径创建文件
-(void)createFileAtPath:(NSString*)path;
//拷贝文件到指定目录
-(void)copyFile:(NSString*)resource toPath:(NSString*)path;








@end
