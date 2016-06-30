//
//  TopScollCell.m
//  Cushion
//
//  Created by QUAN on 16/6/28.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "TopScollCell.h"

@interface TopScollCell ()

@end

@implementation TopScollCell

-(ScrollImage *)scrollImage{
    
    if (_scrollImage == nil) {
        
        NSArray *imageArr = @[@"home_bg", @"bg_drive_warn", @"bg_nav"];
        _scrollImage = [[ScrollImage alloc] initWithCurrentController:_PostureVC imageNames:imageArr viewFrame:CGRectMake(0, 0, kScreenWidth, 155) placeholderImage:[UIImage imageNamed:@""]];
        _scrollImage.pageControl.currentPageIndicatorTintColor = RGBA(1, 195, 169, 1);
        _scrollImage.delegate = self.delegate;
        _scrollImage.timeInterval = 2.0;
        
    }
    return _scrollImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.scollView addSubview:self.scrollImage.view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
