//
//  WeightViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/24.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "WeightViewController.h"
#import "CircleView.h"
#import "ChartCell.h"
#import "WeightCell.h"

@interface WeightViewController ()<UITableViewDelegate, UITableViewDataSource,XSChartDataSource,XSChartDelegate>

@property (nonatomic, strong) CircleView *circle;

@property (weak, nonatomic) IBOutlet UITableView *weightTableView;

@property(nonatomic,strong)NSArray *data;

@property (nonatomic, strong) AppDelegate *app;
@end

@implementation WeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _app = kAppDelegate;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];

    _data=@[@1,@6,@3,@4,@9,@6,@12];
    
    [self.weightTableView registerNib:[UINib nibWithNibName:@"WeightCell" bundle:nil] forCellReuseIdentifier:@"weightCell"];
    [self.weightTableView registerNib:[UINib nibWithNibName:@"ChartCell" bundle:nil] forCellReuseIdentifier:@"chartCell"];
}

#pragma mark XSChartDataSource and XSChartDelegate

-(NSInteger)numberForChart:(XSChart *)chart
{
    return _data.count;
}
-(NSInteger)chart:(XSChart *)chart valueAtIndex:(NSInteger)index
{
    return [_data[index] floatValue];
}
-(BOOL)showDataAtPointForChart:(XSChart *)chart
{
    return YES;
}
-(NSString *)chart:(XSChart *)chart titleForXLabelAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%ld",(long)index];
}
-(NSString *)titleForChart:(XSChart *)chart
{
    return @"正常坐姿占比曲线图";
}
-(NSString *)titleForXAtChart:(XSChart *)chart
{
    return nil;
}
-(NSString *)titleForYAtChart:(XSChart *)chart
{
    return nil;
}
-(void)chart:(XSChart *)view didClickPointAtIndex:(NSInteger)index
{
    NSLog(@"click at index:%ld",(long)index);
}


#pragma mark UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 30;
    }
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 20;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        
        lab.textAlignment = NSTextAlignmentCenter;
        
        lab.text = _app.currentTime;
        
        lab.textColor = RGBA(1, 195, 169, 1);
        
        return lab;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 230;
    }
    return 200;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            
            WeightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weightCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;

        }
            break;
        case 1:{
            
            ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chartCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.chart.dataSource = self;
            cell.chart.delegate = self;
            
            return cell;
            
        }
            break;
            
        default:
            break;
    }
    return nil;
}



@end
