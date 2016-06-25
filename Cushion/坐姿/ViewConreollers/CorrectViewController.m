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

#define TIMER_DURATION 5
#define AQI_FULL 100

@interface CorrectViewController (){
    DACircularProgressView *progressView;
    DALabeledCircularProgressView *labeledProgressView;
    int start;
    int aqi;
}
@property (nonatomic,retain )NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *topView;


@end

@implementation CorrectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    [self setProgressView];
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
