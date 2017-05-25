//
//  GTLCalendarCell.h
//  GTLCalendar
//
//  Created by daisuke on 2017/5/24.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShapeLayerType) {
    ShapeLayerTypeNon,
    ShapeLayerTypeLeft,
    ShapeLayerTypeCenter,
    ShapeLayerTypeRight
};

@interface GTLCalendarCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (assign, nonatomic) ShapeLayerType shapeLayerType;

@end
