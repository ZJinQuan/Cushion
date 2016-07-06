//
//  AnalysisViewController.m
//  Cushion
//
//  Created by QUAN on 16/7/5.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "AnalysisViewController.h"
#import "AnalysisCell.h"

@interface AnalysisViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *analysisView;
@end

@implementation AnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [_analysisView registerNib:[UINib nibWithNibName:@"AnalysisCell" bundle:nil] forCellReuseIdentifier:@
     "analysisCell"];
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    btn.layer.cornerRadius = 10;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.center = view.center;
    [btn setTitle:@"初始化" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [view addSubview:btn];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"analysisCell";
    
    AnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *titleArr = @[@"久坐累计",@"日均久坐", @"体重波幅", @"日均正常坐姿", @"疲劳驾驶提醒"];
    
    cell.titleLab.text = titleArr[indexPath.row];
    
    return cell;
}


@end
