//
//  PostureViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "PostureViewController.h"
#import "DACircularProgressView.h"
#import "DALabeledCircularProgressView.h"
#import "ScrollImage.h"

#define TIMER_DURATION 5
#define AQI_FULL 100

@interface PostureViewController ()<ScrollImageDelegate>{
    DACircularProgressView *progressView;
    DALabeledCircularProgressView *labeledProgressView;
    int start;
    int aqi;
}
@property (weak, nonatomic) IBOutlet UIView *jindu;
@property (nonatomic,retain )NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *topImageView;
@end

@implementation PostureViewController

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self setProgressView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageArr = @[@"bg_drive_monit", @"bg_drive_warn", @"bg_nav"];

    ScrollImage *scrl = [[ScrollImage alloc] initWithCurrentController:self imageNames:imageArr viewFrame:self.topImageView.bounds placeholderImage:[UIImage imageNamed:@""]];
    
//    scrl.pageControl.pageIndicatorTintColor = RGBA(110, 110, 110, 1);
    scrl.pageControl.currentPageIndicatorTintColor = RGBA(1, 195, 169, 1);
    
    scrl.delegate = self;
    scrl.timeInterval = 2.0;
    
    
    [self.topImageView addSubview:scrl.view];
    
}

#pragma mark - 进度条
-(void)setProgressView{

    aqi=20;
    //初始化进度条视图
    progressView = [[DACircularProgressView alloc] initWithFrame:_jindu.bounds];
    progressView.roundedCorners = YES;
    //设置颜色
    progressView.trackTintColor = [UIColor whiteColor];
    progressView.progressTintColor=[UIColor greenColor];
    //设置进度
    [progressView setProgress:(CGFloat)aqi/AQI_FULL animated:YES initialDelay:0.5];
    
    
    labeledProgressView= [[DALabeledCircularProgressView alloc]
                          initWithFrame:_jindu.bounds];
    labeledProgressView.progressLabel.textColor=[UIColor blueColor];
    [self.jindu addSubview:labeledProgressView];
    [self.jindu addSubview:progressView];
    
    [self startAnimation];
    
    
}

- (void)startAnimation
{
    self.timer= [NSTimer scheduledTimerWithTimeInterval:(CGFloat)TIMER_DURATION/aqi
                                                 target:self
                                               selector:@selector(progressChange)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)progressChange
{
    labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%d", aqi];
    if (start >= aqi) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
