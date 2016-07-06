//
//  SystemViewController.m
//  Cushion
//
//  Created by QUAN on 16/7/5.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "SystemViewController.h"

@interface SystemViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *systemTableVIew;

@end

@implementation SystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [_systemTableVIew registerClass:[UITableViewCell class] forCellReuseIdentifier:@"systemCell"];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"systemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"优陌儿公司成功挂牌上市优陌儿公司成功挂牌上市优陌儿公司成功挂牌上市优陌儿公司成功挂牌上市优陌儿公司成功挂牌上市优陌儿公司成功挂牌上市优陌儿公司成功挂牌上市优陌儿公司成功挂牌上市";
    
    
    return cell;
}


@end
