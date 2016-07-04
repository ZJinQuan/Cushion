//
//  PostureViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "PostureViewController.h"
#import "PostureCell.h"
#import "CorrectViewController.h"
#import "SedentaryViewController.h"
#import "WeightViewController.h"
#import "TopScollCell.h"
#import "ConnectViewController.h"

#define TIMER_DURATION 5
#define AQI_FULL 100

@interface PostureViewController ()<ScrollImageDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topImageView;


@property (weak, nonatomic) IBOutlet UITableView *postureTable;

@end

@implementation PostureViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //添加手势通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addGestures" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.postureTable registerNib:[UINib nibWithNibName:@"PostureCell" bundle:nil] forCellReuseIdentifier:@"postureCell"];
    [self.postureTable registerNib:[UINib nibWithNibName:@"TopScollCell" bundle:nil] forCellReuseIdentifier:@"topScollCell"];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeft)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRight)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
 
    [self connectBlue];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBlue) name:@"connectBlue" object:nil];
    
}

-(void) connectBlue{
    
    ConnectViewController *connectVC = [[ConnectViewController alloc] init];
    [connectVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:connectVC animated:YES];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return 40;
    }
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 80, 20)];
        
        lab.text = @"坐姿数据";
        
        lab.textColor = RGBA(1, 195, 169, 1);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, kScreenWidth, 2)];
        
        lab2.backgroundColor = RGBA(1, 195, 169, 1);
        
        [view addSubview:lab];
        [view addSubview:lab2];
        
        return view;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 155;
    }
    
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        TopScollCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topScollCell"];
        
        cell.delegate= self;
        cell.PostureVC = self;
        
        return cell;
    }
    
    PostureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postureCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *iconArr = @[@"btn1",@"btn2",@"btn3"];
    NSArray *titleArr = @[@"坐姿纠正",@"久坐计时",@"体重监测"];
    NSArray *colorArr = @[RGBA(101, 219, 204, 1),RGBA(255, 169, 34, 1),RGBA(10, 218, 164, 1)];
    
    cell.iconImage.image = [UIImage imageNamed:iconArr[indexPath.section - 1]];
    cell.titleLab.text = titleArr[indexPath.section - 1];
    cell.backView.backgroundColor = colorArr[indexPath.section - 1];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 1:{
            
            CorrectViewController *correctVC = [[CorrectViewController alloc] init];
            
            correctVC.title = @"坐姿纠正";
            [correctVC setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:correctVC animated:YES];
        }
            break;
        case 2:{
            
            SedentaryViewController *sendenteryVC = [[SedentaryViewController alloc] init];
            
            sendenteryVC.title = @"久坐计时";
            [sendenteryVC setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:sendenteryVC animated:YES];
        }
            break;
        case 3:{
            
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
