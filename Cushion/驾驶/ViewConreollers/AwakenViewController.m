//
//  AwakenViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/24.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "AwakenViewController.h"

@interface AwakenViewController ()

@end

@implementation AwakenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
}

@end
