//
//  FileUtil.m
//  CSQ
//
//  Created by Tang Shilei on 15/3/7.
//  Copyright (c) 2015年 Yourmate. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil
DEF_SINGLETON(FileUtil);

//获取document目录下文件路径
-(NSString*)getDocumentFilePath:(NSString*)fileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc_dir=[paths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",doc_dir,fileName];
    
    return filePath;
    
}

//获取document目录下文件路径
+(NSString*)getDocumentFilePath:(NSString*)fileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc_dir=[paths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",doc_dir,fileName];
    
    return filePath;

}

//获取Cache目录下文件路径
-(NSString*)getCachePath:(NSString *)filePath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    path=[path stringByAppendingPathComponent:filePath];
    
    return path;
}

-(NSString *)getBundleFilePath:(NSString *)fileName
{
    return [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:fileName];
}

//删除文件
-(void)delfile:(NSString *)filepath
{
    NSString *path =[self getDocumentFilePath:filepath];
    if([self file_exists:path])
    {
        BOOL ret=[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        if(ret)
        {
            NSLog(@"删除成功");
        }
        else
            NSLog(@"删除失败");
    }
    else
    {
        NSLog(@"文件不存在");
    }
}

//文件是否存在
-(BOOL)file_exists:(NSString *)filePath{
    
    
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:filePath];
    
}


+(BOOL)file_exists:(NSString *)filePath{
    
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:filePath];
}

//读文件 从document目录下读取文件 全部读取
-(NSString *)file_read:(NSString *)filePath
{
    NSString *path =[self getDocumentFilePath:filePath];
    if ([self file_exists:path])
    {
        NSString *str =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"str %@",str);
        return str;
    }
    return nil;
}

//都写入document目录下 ，html端只需传入文件名 写入的内容
-(void)file_write:(NSString *)path :(NSString *)dat :(NSString *)append
{
    NSString *filePath=[self getDocumentFilePath:path];
    if(![self file_exists:filePath])
        [self createFileAtPath:filePath];
    
    if([append isEqualToString:@"true"])
    {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        //追加写入
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[dat dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else
    {
     //覆盖写入
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        BOOL ret=[dat writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        if(ret)
        {
            NSLog(@"写成功");
        }
        else
        {
            NSLog(@"写失败");
        }

    }
}

-(void)createFileAtPath:(NSString *)path
{
    NSFileManager *fm= [NSFileManager defaultManager];
    if([self file_exists:path])
        return;
    BOOL ret=[fm createFileAtPath:path contents:nil attributes:nil];
    if(ret)
    {
        NSLog(@"创建成功");
    }
    else
    {
        NSLog(@"创建失败");
    }
    
}

//在指定路径创建目录
- (void)createDirectoryAtPath:(NSString *)path
{
    NSFileManager*fm= [NSFileManager defaultManager];
    NSString*filePath =[self getDocumentFilePath:path];
    if([self file_exists:filePath])
        return;
    BOOL ret=[fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    if(ret)
    {
        NSLog(@"创建目录成功");
    }
    else
    {
        NSLog(@"创建目录失败");
    }
}

-(void)copyFile:(NSString *)resource toPath:(NSString *)path
{
    NSFileManager*fileManager =[NSFileManager defaultManager];
    NSError*error;
    
    NSString *toPath=[self getDocumentFilePath:path];
    if([fileManager fileExistsAtPath:toPath]== NO){
        NSString*resourcePath =resource;
        NSLog(@"拷贝成功");
        [fileManager copyItemAtPath:resourcePath toPath:toPath error:&error];
    }
}







                    
@end
