//
//  VerificationViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/23.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "VerificationViewController.h"
#import "HttpTool.h"


@interface VerificationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *codeText;

@end

@implementation VerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.phoneNum.text = self.phomeN;
    
    NSLog(@"%@",self.phoneNum.text);
    
    [self verificationCode];
}

-(void) verificationCode{
    
    NSString *url = BaseUrl@"usersendCode";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.phomeN forKey:@"user.name"];
    
    [[HttpTool sharedManager] POST:url params:params result:^(id responseObj, NSError *error) {
        
    }];
    
}

- (IBAction)clickBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)clickLastBtn:(id)sender {
    
    if (_codeText.text.length == 0) {
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
        
    }else{
        
        /*
         
         http://115.28.77.44/UMat/userregist
         传入值
         doc    图片
         user.ios   int    (1为ios   0为android)
         user.token   String
         user.name    String
         user.passWord  String
         返回结果
         
         result    message      userId
         0    注册成功       user.id
         
         */
        
        NSString *url = BaseUrl@"userregist";
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
//        [params setObject:<#(nonnull id)#> forKey:<#(nonnull id<NSCopying>)#>]
        [params setValue:@(1) forKey:@"user.ios"];
        [params setObject:@"" forKey:@"user.token"];
        [params setObject:self.phomeN forKey:@"user.name"];
        [params setObject:@"" forKey:@"user.passWord"];
        
        [[HttpTool sharedManager] POST:url params:params result:^(id responseObj, NSError *error) {
            
        }];
        
        
       [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
@end
