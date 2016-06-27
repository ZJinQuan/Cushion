//
//  LookAtViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/27.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "LookAtViewController.h"
#import "ThatDayCell.h"
#import "MessageCell.h"

@interface LookAtViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation LookAtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _iconImage.image = [UIImage imageNamed:_iconStr];
    _nameLab.text = _nameStr;
    
    //移除手势
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_more"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightitem)];
    
    self.navigationItem.rightBarButtonItem = right;
    
    [self.messageTableView registerNib:[UINib nibWithNibName:@"ThatDayCell" bundle:nil] forCellReuseIdentifier:@"thatDayCell"];
    [self.messageTableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"messageCell"];
    
}

-(void) clickShock{
    
}

-(void) clickRightitem{
    
    
    
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    btn.centerX = view.centerX;
    btn.centerY = view.centerY;
    
    [btn setTitle:@"震TA一下" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:RGBA(8, 167, 23, 1) forState:UIControlStateNormal];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = RGBA(8, 167, 23, 1).CGColor;
    btn.layer.cornerRadius = 5;
    
    [btn addTarget:self action:@selector(clickShock) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            
            ThatDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thatDayCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }
            break;
        case 1:{
            
            MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}


@end
