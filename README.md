# GTLCalendar

![alt tag](https://s30.postimg.org/m8c0t7fg1/GTLCalendar.gif) 

選取一個範圍的日曆

Usage
=============

1.初始化
```
// frame
CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
CGRect frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
// GTLCalendar
GTLCalendarView *gtlCalendarView = [[GTLCalendarView alloc] initWithFrame:frame];
gtlCalendarView.dataSource = self;
gtlCalendarView.delegate = self;
[self.view addSubview:gtlCalendarView];
```

2.dataSource
```
// 整個日曆的最小日期
- (NSDate *)minimumDateForGTLCalendar {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString:@"2015-05-01"];
}

// 整個日曆的最大日期
- (NSDate *)maximumDateForGTLCalendar {
    return [NSDate new];
}
```

Property & Method
=============
GTLCalendarViewDataSource
```
// required
- (NSDate *)minimumDateForGTLCalendar;  // 日曆的最小日期
- (NSDate *)maximumDateForGTLCalendar;  // 日曆的最大日期

// optional
- (NSDate *)defaultSelectFromDate;      // 預設選擇起始日期
- (NSDate *)defaultSelectToDate;        // 預設選擇結束日期
```
GTLCalendarViewDelegate
```
// optional
- (void)selectNSDateFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;        // 回傳所選擇的日期為 NSDate 型別
- (void)selectNSStringFromDate:(NSString *)fromDate toDate:(NSString *)toDate;  // 回傳所選擇的日期為 NSString 型別
- (NSInteger)rangeDaysForGTLCalendar;   // 選擇範圍的天數
- (NSInteger)itemWidthForGTLCalendar;   // 項目寬，預設 30
```
Property
```
@property (strong, nonatomic) NSString *formatString;   // delagate 回傳的日期格式，預設格式 yyyy-MM-dd
```
Method
```
- (void)clear;        // 清除所有選擇的日期
- (void)reloadData;   // reload GTLCalendar
```
