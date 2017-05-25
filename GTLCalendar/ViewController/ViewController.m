//
//  ViewController.m
//  GTLCalendar
//
//  Created by daisuke on 2017/5/23.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "ViewController.h"
#import "GTLCalendarView.h"
#import "NSCalendar+GTLCategory.h"

@interface ViewController () <GTLCalendarViewDataSource, GTLCalendarViewDelegate>

@end

@implementation ViewController

#pragma mark - GTLCalendarViewDataSource

- (NSDate *)minimumDateForGTLCalendar {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString:@"2015-01-01"];
}

- (NSDate *)maximumDateForGTLCalendar {
    return [NSDate new];
}

#pragma mark - GTLCalendarViewDelegate

- (void)selectFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSLog(@"fromDate: %@, toDate: %@", [dateFormatter stringFromDate:fromDate], [dateFormatter stringFromDate:toDate]);
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
    gtlCalendarView.rangeDays = 30 * 6;
    [self.view addSubview:gtlCalendarView];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGTLCalendarViews];
}

@end
