//
//  ConnectViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/30.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "ConnectViewController.h"

@interface ConnectViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *connectView;

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [kBLEManager startScan];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBlue:) name:@"已搜索到了BLE设备列表" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectFinish) name:kBLEConnectionSucceed object:nil];
}

-(void) connectBlue:(NSNotification *) noti{
    
    
    NSLog(@"%@",kBLEManager.peripherals);
    
    [self.connectView reloadData];
    
}

-(void) connectFinish{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark UITableViewDelegate and UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return kBLEManager.peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    CBPeripheral *p = kBLEManager.peripherals[indexPath.row];
    
    cell.textLabel.text = p.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (kBLEManager.isConnected) {
        
        [kBLEManager disconnectPeripheral:kBLEManager.peripheral];
        
    }
    
    CBPeripheral *p = kBLEManager.peripherals[indexPath.row];
    [kBLEManager connectPeripheral:p completion:nil];
    
}

@end
