//
//  GTLCalendarCollectionViewFlowLayout.h
//  GTLCalendar
//
//  Created by daisuke on 2017/5/23.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTLCalendarCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (strong, nonatomic) NSArray *sectionRows;
@property (assign, nonatomic) NSInteger itemWidth;

@end
