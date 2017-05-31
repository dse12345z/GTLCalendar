//
//  ViewController.m
//  GTLCalendar
//
//  Created by daisuke on 2017/5/23.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "ViewController.h"
#import "GTLCalendarView.h"

@interface ViewController () <GTLCalendarViewDataSource, GTLCalendarViewDelegate>

@end

@implementation ViewController

#pragma mark - GTLCalendarViewDataSource

- (NSDate *)minimumDateForGTLCalendar {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString:@"2015-05-01"];
}

- (NSDate *)maximumDateForGTLCalendar {
    return [NSDate new];
}

- (NSInteger)rangeDaysForGTLCalendar {
    return 30 * 6;
}

- (NSDate *)defaultSelectFromDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString:@"2017-05-10"];
}

- (NSDate *)defaultSelectToDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString:@"2017-05-26"];
}

#pragma mark - GTLCalendarViewDelegate

- (void)selectNSStringFromDate:(NSString *)fromDate toDate:(NSString *)toDate {
    NSLog(@"fromDate: %@, toDate: %@", fromDate, toDate);
}

#pragma mark - private instance method

#pragma mark * init values

- (void)setupGTLCalendarViews {
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGRect frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    GTLCalendarView *gtlCalendarView = [[GTLCalendarView alloc] initWithFrame:frame];
    gtlCalendarView.dataSource = self;
    gtlCalendarView.delegate = self;
    [self.view addSubview:gtlCalendarView];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGTLCalendarViews];
}

@end
