//
//  NSCalendar+GTLCategory.h
//  GTLCalendar
//
//  Created by daisuke on 2017/5/24.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (GTLCategory)

/**
 * 取得日期的日
 */
+ (NSInteger)dayFromDate:(NSDate *)fromDate;

/**
 * 計算月有幾天
 */
+ (NSInteger)daysFromDate:(NSDate *)fromDate;

/**
 * 計算兩個日期總共有幾個月
 */
+ (NSInteger)monthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/**
 * 計算日期加上 x 個月
 */
+ (NSDate *)date:(NSDate *)fromDate addMonth:(NSInteger)month;

/**
 * 計算日期「x月 1日」是星期幾
 * 0:星期一, 1:星期二, 2:星期三, 3:星期四, 4:星期五, 5:星期六, 6:星期日
 */
+ (NSInteger)weekFromDate:(NSDate *)fromDate;

/**
 * 計算兩個日期之間的天數
 */
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end
