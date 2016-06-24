//
//  LoginViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import "TabBarViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (IBAction)clickLoginBtn:(id)sender {
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
    
}
- (IBAction)clickRegister:(id)sender {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)clickorgetPassword:(id)sender {
    
    ForgetViewController *forgetVC = [[ForgetViewController alloc] init];
    
    [self.navigationController pushViewController:forgetVC animated:YES];
}
@end
