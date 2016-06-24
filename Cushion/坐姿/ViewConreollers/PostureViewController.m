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
#import "PostureCell.h"

#define TIMER_DURATION 5
#define AQI_FULL 100

@interface PostureViewController ()<ScrollImageDelegate, UITableViewDelegate, UITableViewDataSource>{
    DACircularProgressView *progressView;
    DALabeledCircularProgressView *labeledProgressView;
    int start;
    int aqi;
}
@property (weak, nonatomic) IBOutlet UIView *jindu;
@property (nonatomic,retain )NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *topImageView;

@property (nonatomic, strong) ScrollImage *scrollImage;
@property (weak, nonatomic) IBOutlet UITableView *postureTable;

@end

@implementation PostureViewController

-(ScrollImage *)scrollImage{
    
    if (_scrollImage == nil) {
        
        NSArray *imageArr = @[@"home_bg", @"bg_drive_warn", @"bg_nav"];
        _scrollImage = [[ScrollImage alloc] initWithCurrentController:self imageNames:imageArr viewFrame:self.topImageView.bounds placeholderImage:[UIImage imageNamed:@""]];
        _scrollImage.pageControl.currentPageIndicatorTintColor = RGBA(1, 195, 169, 1);
        _scrollImage.delegate = self;
        _scrollImage.timeInterval = 2.0;
        
    }
    return _scrollImage;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //图片轮播器
    [self.topImageView addSubview:self.scrollImage.view];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.postureTable registerNib:[UINib nibWithNibName:@"PostureCell" bundle:nil] forCellReuseIdentifier:@"postureCell"];
    
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"postureCell";
    
    PostureCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *iconArr = @[@"btn1",@"btn2",@"btn3"];
    NSArray *titleArr = @[@"坐姿纠正",@"久坐计时",@"体重监测"];
    NSArray *colorArr = @[RGBA(101, 219, 204, 1),RGBA(255, 169, 34, 1),RGBA(10, 218, 164, 1)];
    
    cell.iconImage.image = [UIImage imageNamed:iconArr[indexPath.section]];
    cell.titleLab.text = titleArr[indexPath.section];
    cell.backgroundColor = colorArr[indexPath.section];
    
    return cell;
}


/*
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

- (void)startAnimation{
    
    self.timer= [NSTimer scheduledTimerWithTimeInterval:(CGFloat)TIMER_DURATION/aqi
                                                 target:self
                                               selector:@selector(progressChange)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)progressChange{
    
    labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%d", aqi];
    if (start >= aqi) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
 */
@end
