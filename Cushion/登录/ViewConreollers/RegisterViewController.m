//
//  RegisterViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/23.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "RegisterViewController.h"
#import "VerificationViewController.h"

@interface RegisterViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)clickBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)clickRegisterBtn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认手机号码" message:[NSString stringWithFormat:@"我们将发送验证码短信到这个号码:\n%@",self.phoneNum.text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            
            VerificationViewController *verifVC = [[VerificationViewController alloc] init];
            
            verifVC.phomeN = self.phoneNum.text;
            
            [self.navigationController pushViewController:verifVC animated:YES];
        }
            break;
        case 1:
            
            break;
            
        default:
            break;
    }
    
    
}


@end
