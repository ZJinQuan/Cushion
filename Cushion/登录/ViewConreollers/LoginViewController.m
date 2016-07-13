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
#import "HttpTool.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation LoginViewController

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (IBAction)clickLoginBtn:(id)sender {
    
    NSString *url = BaseUrl@"useruserlogin";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_userName.text forKey:@"name"];
    [params setObject:_passWord.text forKey:@"password"];
    [params setValue:@(1) forKey:@"ios"];
    [params setObject:@"" forKey:@"token"];
    
    [[HttpTool sharedManager] POST:url params:params result:^(id responseObj, NSError *error) {
        
        NSDictionary *dict = responseObj;
        
        if ([[dict objectForKey:@"result"] isEqual: @"0"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"name"] forKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"phone"] forKey:@"user_phone"];
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"url"] forKey:@"user_url"];
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"userId"] forKey:@"user_userId"];
//            [[NSUserDefaults standardUserDefaults] setObject:dict[@"userName"] forKey:@"user_userName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];

        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alertView show];
            
        }

    }];
    
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
