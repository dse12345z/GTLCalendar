//
//  GTLCalendarView.h
//  GTLCalendar
//
//  Created by daisuke on 2017/5/23.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTLCalendarViewDataSource <NSObject>

@required

#pragma mark - GTLCalendarViewDataSource

- (NSDate *)minimumDateForGTLCalendar;
- (NSDate *)maximumDateForGTLCalendar;

@end

@protocol GTLCalendarViewDelegate <NSObject>

@optional

#pragma mark - GTLCalendarViewDelegate

- (void)selectNSDateFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (void)selectNSStringFromDate:(NSString *)fromDate toDate:(NSString *)toDate;

@end

@interface GTLCalendarView : UIView

@property (weak, nonatomic) id<GTLCalendarViewDataSource> dataSource;
@property (weak, nonatomic) id<GTLCalendarViewDelegate> delegate;

@property (strong, nonatomic) NSDate *selectFromDate;
@property (strong, nonatomic) NSDate *selectToDate;
@property (strong, nonatomic) NSString *selectedDateFormat;
@property (assign, nonatomic) NSInteger rangeDays;

@end
