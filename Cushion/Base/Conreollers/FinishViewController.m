//
//  FinishViewController.m
//  Cushion
//
//  Created by QUAN on 16/7/1.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "FinishViewController.h"
#import "PostureViewController.h"

#define channelOnCharacteristicView @"CharacteristicView"

@interface FinishViewController ()

@end

@implementation FinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //启动一个定时任务
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerTask) userInfo:nil repeats:NO];
    
    
    
    //读取服务
//    baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.characteristic);
    
}

-(void)timerTask{
    
//    PostureViewController *postireVC = [[PostureViewController alloc] init];

    for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
        
        NSLog(@"-------%@",self.navigationController.viewControllers[i]);
        
    }
    
    PostureViewController *postireVC = self.navigationController.viewControllers[0];
    
    postireVC->baby = self->baby;
    
    
    [self.navigationController popToViewController:postireVC animated:YES];
    
}

@end
