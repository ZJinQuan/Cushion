//
//  ChartCell.h
//  Cushion
//
//  Created by QUAN on 16/6/28.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSChart.h"

@interface ChartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *chartView;

@property(nonatomic,strong) NSArray *data;

@property (nonatomic, strong) XSChart *chart;

@end
