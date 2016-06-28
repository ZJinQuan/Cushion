//
//  ChartCell.m
//  Cushion
//
//  Created by QUAN on 16/6/28.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "ChartCell.h"
#import "XSChart.h"

@implementation ChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _chart = [[XSChart alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth - 10, _chartView.height)];
    
    _chart.backgroundColor = [UIColor clearColor];

    [self.chartView addSubview:_chart];
}

@end
