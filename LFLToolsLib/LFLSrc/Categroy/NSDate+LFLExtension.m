//
//  NSDate+LFLExtension.m
//  LFLToolsLib
//
//  Created by 啸峰 on 16/9/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "NSDate+LFLExtension.h"

@implementation NSDate (LFLExtension)

- (NSTimeInterval)LFLDateToTimeInerval {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    return [self timeIntervalSince1970] - interval;
}

- (BOOL)messageNeedToGroupCompareTime:(NSDate *)compareDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *date1Components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    NSDateComponents *date2Components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:compareDate];
    if (([date1Components year] != [date2Components year]) || ([date1Components month] != [date2Components month]) || ([date1Components day] != [date2Components day])){
        return YES;
    }
    
    NSTimeInterval secondsInterval = ABS([self timeIntervalSinceDate:compareDate]);
    if (secondsInterval > 3 * 60) {
        return YES;
    }
    return NO;
}

//获取formatter
+ (NSDateFormatter *)formatMessageGroupDate:(NSDate *)date {
    const NSTimeInterval oneDayTimeInterval = 24 * 60 * 60;
    //当天零点
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today];
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *todayZero = [NSDate DPDLocalDateFromDate:[myCal dateFromComponents:components]];
    //比对时间差
    NSTimeInterval secondsInterval = [todayZero timeIntervalSinceDate:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSInteger hour = [components hour];
    if (secondsInterval < 0 ) {
        [formatter setDateFormat:@"HH:mm"];
    } else if (secondsInterval <= oneDayTimeInterval) {
        [formatter setDateFormat:@"昨天 HH:mm"];
    } else if (secondsInterval <= 6 * oneDayTimeInterval){
        NSString *weekString = [date DPDWeekDayString];
        NSString *str = [NSString stringWithFormat:@"%@ HH:mm",weekString];
        [formatter setDateFormat:str];
    } else {
        [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    }
    return  formatter;
}

- (NSString*)DPDWeekDayString
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self LFLDateToTimeInerval]];
    NSString *weekDayStr = nil;
    NSDateComponents *compo = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger weekday = [compo weekday];
    switch (weekday) {
        case 1:
            weekDayStr = @"星期日";
            break;
        case 2:
            weekDayStr = @"星期一";
            break;
        case 3:
            weekDayStr = @"星期二";
            break;
        case 4:
            weekDayStr = @"星期三";
            break;
        case 5:
            weekDayStr = @"星期四";
            break;
        case 6:
            weekDayStr = @"星期五";
            break;
        case 7:
            weekDayStr = @"星期六";
            break;
        default:
            weekDayStr = @"";
            break;
    }
    return weekDayStr;
}

+ (NSDate *)DPDLocalDateFromDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}
@end
