//
//  NSObject+Date.m
//  
//
//  Created by zww on 15/11/3.
//  Copyright © 2015年 ZWW. All rights reserved.
//

#import "NSObject+Date.h"

@implementation NSObject (Date)

//invokeDayAndMonth 将时间戳转换为 12.12（月、日）
- (NSString*)invokeDayAndMonth:(NSTimeInterval)u
{
    @autoreleasepool {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:u];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = kCFDateFormatterShortStyle;
        fmt.timeStyle = kCFDateFormatterNoStyle;
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"MM.dd";
        NSString* dateString = [fmt stringFromDate:date];
        fmt = nil;
        return dateString;
    }
}

//获取当前时间
// create_at 2015-10-27 15:20:19
// return 10秒前、2分钟前、2小时前、2天前、7月8日

- (NSString *)getTimeStringWithWDGuideCreate_at:(NSString *)create_at
{
    // 1.创建日期格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 3 设置日期格式化类型
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //4 获取日期对象
    NSDate *date = [dateFormatter dateFromString:create_at];
    //5 获取日期对象距离当前时间有多少秒
    long long time = ABS([date timeIntervalSinceNow]);
    //6 通过时间差来返回字符串
    if (time < 60)
    {
        return [NSString stringWithFormat:@"%lld秒前",time];
    }else if (time < 60 * 60)
    {
        return [NSString stringWithFormat:@"%lld分钟前",time / 60];
    }else if (time < 60 * 60 * 24)
    {
        return [NSString stringWithFormat:@"%lld小时前",time / (60 * 60)];
        
    }
    else if (time < 60 * 60 * 24 * 7)
    {
        return [NSString stringWithFormat:@"%lld天前",time / (60 * 60 * 24)];
    }
    else {
        
        // 设置日期格式化类型
        [dateFormatter setDateFormat:@"MM月dd日"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        return dateString;
    }
}

- (NSDate *)getDateFromString:(NSString *)dateString WithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *bdate = [dateFormatter dateFromString:dateString];
    return bdate;
}
- (NSString *)getStringOfDate:(NSDate *)date useFormate:(NSString *)formateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:formateStr];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString *datestring = [dateFormatter stringFromDate:date];
    return datestring;
}
- (NSString*)intervalSinceNow: (NSString*) theDate
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSString*timeString=@"";
    
    NSTimeInterval cha=now-[theDate longLongValue];
    
    //发表在一小时之内
    
    if(cha/3600<1) {
        
        if(cha/60<1) {
            
            timeString = @"1";
            
        }
        
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            
            timeString = [timeString substringToIndex:timeString.length-7];
        }
 
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    
    //在一小时以上24小以内
    else if(cha/3600>1&&cha/86400<1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    
    //发表在24以上10天以内
    
    else if(cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    
    //发表时间大于10天
    else
    {
        
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        
        NSArray*array = [theDate componentsSeparatedByString:@" "];
        
        
        //        return [array objectAtIndex:0];
        
        timeString = [array objectAtIndex:0];
        
        timeString = [timeString substringWithRange:NSMakeRange(5, [timeString length]-5)];
    }
    return timeString;
}

//invokeYearDayMonth 将时间戳转换为 2015-12-12（年、月、日时分秒)
- (NSString*)invokeYearDayMonth:(NSString*)interval
{
    @autoreleasepool {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[interval longLongValue]];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = kCFDateFormatterShortStyle;
        fmt.timeStyle = kCFDateFormatterNoStyle;
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
        NSString* dateString = [fmt stringFromDate:date];
        fmt = nil;
        return dateString;
    }
}

//invokeYearDayMonth 将时间戳转换为 2015-12-12（年、月、日)
- (NSString*)invokeYearDayMonthPath:(NSString*)interval
{
    @autoreleasepool {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[interval longLongValue]];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = kCFDateFormatterShortStyle;
        fmt.timeStyle = kCFDateFormatterNoStyle;
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSString* dateString = [fmt stringFromDate:date];
        fmt = nil;
        return dateString;
    }
}


//invokeYearDayMonthHourMinutsSeconds 将时间戳转换为 2015-12-12 星期几（年－月－日 星期几)
- (NSString*)invokeYearDayMonthHourMinutsSeconds:(NSString*)interval
{
    @autoreleasepool {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:[interval longLongValue]];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = kCFDateFormatterShortStyle;
        fmt.timeStyle = kCFDateFormatterNoStyle;
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [fmt setDateFormat:@"yyyy-MM-dd EEEE"];
        NSString* dateString = [fmt stringFromDate:date];
        fmt = nil;
        return dateString;
    }
}

//invokeDayMonthHourMinutsSeconds 将时间戳转换为 12-12 12:12（月－日 时－分)
- (NSString*)invokeDayMonthHourMinutsSeconds:(NSString*)interval
{
    @autoreleasepool {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[interval longLongValue]];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = kCFDateFormatterShortStyle;
        fmt.timeStyle = kCFDateFormatterNoStyle;
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy-MM-dd  HH:mm:ss";
        NSString* dateString = [fmt stringFromDate:date];
        fmt = nil;
        return dateString;
    }
}

//invokeDateByTimestamp 将时间戳转换为 2015-12-12 12:12:12（年－月－日 时－分－秒)
- (NSDate*)invokeDateByTimestamp:(NSString*)u
{
    @autoreleasepool {
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = kCFDateFormatterShortStyle;
        fmt.timeStyle = kCFDateFormatterNoStyle;
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [fmt dateFromString:[NSString stringWithFormat:@"%@ 08:00:00",u]];
        return date;
    }
}

