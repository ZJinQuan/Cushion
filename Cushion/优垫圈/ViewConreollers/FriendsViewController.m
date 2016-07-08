//
//  FriendsViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCell.h"
#import "MyViewController.h"
#import "LookAtViewController.h"

@interface FriendsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *friendTableView;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end

@implementation FriendsViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //添加手势通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addGestures" object:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"iconImage.png"]];
    
    if ([UIImage imageWithContentsOfFile:filePath] != nil) {
        _iconImage.image = [UIImage imageWithContentsOfFile:filePath];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.friendTableView registerNib:[UINib nibWithNibName:@"FriendsCell" bundle:nil] forCellReuseIdentifier:@"friendsCell"];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeft)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRight)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTop)];
    
    [self.topView addGestureRecognizer:tap];
    
}

-(void) clickTop{
    
    MyViewController *myVC = [[MyViewController alloc] init];
    
    myVC.title = @"我的优垫";
    
    myVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:myVC animated:YES];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"friendsCell";
    
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    NSArray *iconArr = @[@"bg_photo2", @"bg_my", @"bg_photo2", @"bg_photo3", @"bg_photo4", @"bg_photo2", @"bg_my"];
    NSArray *nameArr = @[@"LIM",@"林涛", @"汉诺", @"张三", @"李四" ,@"王五", @"赵六"];
    
    cell.rankingLab.text = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    cell.iconImage.image = [UIImage imageNamed:iconArr[indexPath.row]];
    cell.nameLab.text = nameArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *iconArr = @[@"bg_photo2", @"bg_my", @"bg_photo2", @"bg_photo3", @"bg_photo4", @"bg_photo2", @"bg_my"];
    NSArray *nameArr = @[@"LIM",@"林涛", @"汉诺", @"张三", @"李四" ,@"王五", @"赵六"];
    
    LookAtViewController *lookVC = [[LookAtViewController alloc] init];
    
    lookVC.iconStr = iconArr[indexPath.row];
    lookVC.nameStr = nameArr[indexPath.row];
    
    lookVC.title = @"查看优友";
    lookVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lookVC animated:YES];
    
}

-(void) clickLeft{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showViewAnima" object:nil];
    
}

-(void) clickRight{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showViewAnima" object:@"showViewAnima"];
}

@end
