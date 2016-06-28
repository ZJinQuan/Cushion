//
//  PostureViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "PostureViewController.h"
#import "ScrollImage.h"
#import "PostureCell.h"
#import "CorrectViewController.h"
#import "SedentaryViewController.h"
#import "WeightViewController.h"

#define TIMER_DURATION 5
#define AQI_FULL 100

@interface PostureViewController ()<ScrollImageDelegate, UITableViewDelegate, UITableViewDataSource>

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
    
    //添加手势通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addGestures" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.postureTable registerNib:[UINib nibWithNibName:@"PostureCell" bundle:nil] forCellReuseIdentifier:@"postureCell"];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeft)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRight)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            
            CorrectViewController *correctVC = [[CorrectViewController alloc] init];
            
            correctVC.title = @"坐姿纠正";
            [correctVC setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:correctVC animated:YES];
        }
            break;
        case 1:{
            
            SedentaryViewController *sendenteryVC = [[SedentaryViewController alloc] init];
            
            sendenteryVC.title = @"久坐计时";
            [sendenteryVC setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:sendenteryVC animated:YES];
        }
            break;
        case 2:{
            
            WeightViewController *weightVC = [[WeightViewController alloc] init];
            
            weightVC.title = @"体重监测";
            [weightVC setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:weightVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
}

-(void) clickLeft{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showViewAnima" object:nil];
    
}

-(void) clickRight{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showViewAnima" object:@"showViewAnima"];
}

@end
