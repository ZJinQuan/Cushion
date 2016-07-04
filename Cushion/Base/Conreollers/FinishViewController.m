//
//  FinishViewController.m
//  Cushion
//
//  Created by QUAN on 16/7/1.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "FinishViewController.h"

@interface FinishViewController ()

@end

@implementation FinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //启动一个定时任务
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerTask) userInfo:nil repeats:NO];
    
}

-(void)timerTask{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
