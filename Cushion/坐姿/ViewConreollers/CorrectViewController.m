//
//  CorrectViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/24.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "CorrectViewController.h"
#import "DACircularProgressView.h"
#import "DALabeledCircularProgressView.h"
#import "XSChart.h"

#define TIMER_DURATION 5
#define AQI_FULL 100

@interface CorrectViewController ()<XSChartDataSource,XSChartDelegate>{
    DACircularProgressView *progressView;
    DALabeledCircularProgressView *labeledProgressView;
    int start;
    int aqi;
}
@property (nonatomic,retain )NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *CorrView;

@property(nonatomic,strong)NSArray *data;

@end

@implementation CorrectViewController

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    _data=@[@1,@2,@3,@4,@9,@6,@12];
    XSChart *chart=[[XSChart alloc]initWithFrame:CGRectMake(0, 0, _CorrView.width, 250)];
    
    chart.backgroundColor = [UIColor clearColor];
    
    chart.dataSource=self;
    chart.delegate=self;
    [self.CorrView addSubview:chart];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    
    
    
    [self setProgressView];
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
    return @"Index";
}
-(NSString *)titleForYAtChart:(XSChart *)chart
{
    return @"count";
}
-(void)chart:(XSChart *)view didClickPointAtIndex:(NSInteger)index
{
    NSLog(@"click at index:%ld",(long)index);
}


#pragma mark - 进度条
-(void)setProgressView{
    
    aqi=80;
    //初始化进度条视图
    progressView = [[DACircularProgressView alloc] initWithFrame:_topView.bounds];
//    progressView.roundedCorners = YES;
    //设置颜色
    progressView.trackTintColor = RGBA(232, 234, 234, 1);
    progressView.progressTintColor= RGBA(0, 175, 255, 1);
    
    progressView.thicknessRatio = 0.2;
    
    //设置进度
    [progressView setProgress:(CGFloat)aqi/AQI_FULL animated:YES initialDelay:0.5];
    
    labeledProgressView= [[DALabeledCircularProgressView alloc] initWithFrame:_topView.bounds];
    labeledProgressView.label.text = @"正常坐姿占比";
    labeledProgressView.progressLabel.textColor=[UIColor blackColor];
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
    
    labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%d%%", aqi];
    labeledProgressView.progressLabel.font = [UIFont systemFontOfSize:50];
    if (start >= aqi) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
