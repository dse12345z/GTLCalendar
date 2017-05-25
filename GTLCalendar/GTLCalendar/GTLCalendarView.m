//
//  GTLCalendarView.m
//  GTLCalendar
//
//  Created by daisuke on 2017/5/23.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "GTLCalendarView.h"
#import "GTLCalendarCell.h"
#import "GTLCalendarHeaderReusableView.h"
#import "GTLCalendarCollectionViewFlowLayout.h"
#import "NSCalendar+GTLCategory.h"

#define itemTexTColor [UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1];
#define dayTexTColor [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1];
#define dayOutTexTColor [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:0.3];

@interface GTLCalendarView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *sectionRows;
@property (assign, nonatomic) NSInteger months;

@end

@implementation GTLCalendarView

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sectionRows[section] integerValue];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GTLCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GTLCalendarCell" forIndexPath:indexPath];
    // 依照 section index 計算日期
    NSDate *fromDate = [self.dataSource minimumDateForGTLCalendar];
    NSDate *sectionDate = [NSCalendar date:fromDate addMonth:indexPath.section];
    
    // 包含前一個月天數
    NSInteger sectionDateWeek = [NSCalendar weekFromDate:sectionDate];
    NSInteger containPreDays = (sectionDateWeek == 6) ? 0 : sectionDateWeek;
    
    // 一、二、三 ... 日，7 個項目
    if (indexPath.row < 7) {
        cell.dayLabel.text = [self itemDays][indexPath.row];
        cell.dayLabel.textColor = itemTexTColor;
    }
    else {
        NSInteger shiftIndex = indexPath.row - 7;
        if (shiftIndex >= containPreDays) {
            shiftIndex -= containPreDays;
            cell.dayLabel.text = [NSString stringWithFormat:@"%td", shiftIndex + 1];
            cell.dayLabel.textColor = dayTexTColor;
            
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
        // 計算有幾個月份
        NSDate *fromDate = [self.dataSource minimumDateForGTLCalendar];
        NSDate *sectionDate = [NSCalendar date:fromDate addMonth:indexPath.section];
        
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.months;
}

#pragma mark - private instance method

#pragma mark * init values

- (void)setupInitValues {
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
        NSInteger sectionDateWeek = [NSCalendar weekFromDate:sectionDate];
        NSInteger containPreDays = (sectionDateWeek == 6) ? 0 : sectionDateWeek;
        
        // 包含前一個月天數
        NSInteger weekItems = 7;
        
        [self.sectionRows addObject:@(weekItems + containPreDays + days)];
    }
}

- (void)setupCollectionViews {
    CGFloat calendarWidth = CGRectGetWidth(self.frame);
    CGFloat calendarHeight = CGRectGetHeight(self.frame);
    CGRect frame = CGRectMake(0, 0, calendarWidth, calendarHeight);
    
    CGFloat itemWidth = 30;
    CGFloat collectionViewWidth = CGRectGetWidth(frame);
    CGFloat space = (collectionViewWidth - (7 * itemWidth)) / 8;
    
    GTLCalendarCollectionViewFlowLayout *flowLayout = [[GTLCalendarCollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
    flowLayout.sectionRows = self.sectionRows;

    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[GTLCalendarCell class] forCellWithReuseIdentifier:@"GTLCalendarCell"];
    [self.collectionView registerClass:[GTLCalendarHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GTLCalendarHeaderReusableView"];
    [self addSubview:self.collectionView];
}

#pragma mark * misc

- (NSArray *)itemDays {
    return @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
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
