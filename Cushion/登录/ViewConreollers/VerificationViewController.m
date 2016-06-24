//
//  VerificationViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/23.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "VerificationViewController.h"


@interface VerificationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@end

@implementation VerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.phoneNum.text = self.phomeN;
    
    NSLog(@"%@",self.phoneNum.text);
    
}

- (IBAction)clickBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)clickLastBtn:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}
@end
