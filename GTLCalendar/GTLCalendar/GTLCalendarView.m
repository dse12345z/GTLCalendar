//
//  GTLCalendarView.m
//  GTLCalendar
//
//  Created by daisuke on 2017/5/23.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "GTLCalendarView.h"
#import "GTLGradientView.h"
#import "GTLCalendarCell.h"
#import "GTLCalendarHeaderReusableView.h"
#import "GTLCalendarCollectionViewFlowLayout.h"
#import "NSCalendar+GTLCategory.h"

#define itemTexTColor [UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1]
#define dayTexTColor [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1]
#define dayOutTexTColor [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:0.3]

@interface GTLCalendarView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *sectionRows;
@property (strong, nonatomic) NSMutableDictionary *gradientViewInfos;
@property (assign, nonatomic) NSInteger months;

@end

@implementation GTLCalendarView
@synthesize selectedDateFormat = _selectedDateFormat;

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.months;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sectionRows[section] integerValue];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GTLCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GTLCalendarCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.isFromDate = NO;
    cell.isToDate = NO;
    
    // 依照 section index 計算日期
    NSDate *fromDate = [self.dataSource minimumDateForGTLCalendar];
    NSDate *sectionDate = [NSCalendar date:fromDate addMonth:indexPath.section];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    
    // 包含前一個月天數
    NSInteger containPreDays = [NSCalendar weekFromMonthFirstDate:sectionDate];
    
    // 一、二、三 ... 日，7 個項目
    if (indexPath.row < 7) {
        cell.dayLabel.text = [self itemStringDays][indexPath.row];
        cell.dayLabel.textColor = itemTexTColor;
    }
    else {
        NSInteger shiftIndex = indexPath.row - 7;
        if (shiftIndex >= containPreDays) {
            shiftIndex -= containPreDays;
            cell.dayLabel.text = [NSString stringWithFormat:@"%td", shiftIndex + 1];
            
            NSDate *yyMMDDDate = [self dateYYMMConvertToYYMMDD:sectionDate withDay:shiftIndex + 1];
            if ([yyMMDDDate compare:fromDate] == NSOrderedAscending) {
                cell.dayLabel.textColor = dayOutTexTColor;
            }
            else {
                cell.dayLabel.textColor = dayTexTColor;
            }
            
            BOOL isOnRangeDate = [NSCalendar isOnRangeFromDate:self.selectFromDate toDate:self.selectToDate date:yyMMDDDate];
            
            if (isOnRangeDate) {
                cell.dayLabel.textColor = [UIColor whiteColor];
                [self recordGradientInfo:yyMMDDDate frame:cell.frame];
            }
            
            NSString *selectFromDateString = [self yyMMDDStringConvertFromDate:self.selectFromDate];
            NSString *selectToDateString = [self yyMMDDStringConvertFromDate:self.selectToDate];
            NSString *yyMMDDDateString = [self yyMMDDStringConvertFromDate:yyMMDDDate];
            if ([selectFromDateString isEqualToString:yyMMDDDateString]) {
                cell.dayLabel.textColor = [UIColor whiteColor];
                cell.isFromDate = YES;
                [self recordGradientInfo:yyMMDDDate frame:cell.frame];
            }
            
            if ([selectToDateString isEqualToString:yyMMDDDateString]) {
                cell.dayLabel.textColor = [UIColor whiteColor];
                cell.isToDate = YES;
                [self recordGradientInfo:yyMMDDDate frame:cell.frame];
            }
            
            // 選擇第一個日期，則把大於 rangeDays 的日期關閉
            if (self.selectFromDate && !self.selectToDate) {
                NSInteger days = [NSCalendar daysFromDate:self.selectFromDate toDate:yyMMDDDate];
                if (labs(days) > self.rangeDays) {
                    cell.dayLabel.textColor = dayOutTexTColor;
                }
            }
            
            // 最大日期
            if (indexPath.section == self.sectionRows.count - 1) {
                NSDate *toDate = [self.dataSource maximumDateForGTLCalendar];
                NSInteger day = [NSCalendar dayFromDate:toDate];
                
                // 超過最大日期的日數則改變顏色
                if (shiftIndex + 1 > day) {
                    cell.dayLabel.textColor = dayOutTexTColor;
                }
            }
        }
        else {
            // 前一個月份
            cell.dayLabel.text = @"";
            cell.dayLabel.textColor = dayTexTColor;
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSDate *fromDate = [self.dataSource minimumDateForGTLCalendar];
        
        // 計算開始日期加上 x 數字後的日期
        NSDate *sectionDate = [NSCalendar date:fromDate addMonth:indexPath.section];
        
        // 轉日期格式 yyyy年MM月
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy年MM月";
        NSString *dateString = [dateFormatter stringFromDate:sectionDate];
        
        GTLCalendarHeaderReusableView *gtlCalendarHeaderReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"GTLCalendarHeaderReusableView" forIndexPath:indexPath];
        gtlCalendarHeaderReusableView.dateLabel.text = dateString;
        return gtlCalendarHeaderReusableView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 依照 section index 計算日期
    NSDate *fromDate = [self.dataSource minimumDateForGTLCalendar];
    NSDate *sectionDate = [NSCalendar date:fromDate addMonth:indexPath.section];
    
    // 包含前一個月天數
    NSInteger containPreDays = [NSCalendar weekFromMonthFirstDate:sectionDate];
    
    NSInteger shiftIndex = indexPath.row - 7;
    // 項目 一、二 ... 日以外的點擊
    if (shiftIndex >= containPreDays) {
        shiftIndex -= containPreDays;
        
        // 判斷是否點超過當天日期
        if (indexPath.section == self.sectionRows.count - 1) {
            NSDate *toDate = [self.dataSource maximumDateForGTLCalendar];
            NSInteger day = [NSCalendar dayFromDate:toDate];
            
            // 超過最大日期的日數
            if (shiftIndex + 1 > day) {
                return;
            }
        }

        NSDate *yyMMDDDate = [self dateYYMMConvertToYYMMDD:sectionDate withDay:shiftIndex + 1];
        if ([yyMMDDDate compare:fromDate] == NSOrderedAscending) {
            return;
        }

        if (self.selectFromDate) {
            if (self.selectToDate) {
                // 重新選擇日期區域範圍
                self.selectFromDate = yyMMDDDate;
                self.selectToDate = nil;
                
                [self removeAllGTLGradientView];
            }
            else {
                NSInteger days = [NSCalendar daysFromDate:self.selectFromDate toDate:yyMMDDDate];
                if (days > 0 && days <= self.rangeDays) {
                    self.selectToDate = yyMMDDDate;
                }
                else if (days < 0 && labs(days) <= self.rangeDays){
                    self.selectToDate = self.selectFromDate;
                    self.selectFromDate = yyMMDDDate;
                }
                else if (days == 0) {
                    self.selectFromDate = nil;
                    [self removeAllGTLGradientView];
                }
            }
        }
        else {
            self.selectFromDate = yyMMDDDate;
            [self removeAllGTLGradientView];
        }
        
        // delegate
        if ([self.delegate respondsToSelector:@selector(selectNSStringFromDate:toDate:)]) {
            NSDateFormatter *selectFormatter = [[NSDateFormatter alloc] init];
            selectFormatter.dateFormat = self.selectedDateFormat;
            NSString *cacheFromDate = [selectFormatter stringFromDate:self.selectFromDate];
            NSString *cacheToDate = [selectFormatter stringFromDate:self.selectToDate];
            
            if (self.selectFromDate && self.selectToDate) {
                
                [self.delegate selectNSStringFromDate:cacheFromDate toDate:cacheToDate];
            }
            else if(self.selectFromDate) {
                [self.delegate selectNSStringFromDate:cacheFromDate toDate:cacheFromDate];
            }
            else {
                [self.delegate selectNSStringFromDate:@"" toDate:@""];
            }
        }
        else if ([self.delegate respondsToSelector:@selector(selectNSDateFromDate:toDate:)]) {
            if (self.selectFromDate && self.selectToDate) {
                [self.delegate selectNSDateFromDate:self.selectFromDate toDate:self.selectToDate];
            }
            else if(self.selectFromDate) {
                [self.delegate selectNSDateFromDate:self.selectFromDate toDate:self.selectFromDate];
            }
            else {
                [self.delegate selectNSDateFromDate:nil toDate:nil];
            }
        }
        
        [self.collectionView reloadData];
    }
}

