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
#import "AwakenViewController.h"
#import "RemindViewController.h"

@interface DriveViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *driveTable;

@end

@implementation DriveViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //添加手势通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addGestures" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.driveTable registerNib:[UINib nibWithNibName:@"DriveCell" bundle:nil] forCellReuseIdentifier:@"driveCell"];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeft)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRight)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            
            AwakenViewController *awkenVC = [[AwakenViewController alloc] init];
            
            awkenVC.title = @"瞌睡唤醒";
            [awkenVC setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:awkenVC animated:YES];
        }
            break;
        case 1:{
            
            RemindViewController *remindVC = [[RemindViewController alloc] init];
            
            remindVC.title = @"安全驾驶提醒";
            [remindVC setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:remindVC animated:YES];
        }
            break;
        case 3:{
            
        }
            break;
            
        default:
            break;
    }
    
}

-(void) clickLeft{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showViewAnima" object:nil];
    
}

-(void) clickRight{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showViewAnima" object:@"showViewAnima"];
}

@end
