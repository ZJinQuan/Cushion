//
//  WhoShockViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/27.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "WhoShockViewController.h"
#import "ShockCell.h"

@interface WhoShockViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *shockView;

@end

@implementation WhoShockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_shockView registerNib:[UINib nibWithNibName:@"ShockCell" bundle:nil] forCellReuseIdentifier:@"shockCell"];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ShockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shockCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *iconArr = @[@"bg_photo2", @"bg_my", @"bg_photo2", @"bg_photo3", @"bg_photo4", @"bg_photo2", @"bg_my"];
    NSArray *nameArr = @[@"LIM",@"林涛", @"汉诺", @"张三", @"李四" ,@"王五", @"赵六"];
    
    cell.iconImage.image = [UIImage imageNamed:iconArr[indexPath.row]];
    cell.nameLan.text = nameArr[indexPath.row];
    
    return cell;
}



@end
