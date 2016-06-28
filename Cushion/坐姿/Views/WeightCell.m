//
//  WeightCell.m
//  Cushion
//
//  Created by QUAN on 16/6/28.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "WeightCell.h"
#import "CircleView.h"

@interface WeightCell ()

@property (nonatomic, strong) CircleView *circle;

@property (weak, nonatomic) IBOutlet UIView *circlView;
@end

@implementation WeightCell

-(CircleView *)circle{
    
    if (_circle == nil) {
        
        _circle = [[CircleView alloc] initWithFrame:_circlView.bounds];
        
        _circle.centerView.backgroundColor = [UIColor whiteColor];
        _circle.dataView.backgroundColor = RGBA(0, 233, 253, 1);
        _circle.defaultView.backgroundColor = RGBA(232, 234, 234, 1);
        _circle.percentage = 0.2;
        _circle.arcWidth = 20;
    }
    return _circle;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    CircleView *circle = [[CircleView alloc] initWithFrame:_circlView.bounds];
//    circle.centerView.backgroundColor = [UIColor whiteColor];
//    circle.dataView.backgroundColor = RGBA(0, 233, 253, 1);
//    circle.defaultView.backgroundColor = RGBA(232, 234, 234, 1);
//    circle.percentage = 0.2;
//    circle.arcWidth = 20;
    //    circle.startAngle = 0.2;
    [self.circlView addSubview:self.circle];
}



@end
