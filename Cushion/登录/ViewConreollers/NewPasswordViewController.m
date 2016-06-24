//
//  NewPasswordViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/23.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "NewPasswordViewController.h"

@interface NewPasswordViewController ()

@end

@implementation NewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)clickWanChengBtn:(id)sender {
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
