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

#define TIMER_DURATION 5
#define AQI_FULL 24

@interface SedentaryViewController ()<UITableViewDelegate, UITableViewDataSource>{
    DACircularProgressView *progressView;
    DALabeledCircularProgressView *labeledProgressView;
    int start;
    int aqi;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *bottonTableView;

@property (nonatomic,retain )NSTimer *timer;

@end

@implementation SedentaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    [self setProgressView];
    
    [self.bottonTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.bottonTableView registerNib:[UINib nibWithNibName:@"RemindCell" bundle:nil] forCellReuseIdentifier:@"remindCell"];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.text = @" 当日久坐提醒记录";
        label.font = [UIFont systemFontOfSize:14];
        return label;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 200;
        
    }
    return 20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        
        return 10;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBA(101, 219, 204, 1);
        
        return cell;
    }
    
    RemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remindCell"];
    
    
    return cell;
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
