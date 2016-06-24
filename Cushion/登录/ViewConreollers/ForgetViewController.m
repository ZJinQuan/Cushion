//
//  ForgetViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/23.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "ForgetViewController.h"
#import "NewPasswordViewController.h"

@interface ForgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)clickBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickNextBtn:(id)sender {
    
    NewPasswordViewController *newVC = [[NewPasswordViewController alloc] init];
    
    [self.navigationController pushViewController:newVC animated:YES];
    
}

@end