#pragma mark - instance method

#pragma mark * properties

- (NSString *)selectedDateFormat {
    if (_selectedDateFormat.length == 0) {
        _selectedDateFormat = @"yyyy-MM-dd";
    }
    return _selectedDateFormat;
}

#pragma mark - private instance method

#pragma mark * init values

- (void)setupInitValues {
    self.gradientViewInfos = [[NSMutableDictionary alloc] init];
    
    // 計算有幾個月份
    NSDate *fromDate = [self.dataSource minimumDateForGTLCalendar];
    NSDate *toDate = [self.dataSource maximumDateForGTLCalendar];
    self.months = [NSCalendar monthsFromDate:fromDate toDate:toDate];
    
    // 計算月份天數
    self.sectionRows = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < self.months; index++) {
        // 依照 section index 計算日期
        NSDate *fromDate = [self.dataSource minimumDateForGTLCalendar];
        NSDate *sectionDate = [NSCalendar date:fromDate addMonth:index];
        
        // 當月天數
        NSInteger days = [NSCalendar daysFromDate:sectionDate];
        
        // 包含前一個月天數
        NSInteger sectionDateWeek = [NSCalendar weekFromMonthFirstDate:sectionDate];
        NSInteger containPreDays = (sectionDateWeek == 6) ? 0 : sectionDateWeek;
        
        // 包含前一個月天數
        NSInteger weekItems = 7;
        
        [self.sectionRows addObject:@(weekItems + containPreDays + days)];
    }
}

