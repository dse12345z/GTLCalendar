//
//  GTLCalendarCell.m
//  GTLCalendar
//
//  Created by daisuke on 2017/5/24.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "GTLCalendarCell.h"

@interface GTLCalendarCell ()

@property (weak, nonatomic) CAShapeLayer *shapeLayer;
@property (weak, nonatomic) CAShapeLayer *fromDateShapeLayer;
@property (weak, nonatomic) CAShapeLayer *toDateshapeLayer;

@end

@implementation GTLCalendarCell
@synthesize isFromDate = _isFromDate;
@synthesize isToDate = _isToDate;

#pragma mark - instance method

#pragma mark * properties

- (void)setIsFromDate:(BOOL)isFromDate {
    _isFromDate = isFromDate;
    [self.fromDateShapeLayer removeFromSuperlayer];
    self.fromDateShapeLayer = nil;
    
    if (isFromDate) {
        CGRect rect = CGRectMake(0, 0, 30, 30);
        UIRectCorner rectCorner = UIRectCornerAllCorners;
        CGSize cornerRadii = CGSizeMake(15, 15);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner cornerRadii:cornerRadii];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = [UIColor colorWithRed:245.0/255.0 green:162.0/255.0 blue:27.0/255.0 alpha:1].CGColor;
        if (self.shapeLayer) {
            [self.contentView.layer insertSublayer:shapeLayer above:self.shapeLayer];
        }
        else {
            [self.contentView.layer insertSublayer:shapeLayer below:self.dayLabel.layer];
        }
        
        self.fromDateShapeLayer = shapeLayer;
    }
}

- (void)setIsToDate:(BOOL)isToDate {
    _isToDate = isToDate;
    [self.toDateshapeLayer removeFromSuperlayer];
    self.toDateshapeLayer = nil;
    
    if (isToDate) {
        CGRect rect = CGRectMake(0, 0, 30, 30);
        UIRectCorner rectCorner = UIRectCornerAllCorners;
        CGSize cornerRadii = CGSizeMake(15, 15);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner cornerRadii:cornerRadii];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = [UIColor colorWithRed:233.0/255.0 green:97.0/255.0 blue:75.0/255.0 alpha:1].CGColor;
        if (self.shapeLayer) {
            [self.contentView.layer insertSublayer:shapeLayer above:self.shapeLayer];
        }
        else {
            [self.contentView.layer insertSublayer:shapeLayer below:self.dayLabel.layer];
        }
        self.toDateshapeLayer = shapeLayer;
    }
}

#pragma mark * misc

- (UICollectionView *)dependCollectionView {
    UIView *findView = self.superview;
    while (![findView isKindOfClass:[UICollectionView class]]) {
        findView = findView.superview;
    }
    UICollectionView *collectionView = (UICollectionView *)findView;
    return collectionView;
}

- (NSIndexPath *)indexPath {
    return [[self dependCollectionView] indexPathForCell:self];
}

#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = arrayOfViews[0];
    }
    return self;
}

@end
