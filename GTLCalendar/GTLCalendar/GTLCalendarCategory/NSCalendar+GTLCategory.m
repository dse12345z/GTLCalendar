//
//  NSCalendar+GTLCategory.m
//  GTLCalendar
//
//  Created by daisuke on 2017/5/24.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "NSCalendar+GTLCategory.h"

@implementation NSCalendar (GTLCategory)

+ (NSInteger)dayFromDate:(NSDate *)fromDate {
    NSCalendarUnit calendarUnit = NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:fromDate];
    return dateComponents.day;
}

+ (NSInteger)daysFromDate:(NSDate *)fromDate {
    NSCalendarUnit rangeOfUnit = NSCalendarUnitDay;
    NSCalendarUnit inUnit = NSCalendarUnitMonth;
    NSRange rangeDays = [[NSCalendar currentCalendar] rangeOfUnit:rangeOfUnit inUnit:inUnit forDate:fromDate];
    return rangeDays.length;
}

+ (NSInteger)monthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendarUnit calendarUnit = NSCalendarUnitMonth;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:fromDate toDate:toDate options:0];
    return dateComponents.month + 1;
}

+ (NSDate *)date:(NSDate *)fromDate addMonth:(NSInteger)month {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:fromDate options:0];
}

+ (NSInteger)weekFromDate:(NSDate *)fromDate {
    // 公曆 NSCalendarIdentifierGregorian
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [gregorian components:calendarUnit fromDate:fromDate];
    dateComponents.day = 1;
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:dateComponents];
    
    NSCalendarUnit calendarUnit2 = NSCalendarUnitWeekday;
    NSDateComponents *dateComponents2 = [[NSCalendar currentCalendar] components:calendarUnit2 fromDate:firstDayOfMonthDate];
    NSArray *weeks = @[@0, @6, @0, @1, @2, @3, @4, @5];
    return [weeks[dateComponents2.weekday] integerValue];
}

+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    return components.day;
}

@end