- (void)setupCollectionViews {
    CGFloat calendarViewWidth = CGRectGetWidth(self.frame);
    CGFloat calendarViewHeight = CGRectGetHeight(self.frame);
    CGRect collectionViewFrame = CGRectMake(0, 0, calendarViewWidth, calendarViewHeight);
    
    CGFloat items = 7;              // 一、二 ... 日
    CGFloat itemWidth = 30;         // 項目寬
    CGFloat interitem = items + 1;  // 項目間距數量
    CGFloat collectionViewWidth = CGRectGetWidth(collectionViewFrame);
    CGFloat space = (collectionViewWidth - (items * itemWidth)) / interitem;
    CGFloat headerWidth = calendarViewWidth;
    
    GTLCalendarCollectionViewFlowLayout *flowLayout = [[GTLCalendarCollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 12;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.headerReferenceSize = CGSizeMake(headerWidth, 50);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionRows = self.sectionRows;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[GTLCalendarCell class] forCellWithReuseIdentifier:@"GTLCalendarCell"];
    [self.collectionView registerClass:[GTLCalendarHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GTLCalendarHeaderReusableView"];
    [self addSubview:self.collectionView];
    
    // 移動到當天月份
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.months - 1];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

#pragma mark * misc

- (NSArray *)itemStringDays {
    return @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
}

- (GTLGradientView *)gtlGradientView:(CGPoint)point {
    CGRect frame = CGRectMake(point.x, point.y, 30, 30);
    GTLGradientView *gtlGradientView = [[GTLGradientView alloc] initWithFrame:frame];
    gtlGradientView.alpha = 0;
    gtlGradientView.clipsToBounds = YES;
    gtlGradientView.layer.cornerRadius = 15;
    return gtlGradientView;
}

- (void)removeAllGTLGradientView {
    for (NSString *key in self.gradientViewInfos.allKeys) {
        GTLGradientView *gtlGradientView = self.gradientViewInfos[key][@"view"];
        [gtlGradientView removeFromSuperview];
    }
    [self.gradientViewInfos removeAllObjects];
}

- (NSString *)yyMMDDStringConvertFromDate:(NSDate *)date {
    NSDateFormatter *yyMMDDDateFormatter = [[NSDateFormatter alloc] init];
    yyMMDDDateFormatter.dateFormat = @"yyyy年MM月dd日";
    return [yyMMDDDateFormatter stringFromDate:date];
}

- (NSDate *)dateYYMMConvertToYYMMDD:(NSDate *)date withDay:(NSInteger)day {
    // 轉日期格式 yyyy年MM月 to yyyy年MM月DD日
    NSDateFormatter *yyMMDateFormatter = [[NSDateFormatter alloc] init];
    yyMMDateFormatter.dateFormat = @"yyyy年MM月";
    NSString *yyMMString = [yyMMDateFormatter stringFromDate:date];
    NSString *yyMMDDString = [NSString stringWithFormat:@"%@%02ld日", yyMMString, day];
    
    NSDateFormatter *yyMMDDDateFormatter = [[NSDateFormatter alloc] init];
    yyMMDDDateFormatter.dateFormat = @"yyyy年MM月dd日";
    return [yyMMDDDateFormatter dateFromString:yyMMDDString];
}

- (void)recordGradientInfo:(NSDate *)date frame:(CGRect)frame {
    NSString *key = [NSString stringWithFormat:@"%f", CGRectGetMinY(frame)];
    if (self.gradientViewInfos[key]) {
        GTLGradientView *gtlGradientView = self.gradientViewInfos[key][@"view"];
        CGRect cacheFrame = gtlGradientView.frame;
        CGRect convertFrame = gtlGradientView.frame;
        
        if (CGRectGetMinX(cacheFrame) > CGRectGetMinX(frame)) {
            convertFrame.origin.x = CGRectGetMinX(frame);
            convertFrame.size.width = CGRectGetMaxX(cacheFrame) - CGRectGetMinX(frame);
        }
        else if (CGRectGetMinX(cacheFrame) < CGRectGetMinX(frame)){
            convertFrame.size.width = CGRectGetMaxX(frame) - CGRectGetMinX(cacheFrame);
        }
        
        if (gtlGradientView.alpha == 0) {
            [UIView animateWithDuration:0.5 animations: ^{
                gtlGradientView.alpha = 1;
                gtlGradientView.frame = convertFrame;
            }];
        }
        else {
            gtlGradientView.frame = convertFrame;
        }
    }
    else {
        CGRect convertFrame = [self.collectionView convertRect:frame toView:self.collectionView];
        GTLGradientView *gtlGradientView = [self gtlGradientView:convertFrame.origin];
        [self.collectionView insertSubview:gtlGradientView atIndex:0];
        self.gradientViewInfos[key] = @{ @"view":gtlGradientView };
    }
}

#pragma mark - life cycle

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self) {
        [self setupInitValues];
        [self setupCollectionViews];
    }
}

@end
