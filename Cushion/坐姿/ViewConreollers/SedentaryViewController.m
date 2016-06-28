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

@interface SedentaryViewController ()<UITableViewDelegate, UITableViewDataSource,XSChartDataSource,XSChartDelegate>{
    DACircularProgressView *progressView;
    DALabeledCircularProgressView *labeledProgressView;
    int start;
    int aqi;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *bottonTableView;

@property (nonatomic,retain )NSTimer *timer;

@property(nonatomic,strong)NSArray *data;

@end

@implementation SedentaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _data=@[@1,@6,@3,@4,@9,@6,@12];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    [self setProgressView];
    
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
        
        lab.text = @"2016年6月1日";
        
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


#pragma mark - 进度条
-(void)setProgressView{
    
    aqi = 7;
    //初始化进度条视图
    progressView = [[DACircularProgressView alloc] initWithFrame:_topView.bounds];
    //    progressView.roundedCorners = YES;
    //设置颜色
    progressView.trackTintColor = RGBA(232, 234, 234, 1);
    progressView.progressTintColor= RGBA(242, 163, 42, 1);
    
    progressView.thicknessRatio = 0.2;
    
    //设置进度
    [progressView setProgress:(CGFloat)aqi/AQI_FULL animated:YES initialDelay:0.5];
    
    labeledProgressView= [[DALabeledCircularProgressView alloc] initWithFrame:_topView.bounds];
    labeledProgressView.progressLabel.textColor=[UIColor blackColor];
    labeledProgressView.label.text = @"当日累计久坐";
    [self.topView addSubview:labeledProgressView];
    [self.topView addSubview:progressView];
    
    [self startAnimation];
    
}

- (void)startAnimation{
    
    self.timer= [NSTimer scheduledTimerWithTimeInterval:(CGFloat)TIMER_DURATION/aqi
                                                 target:self
                                               selector:@selector(progressChange)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)progressChange{
    
    labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%d小时", aqi];
    labeledProgressView.progressLabel.font = [UIFont systemFontOfSize:45];
    if (start >= aqi) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
