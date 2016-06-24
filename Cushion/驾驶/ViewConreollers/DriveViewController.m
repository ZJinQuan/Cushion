//
//  DriveViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "DriveViewController.h"
#import "CircleView.h"
#import "DriveCell.h"

@interface DriveViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *driveTable;

@end

@implementation DriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.driveTable registerNib:[UINib nibWithNibName:@"DriveCell" bundle:nil] forCellReuseIdentifier:@"driveCell"];
    
    
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"driveCell";
    
    DriveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *backArr = @[@"bg_sleep_warn", @"bg_drive_warn",@"bg_nav"];
    NSArray *iconArr = @[@"icon_sleep_warn", @"icon_drive_warn", @"icon_nav"];
    NSArray *titleArr = @[@"瞌睡唤醒", @"安全驾驶提醒", @"导航"];
    
    cell.backImage.image = [UIImage imageNamed:backArr[indexPath.section]];
    cell.iconImage.image = [UIImage imageNamed:iconArr[indexPath.section]];
    cell.titleLab.text = titleArr[indexPath.section];
    
    return cell;
}


@end
