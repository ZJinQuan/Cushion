//
//  SetUpViewController.m
//  Cushion
//
//  Created by QUAN on 16/7/5.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "SetUpViewController.h"
#import "SetupCell.h"
#import "ConnectViewController.h"

@interface SetUpViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *setupTableView;

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_setupTableView registerNib:[UINib nibWithNibName:@"SetupCell" bundle:nil] forCellReuseIdentifier:@"setupCell"];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    btn.layer.cornerRadius = 10;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.center = view.center;
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [view addSubview:btn];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"setupCell";
    
    SetupCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *titleArr = @[@"修改登录密码", @"编辑提示声音", @"优垫蓝牙配对"];
    
    cell.titileLab.text = titleArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        
        ConnectViewController *conectVC = [[ConnectViewController alloc] init];
        
        conectVC.title = @"设备列表";
        
        [self.navigationController pushViewController:conectVC animated:YES];
    }
    
}

@end
