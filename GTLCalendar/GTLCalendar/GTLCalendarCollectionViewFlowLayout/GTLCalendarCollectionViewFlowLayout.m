//
//  GTLCalendarCollectionViewFlowLayout.m
//  GTLCalendar
//
//  Created by daisuke on 2017/5/23.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "GTLCalendarCollectionViewFlowLayout.h"

@interface GTLCalendarCollectionViewFlowLayout ()

@property (assign, nonatomic) CGFloat height;

@end

@implementation GTLCalendarCollectionViewFlowLayout

#pragma mark - method to override

- (void)prepareLayout {
    [super prepareLayout];
    NSInteger rowCount = 0;
    NSInteger lineSpacingCount = 0;
    for (NSNumber *rows in self.sectionRows) {
        rowCount += ceil(rows.floatValue / 7.0);
        lineSpacingCount += ceil(rows.floatValue / 7.0) - 1;
    }
    
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    self.height = (rowCount * 30) + (numberOfSections * 50) + (self.minimumLineSpacing * lineSpacingCount);
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    [super setSectionInset:sectionInset];
    self.minimumInteritemSpacing = sectionInset.left;
}

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 12;
        self.headerReferenceSize = CGSizeMake(50, 50);
    }
    return self;
}

- (CGSize)collectionViewContentSize {
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
    return CGSizeMake(collectionViewWidth, self.height);
}

@end
