//
//  MyShareCell.m
//  Cushion
//
//  Created by QUAN on 16/7/8.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "MyShareCell.h"

@interface MyShareCell ()

@end

@implementation MyShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickShock:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShockMe" object:nil];
}

@end
