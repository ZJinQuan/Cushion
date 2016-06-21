//
//  TabBarViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "TabBarViewController.h"
#import "PostureViewController.h"
#import "DriveViewController.h"
#import "FriendsViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barTintColor = RGBA(1, 195, 169, 1);
    
    [self addChildViewController:[[PostureViewController alloc] init] andTitle:@"坐姿" andImageName:@"" addSeledImage:@""];
    [self addChildViewController:[[PostureViewController alloc] init] andTitle:@"驾驶" andImageName:@"" addSeledImage:@""];
    [self addChildViewController:[[PostureViewController alloc] init] andTitle:@"优陌圈" andImageName:@"" addSeledImage:@""];
}


-(void) addChildViewController: (UIViewController *)childController andTitle:(NSString *)title andImageName: (NSString *)image addSeledImage:(NSString *)selectImage{
    
    childController.title = title;
    
    [childController.tabBarItem setImage:[UIImage imageNamed:image]];
    [childController.tabBarItem setSelectedImage:[UIImage imageNamed:selectImage]];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:childController];
    
    [self addChildViewController:navVC];
}

@end
