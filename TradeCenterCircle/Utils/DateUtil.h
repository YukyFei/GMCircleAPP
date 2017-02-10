//
//  DateUtil.h
//  iHummingBird
//
//  Created by Tang Shilei on 14-10-4.
//  Copyright (c) 2014年 HummingBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSString *)getFormatTime:(NSDate *)date format:(NSString *)format;
+ (NSString *)getFormatTime:(NSDate *)date;
+ (NSDate *)convertTime:(NSString *)time;
+ (NSDate *)convertTimeFromNumber:(NSNumber *)time;
+ (NSDate *)dateFromComponent:(NSDateComponents *)omponent;
+ (NSString *)convertToDay:(NSDate *)date;
+ (NSNumber *)convertNumberFromTime:(NSDate *)time;
+ (NSString *)getMessageTime:(NSDate *)date;
+ (NSString *)getDisplayTime:(NSDate *)date;
+ (NSString *)getYears:(NSDate *)date;
+ (NSString *)getDisplayTime:(NSDate *)date num:(NSInteger)num;
+ (NSDateComponents *)getComponenet:(NSDate *)date;
+ (NSString *)getYear;
+ (NSString *)getMonth:(NSDate *)date;
+ (NSString *)getYearMonthDay:(NSDate *)date;
+ (NSMutableArray *)getMonthArray;
+ (NSDate *)convertDay:(NSString *)time;
+ (NSString *)getYearMonth:(NSDate *)date;
+ (NSMutableArray *)getMonthArrayFrom2014;
+ (NSInteger)getWeekDay:(NSString *)theDay;
+ (NSMutableArray *)getYearArrayFrom2014;
+ (NSMutableArray *)getMonthByYearArrayFrom2014;

//时间格式
+(NSDateFormatter*)dateFormatter;

+(NSString*)formatDateFromDate:(NSDate*)date;


@end
