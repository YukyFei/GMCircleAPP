//
//  NSObject+Date.h
//  
//
//  Created by zww on 15/11/3.
//  Copyright © 2015年 ZWW. All rights reserved.
//
/**
 * 类别 NSObject+Date.h 封装时间转换 实体类
 */
#import <Foundation/Foundation.h>

@interface NSObject (Date)
- (NSString*)invokeDayAndMonth:(NSTimeInterval)u;
- (NSString*)invokeYearDayMonth:(NSString*)interval;
- (NSString*)invokeYearDayMonthHourMinutsSeconds:(NSString*)interval;
- (NSString*)invokeDayMonthHourMinutsSeconds:(NSString*)interval;
- (NSString*)invokeDayAdMonth:(NSString*)u;
- (NSString*)invokeMintusAndSeconds:(NSString*)u;
- (NSString*)invokeCurrentYearMonthDay;
- (NSString*)invokeCurrentTimeStamp;
- (NSString*)invokeYearMonthDayByTimeInterval:(NSString*)u;
- (NSString*)invokeGMBString:(NSString*)kb;
- (NSString*)invokeGMBFloat:(double)total;
- (BOOL)invokeTheDaySinceNow:(NSString*)u;
- (NSString*)invokeSpaceLineFrom:(NSString*)str;
- (NSDate*)invokeDateByTimestamp:(NSString*)u;
- (NSString*)invokeDateNumbersFromNow:(NSString*)dateLast;
- (NSString*)invokeRemainDays:(NSString *)dateLast;
- (NSString*)notNullString:(NSString*)str;
- (int)invokeDayNumbersFromNow:(NSString*)dateLast;

//invokeYearDayMonth 将时间戳转换为 2015-12-12（年、月、日时分秒)
- (NSString*)invokeYearDayMonthPath:(NSString*)interval;

// 获取当前时间(2015-10-27 15:20:19)转几分钟前
- (NSString *)getTimeStringWithWDGuideCreate_at:(NSString *)create_at;
- (NSString*)intervalSinceNow: (NSString*) theDate;

@end
