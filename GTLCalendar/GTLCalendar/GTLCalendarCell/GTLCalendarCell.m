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

@end

@implementation GTLCalendarCell
@synthesize shapeLayerType = _shapeLayerType;

#pragma mark - instance method

#pragma mark * properties

- (void)setShapeLayerType:(ShapeLayerType)shapeLayerType {
    _shapeLayerType = shapeLayerType;
    
    // 做清除動作
    if (self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer  = nil;
    }
    
    switch (shapeLayerType) {
        case ShapeLayerTypeNon:
            break;
            
        case ShapeLayerTypeLeft:
            break;
            
        case ShapeLayerTypeCenter:
            break;
            
        case ShapeLayerTypeRight:
            break;
    }
}

#pragma mark - private instance method

#pragma mark * init values

//- (void)setupShapeLayers {
//    CAShapeLayer *shapeLayer;
//    shapeLayer = [CAShapeLayer layer];
//    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
//    shapeLayer.borderWidth = 1.0;
//    shapeLayer.borderColor = [UIColor clearColor].CGColor;
//    shapeLayer.opacity = 0;
//    [self.contentView.layer insertSublayer:shapeLayer below:self.dayLabel.layer];
//    self.shapeLayer = shapeLayer;
//}

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
