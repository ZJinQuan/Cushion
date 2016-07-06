//
//  CorrectCell.m
//  Cushion
//
//  Created by QUAN on 16/6/28.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "CorrectCell.h"
#import "DACircularProgressView.h"
#import "DALabeledCircularProgressView.h"

#define TIMER_DURATION 5
#define AQI_FULL 24

@interface CorrectCell (){
    DACircularProgressView *progressView;
    DALabeledCircularProgressView *labeledProgressView;
    int start;
    int aqi;
}
@property (weak, nonatomic) IBOutlet UIProgressView *progress1;
@property (weak, nonatomic) IBOutlet UIProgressView *progress2;
@property (weak, nonatomic) IBOutlet UIProgressView *progress3;
@property (weak, nonatomic) IBOutlet UIProgressView *progress4;
@property (weak, nonatomic) IBOutlet UILabel *percentage1;
@property (weak, nonatomic) IBOutlet UILabel *percentage2;
@property (weak, nonatomic) IBOutlet UILabel *percentage3;
@property (weak, nonatomic) IBOutlet UILabel *percentage4;

@property (nonatomic,retain )NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *progView;


@property (nonatomic, strong) AppDelegate *app;
@end

@implementation CorrectCell

-(AppDelegate *)app{
    
    if (_app == nil) {
        
        _app = kAppDelegate;
        
    }
    return _app;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setProgressView];
    
    
//    self.progress.progress =
    
    self.progress1.progressTintColor = [UIColor yellowColor];
    self.progress2.progressTintColor = [UIColor redColor];
    self.progress3.progressTintColor = [UIColor blueColor];
    self.progress4.progressTintColor = [UIColor orangeColor];
    
    [self updataCorrect];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updataCorrect) userInfo:nil repeats:YES];
}


-(void) updataCorrect{
    
    NSLog(@"=======%ld, %ld, %ld, %ld, ----%ld", (long)self.app.byte.v1, (long)self.app.byte.v2, (long)self.app.byte.v3, (long)self.app.byte.v4, (long)self.app.byte.m);
    
    self.progress1.progress = (self.app.byte.m - (float)self.app.byte.v1  * 2)/self.app.byte.m;
    self.progress2.progress = (self.app.byte.m - (float)self.app.byte.v2  * 2)/self.app.byte.m;
    self.progress3.progress = (self.app.byte.m - (float)self.app.byte.v3  * 2)/self.app.byte.m;
    self.progress4.progress = (self.app.byte.m - (float)self.app.byte.v4  * 2)/self.app.byte.m;
    
    float fl = ((float)self.app.byte.v2  * 2)/self.app.byte.m;
    
    NSLog(@"%.2f",fl);
    self.percentage1.text = [NSString stringWithFormat:@"%.0f%%",((float)self.app.byte.v1  * 2)/self.app.byte.m * (float)100];
    self.percentage2.text = [NSString stringWithFormat:@"%.0f%%",((float)self.app.byte.v2  * 2)/self.app.byte.m * (float)100];
    self.percentage3.text = [NSString stringWithFormat:@"%.0f%%",((float)self.app.byte.v3  * 2)/self.app.byte.m * (float)100];
    self.percentage4.text = [NSString stringWithFormat:@"%.0f%%",((float)self.app.byte.v4  * 2)/self.app.byte.m * (float)100];
    
}
#pragma mark - 进度条
-(void)setProgressView{
    
    aqi=7;
    //初始化进度条视图
    progressView = [[DACircularProgressView alloc] initWithFrame:_progView.bounds];
    //    progressView.roundedCorners = YES;
    //设置颜色
    progressView.trackTintColor = RGBA(232, 234, 234, 1);
    progressView.progressTintColor= RGBA(0, 175, 255, 1);
    
    progressView.thicknessRatio = 0.2;
    
    //设置进度
    [progressView setProgress:(CGFloat)aqi/AQI_FULL animated:YES initialDelay:0.5];
    
    labeledProgressView= [[DALabeledCircularProgressView alloc] initWithFrame:_progView.bounds];
    labeledProgressView.backgroundColor = [UIColor clearColor];
    labeledProgressView.label.text = @"正常坐姿占比";
    labeledProgressView.progressLabel.textColor=[UIColor blackColor];
    [_progView addSubview:labeledProgressView];
    [_progView addSubview:progressView];
    
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
    labeledProgressView.progressLabel.font = [UIFont systemFontOfSize:37];
    if (start >= aqi) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
