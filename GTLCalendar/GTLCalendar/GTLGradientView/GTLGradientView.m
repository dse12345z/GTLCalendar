//
//  GTLGradientView.m
//  GTLCalendar
//
//  Created by daisuke on 2017/5/26.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "GTLGradientView.h"

#define squashColor [UIColor colorWithRed:245.0/255.0 green:162.0/255.0 blue:27.0/255.0 alpha:0.7]
#define dustyOrangeColor [UIColor colorWithRed:233.0/255.0 green:97.0/255.0 blue:75.0/255.0 alpha:0.7]

@interface GTLGradientView ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation GTLGradientView

#pragma mark - private instance method

#pragma mark * init values

- (void)setupInitValues {
    // 漸層
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.startPoint = CGPointMake(0, .5);      // 水平漸層
    self.gradientLayer.endPoint = CGPointMake(1, .5);        // 水平漸層
    self.gradientLayer.colors = @[(id)squashColor.CGColor, (id)dustyOrangeColor.CGColor];
    [self.layer insertSublayer:self.gradientLayer atIndex:0];

}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInitValues];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupInitValues];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

@end
