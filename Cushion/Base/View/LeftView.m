//
//  LeftView.m
//  Cushion
//
//  Created by QUAN on 16/6/30.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "LeftView.h"

@interface LeftView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIView *mesgView;

@end

@implementation LeftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"LeftView" owner:self options:nil] lastObject];
        
        self.frame = frame;
        
        self.mesgView.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }
    return self;
}

- (IBAction)clickSettingBtn:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 100:{
            
        }
            break;
        case 200:{
            
        }
            break;
        case 300:{
            
        }
            break;
        case 400:{
            
        }
            break;
            
        default:
            break;
    }
    
}

@end
