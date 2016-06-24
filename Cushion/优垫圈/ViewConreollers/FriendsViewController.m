//
//  FriendsViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCell.h"

@interface FriendsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *friendTableView;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.friendTableView registerNib:[UINib nibWithNibName:@"FriendsCell" bundle:nil] forCellReuseIdentifier:@"friendsCell"];
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
    
    cell.rankingLab.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.iconImage.image = [UIImage imageNamed:iconArr[indexPath.row]];
    cell.nameLab.text = nameArr[indexPath.row];
    
    return cell;
}


@end
