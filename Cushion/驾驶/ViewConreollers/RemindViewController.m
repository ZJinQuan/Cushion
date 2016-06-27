//
//  RemindViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/24.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "RemindViewController.h"
#import "CumulativeCell.h"
#import "WarnedCell.h"
#import "SettingCell.h"

@interface RemindViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *remindTableView;

@end

@implementation RemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //移除手势
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    [_remindTableView registerNib:[UINib nibWithNibName:@"CumulativeCell" bundle:nil] forCellReuseIdentifier:@"cumulativeCell"];
    [_remindTableView registerNib:[UINib nibWithNibName:@"WarnedCell" bundle:nil] forCellReuseIdentifier:@"warnedCell"];
    [_remindTableView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellReuseIdentifier:@"settingCell"];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 3) {
        return 20;
    }
    
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 3) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.text = @" 当日安全驾驶提醒记录";
        label.font = [UIFont systemFontOfSize:14];
        return label;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        return 30;
    }
    
    return 180;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 3) {
        return 6;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            
            CumulativeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cumulativeCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            break;
        case 3:{
            
            WarnedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"warnedCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    if (indexPath.section == 1) {
        cell.backgroundColor = RGBA(101, 219, 204, 1);
    }
    
    return cell;
}
@end
