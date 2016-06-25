//
//  CircleView.m
//  空瀞
//
//  Created by femtoapp's macbook pro  on 15/8/24.
//  Copyright (c) 2015年 WL. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        [self updateView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 30)];
        label.font = [UIFont systemFontOfSize:15];
        label.centerX = _centerView.centerX - 20;
        label.text = @"本周体重波动";
        label.textAlignment = NSTextAlignmentCenter;
        
        _weightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, 80, 50)];
        _weightLab.text = @"+2KG";
        _weightLab.textAlignment = NSTextAlignmentCenter;
        _weightLab.font = [UIFont systemFontOfSize:30];
        _weightLab.centerX = _centerView.centerX -20;
        
        [_centerView addSubview:label];
        [_centerView addSubview:_weightLab];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateView];
}
-(void)createView
{
    self.clipsToBounds = YES;
    _dataView = [[UIView alloc] init];
    [self addSubview:_dataView];
    _defaultView = [[UIView alloc] init];
    [self addSubview:_defaultView];
    _centerView  = [[UIView alloc] init];
    [self addSubview:_centerView];
    _centerView.clipsToBounds = YES;
    _startAngle = 3.15;
    _percentage = 0.5;
    _arcWidth = 20;
    
    
    
}

-(void)setPercentage:(CGFloat)percentage
{
    if (percentage < 0) {
        percentage = 0;
    }
    if (percentage > 1) {
        percentage = 1;
    }
    _percentage = percentage;
    [self updateView];
}

-(void)updateView
{
    
    self.layer.cornerRadius = self.bounds.size.width/2;
    CGRect centerFrame = self.bounds;
    centerFrame.origin.x = _arcWidth;
    centerFrame.origin.y = _arcWidth;
    centerFrame.size.height = centerFrame.size.height - _arcWidth * 2;
    centerFrame.size.width = centerFrame.size.width - _arcWidth * 2;
    _centerView.frame = centerFrame;
    _centerView.layer.cornerRadius = centerFrame.size.width/2;
    
    _dataView.frame = self.bounds;
    _defaultView.frame = self.bounds;
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [path moveToPoint:_defaultView.center];
    [path addArcWithCenter: _defaultView.center radius:_defaultView.frame.size.width/2 startAngle:_startAngle endAngle:-2*M_PI*(1-_percentage) + _startAngle clockwise:NO];
    [path addLineToPoint:_defaultView.center];
    CAShapeLayer* shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    _defaultView.layer.mask = shape;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
