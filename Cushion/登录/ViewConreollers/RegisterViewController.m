//
//  RegisterViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/23.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "RegisterViewController.h"
#import "VerificationViewController.h"
#import "HttpTool.h"

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

//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *url = BaseUrl@"usercheckIsName";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_phoneNum.text forKey:@"user.name"];

    
    [[HttpTool sharedManager] GET:url params:params result:^(id responseObj, NSError *error) {
        
        NSLog(@"%@",responseObj);
        
        NSLog(@"%@",[responseObj objectForKey:@"message"]);
        
        if ([[responseObj objectForKey:@"result"] isEqual: @"0"]) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认手机号码" message:[NSString stringWithFormat:@"我们将发送验证码短信到这个号码:\n%@",self.phoneNum.text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            
            alertView.tag = 000;
            
            [alertView show];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[responseObj objectForKey:@"message"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            alertView.tag = 111;
            
            [alertView show];
            
        }
        
    }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    switch (alertView.tag) {
        case 000:{
         
            if (buttonIndex == 0) {
                
                VerificationViewController *verifVC = [[VerificationViewController alloc] init];
                
                verifVC.phomeN = self.phoneNum.text;
                
                [self.navigationController pushViewController:verifVC animated:YES];
            }
        }
            break;
        case 111:{
            
            
            
        }
            break;
        default:
            break;
    }
    
}


@end
