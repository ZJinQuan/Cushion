//
//  TopCell.m
//  Cushion
//
//  Created by QUAN on 16/7/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "TopCell.h"

@implementation TopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _topImage.layer.masksToBounds = YES;
    
    _topImage.image = _image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
