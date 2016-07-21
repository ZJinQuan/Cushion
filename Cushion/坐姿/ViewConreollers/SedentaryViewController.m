//
//  SedentaryViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/24.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "SedentaryViewController.h"
#import "DACircularProgressView.h"
#import "DALabeledCircularProgressView.h"
#import "RemindCell.h"
#import "ChartCell.h"
#import "XSChart.h"
#import "SedentaryCell.h"

#define TIMER_DURATION 5
#define AQI_FULL 24

@interface SedentaryViewController ()<UITableViewDelegate, UITableViewDataSource,XSChartDataSource,XSChartDelegate>

@property (weak, nonatomic) IBOutlet UITableView *bottonTableView;

@property (nonatomic,retain )NSTimer *timer;

@property(nonatomic,strong)NSArray *data;

@property (nonatomic, strong) AppDelegate *app;

@end

@implementation SedentaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _app = kAppDelegate;
    
    _data=@[@1,@6,@3,@4,@9,@6,@12];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    
    [self.bottonTableView registerNib:[UINib nibWithNibName:@"RemindCell" bundle:nil] forCellReuseIdentifier:@"remindCell"];
    [self.bottonTableView registerNib:[UINib nibWithNibName:@"ChartCell" bundle:nil] forCellReuseIdentifier:@"chartCell"];
    [self.bottonTableView registerNib:[UINib nibWithNibName:@"SedentaryCell" bundle:nil] forCellReuseIdentifier:@"sedentaryCell"];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 30;
    }
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 || section == 0) {
        return 30;
    }
    return 0.1;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        
        lab.textAlignment = NSTextAlignmentCenter;
        
        lab.text = _app.currentTime;
        
        lab.textColor = RGBA(1, 195, 169, 1);
        
        return lab;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.text = @" 当日久坐提醒记录";
        label.font = [UIFont systemFontOfSize:14];
        return label;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 230;
    }
    
    if (indexPath.section == 1) {
        
        return 200;
        
    }
    return 20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 10;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.section) {
        case 0:{
            SedentaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sedentaryCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
        }
            break;
        case 1:{
            ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chartCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.chart.dataSource = self;
            cell.chart.delegate = self;
            
            return cell;
        }
            break;
        case 2:{
            RemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remindCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
    
    
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


@end
