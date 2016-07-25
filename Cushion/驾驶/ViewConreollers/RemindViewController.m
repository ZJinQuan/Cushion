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
#import "ChartCell.h"

@interface RemindViewController ()<UITableViewDelegate, UITableViewDataSource,XSChartDataSource,XSChartDelegate>
@property (weak, nonatomic) IBOutlet UITableView *remindTableView;

@property(nonatomic,strong)NSArray *data;

@property (nonatomic, strong) AppDelegate *app;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@end

@implementation RemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _app = kAppDelegate;
    
    _timeLab.text = _app.currentTime;
    //移除手势
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    _data=@[@1,@12,@3,@4,@9,@6,@2];
    
    [_remindTableView registerNib:[UINib nibWithNibName:@"CumulativeCell" bundle:nil] forCellReuseIdentifier:@"cumulativeCell"];
    [_remindTableView registerNib:[UINib nibWithNibName:@"WarnedCell" bundle:nil] forCellReuseIdentifier:@"warnedCell"];
    [_remindTableView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellReuseIdentifier:@"settingCell"];
    [_remindTableView registerNib:[UINib nibWithNibName:@"ChartCell" bundle:nil] forCellReuseIdentifier:@"chartCell"];
}

#pragma mark XSChartDataSource and XSChartDelegate

-(NSInteger)numberForChart:(XSChart *)chart
{
    return _data.count;
}
-(NSInteger)chart:(XSChart *)chart valueAtIndex:(NSInteger)index
{
    return [_data[index] floatValue];
}
-(BOOL)showDataAtPointForChart:(XSChart *)chart
{
    return YES;
}
-(NSString *)chart:(XSChart *)chart titleForXLabelAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%ld",(long)index];
}
-(NSString *)titleForChart:(XSChart *)chart
{
    return @"正常坐姿占比曲线图";
}
-(NSString *)titleForXAtChart:(XSChart *)chart
{
    return nil;
}
-(NSString *)titleForYAtChart:(XSChart *)chart
{
    return nil;
}
-(void)chart:(XSChart *)view didClickPointAtIndex:(NSInteger)index
{
    NSLog(@"click at index:%ld",(long)index);
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
    
    if (indexPath.section == 2) {
        return 200;
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
            
            SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }
            break;
        case 2:{
            
            ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chartCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.chart.dataSource = self;
            cell.chart.delegate = self;
            
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
    
    return nil;
}
@end