- (NSString*)invokeDayAdMonth:(NSString*)u
{
    @autoreleasepool {
        NSArray *arr = [u componentsSeparatedByString:@"-"];
        NSString *dateString = [NSString stringWithFormat:@"%@.%@",[arr objectAtIndex:1],[arr objectAtIndex:2]];
        return [self notNullString:dateString];
    }
}

- (NSString*)invokeRemainDays:(NSString *)dateLast
{
    /*date format*/
    NSDate *date = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateStyle = kCFDateFormatterShortStyle;
    fmt.timeStyle = kCFDateFormatterNoStyle;
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [fmt stringFromDate:date];
    
    /*date*/
    NSDate *newdate = [fmt dateFromString:dateString];
    /**/
    //    NSDate *lastdate = [fmt dateFromString:dateLast];
    
    /*timestamp*/
    NSTimeInterval now = [newdate timeIntervalSince1970];
    //    NSTimeInterval last = [lastdate timeIntervalSince1970];
    NSTimeInterval last = [dateLast doubleValue];
    int days = abs((now-last)/(3600*24));
    /**/
    return [NSString stringWithFormat:@"公放期还有%d天",days];
}

//时、分、秒转换
- (NSString*)invokeMintusAndSeconds:(NSString*)u
{
    @autoreleasepool {
        NSString   *str;
        NSTimeInterval t = [u doubleValue];
        int  hour = floor(t/3600);
        int  r = fmod(t,3600);
        int  minuts = floor(r/60);
        int  seconds = fmod(r,60);
        
        if (hour>0) {
            str = [NSString stringWithFormat:@"%d时%d分%d秒",hour,minuts,seconds];
        }else if (minuts>0){
            str = [NSString stringWithFormat:@"%d分%d秒",minuts,seconds];
        }else if(seconds>0){
            str = [NSString stringWithFormat:@"%d秒",seconds];
        }else{
            str = @"未知";
        }
        return str;
    }
}

//invokeCurrentYearMonthDay 转换为2015年12月12日
- (NSString*)invokeCurrentYearMonthDay
{
    @autoreleasepool {
        NSDate *date = [NSDate date];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = kCFDateFormatterShortStyle;
        fmt.timeStyle = kCFDateFormatterNoStyle;
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy年MM月dd日";
        NSString* dateString = [fmt stringFromDate:date];
        fmt = nil;
        return dateString;
    }
}

- (NSString*)invokeCurrentTimeStamp
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",now];
}

//invokeYearMonthDayByTimeInterval 转换为2015－12－12
- (NSString*)invokeYearMonthDayByTimeInterval:(NSString*)u
{
    @autoreleasepool {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[u doubleValue]];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = kCFDateFormatterShortStyle;
        fmt.timeStyle = kCFDateFormatterNoStyle;
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSString* dateString = [fmt stringFromDate:date];
        fmt = nil;
        return dateString;
    }
}

#pragma mark 
#pragma mark 计算缓存大小
- (NSString*)invokeGMBString:(NSString*)kb
{
    @autoreleasepool {
        double total = [kb doubleValue];
        double mb = total/1024/1024;
        return [NSString stringWithFormat:@"%.02f MB",mb];
    }
}

- (NSString*)invokeGMBFloat:(double)total
{
    double mb = total/1024/1024;
    return [NSString stringWithFormat:@"%.02f MB",mb];
}

- (BOOL)invokeTheDaySinceNow:(NSString*)u
{
    NSTimeInterval t = [u doubleValue];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (t<now) {
        return YES;
    }else{
        return NO;
    }
    
}
- (NSString*)invokeSpaceLineFrom:(NSString*)str
{
    return [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (NSString*)invokeDateNumbersFromNow:(NSString*)dateLast
{
    @autoreleasepool {
        NSString *result;
        
        /*date format*/
        NSDate *date = [NSDate date];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = kCFDateFormatterShortStyle;
        fmt.timeStyle = kCFDateFormatterNoStyle;
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSString* dateString = [fmt stringFromDate:date];
        
        /*date*/
        NSDate *newdate = [fmt dateFromString:dateString];
        NSDate *lastdate = [fmt dateFromString:dateLast];
        
        /*timestamp*/
        NSTimeInterval now = [newdate timeIntervalSince1970];
        NSTimeInterval last = [lastdate timeIntervalSince1970];
        int days = (now-last)/(3600*24);
        switch (days) {
            case -3:
                result = @"6";
                break;
            case -2:
                result = @"5";
                break;
            case -1:
                result = @"4";
                break;
            case 0:
                result = @"3";
                break;
            case 1:
                result = @"2";
                break;
            case 2:
                result = @"1";
                break;
            default:
                break;
        }
        return result;
    }
}

- (int)invokeDayNumbersFromNow:(NSString*)dateLast
{
    @autoreleasepool {
        /*date format*/
        NSDate *date = [NSDate date];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = kCFDateFormatterShortStyle;
        fmt.timeStyle = kCFDateFormatterNoStyle;
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSString* dateString = [fmt stringFromDate:date];
        
        /*date*/
        NSDate *newdate = [fmt dateFromString:dateString];
        NSDate *lastdate = [fmt dateFromString:dateLast];
        
        /*timestamp*/
        NSTimeInterval now = [newdate timeIntervalSince1970];
        NSTimeInterval last = [lastdate timeIntervalSince1970];
        int days = (now-last)/(3600*24);
        return days;
    }
}



//notNullString 用于时间空值处理
- (NSString*)notNullString:(NSString*)str
{
    NSLog(@"str=%@",str);
    if (!str||[str isEqualToString:@"(null)"]||[str isEqualToString:@"(null).(null)"]) {
        return @"...";
    }else{
        return str;
    }
}


@end

