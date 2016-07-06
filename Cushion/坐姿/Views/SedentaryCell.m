//
//  SedentaryCell.m
//  Cushion
//
//  Created by QUAN on 16/6/28.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "SedentaryCell.h"
#import "DACircularProgressView.h"
#import "DALabeledCircularProgressView.h"

#define TIMER_DURATION 5
#define AQI_FULL 86400

@interface SedentaryCell (){
    DACircularProgressView *progressView;
    DALabeledCircularProgressView *labeledProgressView;
    int start;
    int aqi;
}

@property (nonatomic,retain )NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *proghressView;
@property (weak, nonatomic) IBOutlet UIButton *sedentLab;
@property (nonatomic, assign) NSInteger *sedent;
@property (nonatomic, strong) AppDelegate *app;

@end

@implementation SedentaryCell

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
    
    [self updataCorrect];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updataCorrect) userInfo:nil repeats:YES];
}

-(void) updataCorrect{
    
    NSLog(@"----%ld", (long)self.app.byte.m);
    
    labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%f小时",(float)self.app.byte.m / 86400];
    
    if (self.app.byte.m == 3600) {
        
        [_sedentLab setTitle:@"1次" forState:UIControlStateNormal];
    }
    
    aqi = (float)self.app.byte.m;
    
    [progressView setProgress:(CGFloat)aqi/AQI_FULL animated:YES initialDelay:0.5];
    
}

#pragma mark - 进度条
-(void)setProgressView{
    
    aqi=0;
    //初始化进度条视图
    progressView = [[DACircularProgressView alloc] initWithFrame:_proghressView.bounds];
    //    progressView.roundedCorners = YES;
    //设置颜色
    progressView.trackTintColor = RGBA(232, 234, 234, 1);
    progressView.progressTintColor= RGBA(0, 175, 255, 1);
    
    progressView.thicknessRatio = 0.2;
    
    //设置进度
    [progressView setProgress:(CGFloat)aqi/AQI_FULL animated:YES initialDelay:0.5];
    
    labeledProgressView= [[DALabeledCircularProgressView alloc] initWithFrame:_proghressView.bounds];
    labeledProgressView.backgroundColor = [UIColor clearColor];
    labeledProgressView.label.text = @"当日累计久坐";
    labeledProgressView.progressLabel.textColor=[UIColor blackColor];
    [_proghressView addSubview:labeledProgressView];
    [_proghressView addSubview:progressView];
    
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
    
//    labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%d小时", aqi];
    labeledProgressView.progressLabel.font = [UIFont systemFontOfSize:15];
    if (start >= aqi) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
