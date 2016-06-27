//
//  ThatDayCell.m
//  Cushion
//
//  Created by QUAN on 16/6/27.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "ThatDayCell.h"
#import "DACircularProgressView.h"
#import "DALabeledCircularProgressView.h"

#define TIMER_DURATION 5
#define AQI_FULL 24

@interface ThatDayCell (){
    DACircularProgressView *progressView;
    DALabeledCircularProgressView *labeledProgressView;
    int start;
    int aqi;
}
@property (nonatomic,retain )NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *thatDayView;

@end

@implementation ThatDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setProgressView];
}

#pragma mark - 进度条
-(void)setProgressView{
    
    aqi=7;
    //初始化进度条视图
    progressView = [[DACircularProgressView alloc] initWithFrame:_thatDayView.bounds];
    //    progressView.roundedCorners = YES;
    //设置颜色
    progressView.trackTintColor = RGBA(232, 234, 234, 1);
    progressView.progressTintColor= RGBA(0, 175, 255, 1);
    
    progressView.thicknessRatio = 0.2;
    
    //设置进度
    [progressView setProgress:(CGFloat)aqi/AQI_FULL animated:YES initialDelay:0.5];
    
    labeledProgressView= [[DALabeledCircularProgressView alloc] initWithFrame:_thatDayView.bounds];
    labeledProgressView.backgroundColor = [UIColor clearColor];
    labeledProgressView.label.text = @"当日累计久坐";
    labeledProgressView.progressLabel.textColor=[UIColor blackColor];
    [self.thatDayView addSubview:labeledProgressView];
    [self.thatDayView addSubview:progressView];
    
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
    labeledProgressView.progressLabel.font = [UIFont systemFontOfSize:37];
    if (start >= aqi) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
