//
//  LeftViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/22.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()
@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view1.layer.borderWidth = 2;
//    self.view1.layer.cornerRadius = 5;
    self.view1.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.view1.layer.masksToBounds = YES;
    
    [self.btn addTarget:self action:@selector(clickSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)clickSettingBtn:(UIButton *)sender {
    
    
    
}

@end
