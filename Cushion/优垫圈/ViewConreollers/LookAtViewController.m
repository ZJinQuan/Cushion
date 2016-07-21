//
//  LookAtViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/27.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "LookAtViewController.h"
#import "ThatDayCell.h"
#import "ChartCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LookAtCell.h"

@interface LookAtViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,XSChartDataSource,XSChartDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property(nonatomic,strong)NSArray *data;

@property (nonatomic, strong) AppDelegate *app;
@end

@implementation LookAtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _app = kAppDelegate;
    
    _iconImage.image = [UIImage imageNamed:_iconStr];
    _nameLab.text = _nameStr;
    
    _data=@[@1,@6,@3,@4,@9,@6,@12];
    
    //移除手势
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_more"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightitem)];
    
    self.navigationItem.rightBarButtonItem = right;
    
    [self.messageTableView registerNib:[UINib nibWithNibName:@"LookAtCell" bundle:nil] forCellReuseIdentifier:@"lookAtCell"];
    [self.messageTableView registerNib:[UINib nibWithNibName:@"ThatDayCell" bundle:nil] forCellReuseIdentifier:@"thatDayCell"];
    [self.messageTableView registerNib:[UINib nibWithNibName:@"ChartCell" bundle:nil] forCellReuseIdentifier:@"chartCell"];
    
    sect = [NSMutableArray arrayWithObjects:@"read value",@"write value",@"desc",@"properties", nil];
    readValueArray = [[NSMutableArray alloc]init];
    descriptors = [[NSMutableArray alloc]init];

}

-(void) clickShock{

    NSLog(@"%@ ------- %@",self.currPeripheral, self.characteristic);
    
    AppDelegate *app = kAppDelegate;

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    if (app.peripheral != nil) {
        
        Byte bytes[2];
 
        bytes[0] = 0xFF;
        bytes[1] = 0x01;
        
        NSData *data = [NSData dataWithBytes:&bytes length:sizeof(bytes)];
        
        [app.peripheral writeValue:data forCharacteristic:app.characteristics type:CBCharacteristicWriteWithoutResponse];
    }
    
}

-(void) clickRightitem{
    
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
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 150;
    }
    
    return 200;
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            
            LookAtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lookAtCell"];
            cell.timeLab.text = _app.currentTime;
            return cell;
        }
            break;
        case 1:{
            
            ThatDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thatDayCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }
            break;
        case 2:{
            
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
