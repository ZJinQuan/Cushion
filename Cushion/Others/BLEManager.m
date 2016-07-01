//
//  BLEManage.m
//  
//
//  Created by femto01 on 15/11/20.
//  Copyright © 2015年 WTT. All rights reserved.
//

#import "BLEManager.h"



@interface BLEManager ()

//是否有回应
@property (nonatomic,assign) BOOL isDeviceRespond;

@property (nonatomic,strong) NSDateFormatter *dateformatter;



@end

static BLEManager *shareManager = nil;
////检查设备状态次数
//static NSInteger checkDeviceStateTimes = 0;
//设备没有回应次数
static NSInteger deviceNoRespond = 0;

@implementation BLEManager

-(CBCharacteristic *)writeCharacteristic{
    if (!_writeCharacteristic) {
        for (CBService *s in self.peripheral.services) {
            for (CBCharacteristic *c in s.characteristics) {
                if ([c.UUID.UUIDString isEqualToString:kCBCharacteristicUUID]) {
                    _writeCharacteristic = c;
                    break;
                }
            }
            if (_writeCharacteristic) {
                break;
            }
        }
        
    }
    return _writeCharacteristic;
}

-(NSDateFormatter *)dateformatter{
    if (!_dateformatter) {
        _dateformatter=[[NSDateFormatter alloc] init];
        [_dateformatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    }
    return _dateformatter;
}

-(void)dealloc{
    self.checkDeviceStateTimer =  nil;
}

-(NSTimer *)checkDeviceStateTimer{
    if (!_checkDeviceStateTimer) {
        _checkDeviceStateTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkDeviceState) userInfo:nil repeats:YES];
    }
    return _checkDeviceStateTimer;
}

#pragma mark - 检查设备所处状态
-(void)checkDeviceState{
    //没有返回状态
    if (!_isDeviceRespond) {
        if (deviceNoRespond>4) {
            //发送异常断开
            [self writeAbnormalToDevice];
            
            [self.checkDeviceStateTimer setFireDate:[NSDate distantFuture]];
            return;
        }else{
            deviceNoRespond++;
            NSLog(@"第%d次没有回应状态指令",deviceNoRespond);
        }
    }else{
        deviceNoRespond = 0;
    }
    
    //E7 00 00 0c 00 0a 00 24
    //01 03 00 04 00 00 00 d1
    Byte byte_Arr[16] = {0xE7,0x00,0x00,0x0c
                        ,0x00,0x0a,0x00,0x24
                        ,0x01,0x03,0x00,0x04
                        ,0x00,0x00,0x00,0xd1
                        };
                
    NSData *data = [NSData dataWithBytes:&byte_Arr length:sizeof(byte_Arr)];
    
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.peripheral writeValue:data
                  forCharacteristic:self.writeCharacteristic
                               type:CBCharacteristicWriteWithResponse];
        NSLog(@"======= 发送检查设备所处状态指令 ======");
        
   // });

}
    




#pragma mark -
#pragma mark 基本方法
/**
 *  单例方法
 *
 *  @return self
 */
+ (instancetype)sharedBLEManager {
    if (shareManager == nil) {
        shareManager = [[super allocWithZone:NULL] init];
        
    }
    return shareManager;
}

// 初始化连接
- (instancetype)init {
    self = [super init];
     //BLE 管理中心
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _manager.delegate = self;
    _dataArray = [NSMutableArray array];
    _appBLE = kAppDelegate;
    _DeviceState = KDeviceState_Disconnected;

    return self;
}

#pragma mark ======= 获取手机蓝牙状态 =======
- (BOOL)isLECapableHardware {
    NSString * state = nil;
    
    int iState = (int)[_manager state];
    
    NSLog(@"Central manager state: %i", iState);
    
    switch ([_manager state]) {
        case CBCentralManagerStateUnsupported://不支持
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized://未授权
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff://蓝牙关闭
        {
            state = @"Bluetooth is currently powered off.";
//            NSString *alertTitle = @"请打开蓝牙";
//            UIAlertView *alter =[[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:self  cancelButtonTitle:@"确定"  otherButtonTitles:nil,nil];
//            [alter show];

        }
            break;
        case CBCentralManagerStatePoweredOn://蓝牙打开
            _DeviceState = KDeviceState_Unassociated;
            return TRUE;
        case CBCentralManagerStateUnknown://未知状态
        default:
            return FALSE;
            
    }
    
    NSLog(@"Central manager state: %@", state);
    
    return FALSE;
}

#pragma mark 开启蓝牙扫描-(可针对性扫描)
- (void)startScan {
    if ([self isLECapableHardware]) {
        if (_peripherals) {
            // 发现的所有 硬件设备
            [_peripherals removeAllObjects];
            // 蓝牙信号数组
            [_RSSIArray removeAllObjects];
        } else {
            // 发现的所有 硬件设备
            _peripherals = [NSMutableArray array];
            // 蓝牙信号数组
            _RSSIArray = [NSMutableArray array];
        }
        //是否正在扫描 是=yes，没有=no
        _isScaning = YES;
        
            [_manager scanForPeripheralsWithServices:nil options:nil];
            [self performSelector:@selector(stopScan) withObject:nil afterDelay:20];
//        }
        // 针对性扫描  serviceUUIDs = [NSArray arrayWithObject:[CBUUID UUIDWithString:@"180D"]]
        // 其中  180D 就是对外公开的 1 级 服务UUID
        //        [_manager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"B302D3B1-A81C-90FC-8727-F8B9C1D7CC77"]] options:nil];
        
    } else {
        if (self.scanBlock) {
            self.scanBlock(_peripherals);
            self.scanBlock(nil);
        }
    }
}

-(void)retit{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * uuidstr =[userDefaults objectForKey:@"UUIDString"];
    [_manager retrievePeripheralsWithIdentifiers:[NSArray arrayWithObject:[CBUUID UUIDWithString:uuidstr]]];
}


#pragma mark - 检查已与手机连接的设备
-(BOOL)checkConnectedPeripherals
{   NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * uuidstr =[userDefaults objectForKey:@"UUIDString"];
    if (uuidstr) {
        NSArray *arr = [_manager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:uuidstr]]];
        for (CBPeripheral *per in arr) {
            if ([per.name hasPrefix: @"BP60E/S"]) {
                [self connectPeripheral:per];
                return YES;
            }
        }
    }
    return NO;
}

-(void)check{
    BOOL result = [self checkConnectedPeripherals];
    
    if (result) {
        return;
    }
    
    [_manager scanForPeripheralsWithServices:nil options:nil];
}

#pragma mark 开始扫描并在scanInterval秒后停止
- (void)startScanWithInterval:(NSInteger)scanInterval completion:(BleManagerDiscoverPeripheralCallBack)callBack {
    self.scanBlock = callBack;
    [self startScan];
    [self performSelector:@selector(stopScan) withObject:nil afterDelay:scanInterval];
}

#pragma mark 停止扫描
- (void)stopScan {
    _isScaning = NO;
    [_manager stopScan];
    [[NSNotificationCenter defaultCenter] postNotificationName:KBLEstopScan object:nil];
    
    if (self.scanBlock) {
        self.scanBlock(_peripherals);
        self.scanBlock(nil);
    }
}

#pragma mark 连接到指定设备
- (void)connectPeripheral:(CBPeripheral *)peripheral {
    [_manager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    _peripheral = peripheral;
}

#pragma mark 连接蓝牙设备
- (void)connectPeripheral:(CBPeripheral *)peripheral completion:(BleManagerConnectPeripheralCallBack)callBack {
    self.connectBlock = callBack;
    [self connectPeripheral:peripheral];
    [self performSelector:@selector(connectTimeOutAction) withObject:nil afterDelay:5.0];
}

#pragma mark 尝试重新连接
- (void)reConnectPeripheral:(CBPeripheral *)peripheral {
    [_manager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}

#pragma mark 断开连接
- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
    [_manager cancelPeripheralConnection:peripheral];
    _isConnected = NO;
    _DeviceState = KDeviceState_Unassociated;
    _isAutoDisconnect = NO;
    //_haveData = NO;
//    kAppDelegate.isConnected = NO;
    if (_peripheral) {
        [_peripheral setDelegate:nil];
        _peripheral = nil;
    }
    
    
    initlicheng = 0;
//    _manager.delegate = nil;
}
#pragma mark  =========== 以上是搜索蓝牙的 ===============

#pragma mark -
#pragma mark BLE 管理中心的代理方法
#pragma mark -
/*
 *Invoked whenever the central manager's state is updated.
 *设备蓝牙状态发生改变
 */
#pragma mark 第一步：蓝牙断开走这个方法。这是系统的回调方法，当手机蓝牙断开时会在这个方法，监测设备蓝牙状态发生改变
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if ([self isLECapableHardware]) {
        //_appBLE.isBLETrue = NO;
        if (_peripheral) {
            [self reConnectPeripheral:_peripheral];
        } else {
            [self startScan];
        }
        
    } else {
        NSLog(@"手机蓝牙已关闭");
        _DeviceState = KDeviceState_Disconnected;
        //蓝牙已断开通知
        [[NSNotificationCenter defaultCenter]  postNotificationName:kBLEHasBroken object:nil];
    }
    
}

/*
 *Invoked when the central discovers heart rate peripheral while scanning.
 *发现蓝牙设备
 */
#pragma mark 第二步：发现蓝牙设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSArray *serviceUUIDs = [advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey];
    NSLog(@"aPeripheral========%@",aPeripheral);
    NSLog(@"APeripheralName==========%@",serviceUUIDs);
    NSLog(@"advertisementData ======= %@",advertisementData);
    NSLog(@">>> %@",aPeripheral.services);
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * uuidstr =[userDefaults objectForKey:@"UUIDString"];
    NSLog(@"uuidstr = %@",uuidstr);
    if (uuidstr) {
        if ([aPeripheral.identifier.UUIDString isEqualToString:uuidstr]) {
            [self connectPeripheral:aPeripheral];
            return;
        }
    
    }
    
    
    
    if ([_peripherals containsObject:aPeripheral] == NO) {
        [_peripherals addObject:aPeripheral];
    }
    
    [_RSSIArray addObject:RSSI];
    
    if (_peripherals.count >= 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"已搜索到了BLE设备列表" object:nil];
    }
}

/*
 Invoked when the central manager retrieves the list of known peripherals.
 Automatically connect to first known peripheral
 */
#pragma mark 当中央管理器调用检索列表中已知的外围设备。自动连接到第一个已知的外围
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    /* If there are any known devices, automatically connect to it.*/
    
    if([_peripherals count] >= 1) {
        _peripheral = [peripherals objectAtIndex:0];
        NSLog(@"当中央管理器调用检索列表中已知的外围设备。自动连接到第一个已知的外围........此设备名为==%@",_peripheral.name);
        [_manager connectPeripheral:_peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
}

/*
 *Invoked whenever a connection is succesfully created with the peripheral.
 *Discover available services on the peripheral
 *已连接到设备
 */
#pragma mark 第三步：已连接到设备-----每当调用是成功创建连接外围。外围发现可用的服务 aPeripheral.identifier.UUIDString 是唯一的UUID，identifier是他唯一的UUID值，拿到他保存起来
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral {
    NSLog(@"蓝牙连接成功");
    //
    NSLog(@"外设的UUID值 ：%@", aPeripheral.identifier.UUIDString);
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:aPeripheral.identifier.UUIDString forKey:@"UUIDString"];
    [userDefaults synchronize];
    
    [aPeripheral setDelegate:self];
    [aPeripheral discoverServices:nil];
    
    _isConnected = YES;
//    kAppDelegate.isConnected = YES;
    if (self.connectBlock) {
        self.connectBlock(YES);
        self.connectBlock = nil;
    }
    
    [self stopScan];
}

/*
 *Invoked whenever an existing connection with the peripheral is torn down.
 *Reset local variables
 *设备已经断开
 */
#pragma mark 设备断开走这个方法设备已经断开
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    if(_peripheral)
    {
        [_peripheral setDelegate:nil];
        _peripheral = nil;

    }
    
    _isConnected = NO;
    _isAutoDisconnect = YES;
    //_haveData = NO;
    if (_isAutoDisconnect == NO) {
        //断开n秒计时
        [self performSelector:@selector(disconnectTimerAction) withObject:nil afterDelay:4.0];
    } else {
        //[self connectPeripheral:aPeripheral];
    }
    
    if (self.connectBlock) {
        self.connectBlock(NO);
        self.connectBlock = nil;
    }
    
    //[self reScan];
    
    
   
}

/*
 *Invoked whenever the central manager fails to create a connection with the peripheral.
 *连接设备失败
 */
#pragma mark 连接设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error {
    NSLog(@"Fail to connect to peripheral: %@ with error = %@", aPeripheral, [error localizedDescription]);
    if(_peripheral) {
        [_peripheral setDelegate:nil];
        _peripheral = nil;
    }
}

#pragma mark -
#pragma mark -外设 的代理方法
#pragma mark -
/*
 *Invoked upon completion of a -[discoverServices:] request.
 *Discover available characteristics on interested services
 *发现服务
 */
#pragma mark 第四步：发现服务
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error {
    for (CBService *aService in aPeripheral.services) {
        NSLog(@"Service found with UUID : %@", aService.UUID.UUIDString);
        //这是判断是不是我想要的 aService.UUID.UUIDString
        
            kServiceUUID=[NSString stringWithFormat:@"%@", aService.UUID];
            //如果是的话就进入下一步 发现服务特征值
            [aPeripheral discoverCharacteristics:nil forService:aService];
        
        
    }
}
//  FFE0 
/*
 *Invoked upon completion of a -[discoverCharacteristics:forService:] request.
 *Perform appropriate operations on interested characteristics
 *发现服务特征值
 */
#pragma mark 第五步：发现服务特征值
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"Service : %@", service.UUID);
    NSLog(@"includedServices :%@",service.includedServices);
    NSLog(@"characteristics :%@",service.characteristics);
    if (service.isPrimary) {
        NSLog(@"service.isPrimary : %@", service.UUID);
    }
    //self.peripheral = aPeripheral;
    //_appBLE.isConnectionSuccess = YES;
    //-------------------------------------------------------
    //此处对服务UUID 进行 一对一 匹配，然后再遍历 其特征值，再对需要用到的特征UUID 进行一对一匹配
    //if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
        int i = 0;
        for (CBCharacteristic *characteristic in service.characteristics) {
            NSLog(@"characteristic.UUID.UUIDString :%@", characteristic.UUID.UUIDString);
            NSLog(@"characteristic.value :%@",[[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
            
            
            
//            if ([@"FFD1" isEqualToString:characteristic.UUID.UUIDString]) {
//                writeCharacteristicFFD1= characteristic;
//                Byte ACkValue[1] = {0};
//                ACkValue[0] = 0x01;
//                NSData *data = [NSData dataWithBytes:&ACkValue length:sizeof(ACkValue)];
//                if (writeCharacteristicFFD1) {
//                    [self.peripheral writeValue:data forCharacteristic:writeCharacteristicFFD1 type:CBCharacteristicWriteWithResponse];
//                    //把这个特征值的通知打开
//                    [_peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
//                }
//            }
            
            
            
            [_peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSLog(@"进行一对一匹配====== %d",(i++));
            
        }
   // }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEConnectionSucceed object:nil];
}



#pragma mark - 第六步：当连接成功后收到数据**************************
//
//BP60和APP建立联接的过程:
//当 BP60 设备检查到 BT 正确联接时,自动使用自定义的命令 BP_UNASS_TO_ASS
//令设备从 Unassociated 状态改变为 Associating 状态,同时发送请求 REQ_APP_UNASS_TO_ASS 给 App;BP60 应当等待 APP 的回应包直到超时(见下 面的超时处理)。App 在收到请求包 REQ_APP_UNASS_TO_ASS 后,App 从 Unassociated 状态改变为 Operating 状态,并发出应答包 RPL_BP_OPRING。
//BP60 在收到应答包 RPL_BP_OPRING 后,使用内部自定义命令 BP_ASS_TO_OPR, 设备从 Associating 状态改变为 Operating 状态。此时,BP60 与 App 都已处在 Operating 状态,可以进行正常的数据传输。
- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    [self writeCharacteristic:characteristic];
    
    
}

-(void)setIsConnected:(BOOL)isConnected{
    _isConnected = isConnected;
    if (_isConnected==NO) {
        //[self.checkDeviceStateTimer setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark - ******** === 【读取数据  并进行相应的操作】 === *********
- (void)writeCharacteristic:(CBCharacteristic *)characteristic{
    
    isRenovatei = NO;
    
    //NSLog(@" ******* 设备发送数据的UUID :%@",characteristic.UUID.UUIDString);
    NSData *readData = characteristic.value;
    NSLog(@" ******* 收到数据--readData :%@",readData);
    if ((!(readData.length>0)) || readData != nil) {
        return;
    }
    Byte *readBytes = (Byte *)[readData bytes];
    
    //0xE2 表示是一个请求包       readBytes[3]为包的长度
    if (readBytes[0] == 0xE2 && readBytes[3] == 0x32) {
        self.DeviceState = KDeviceState_Operating;
        //回复包
        Byte byte_Arr[48];
        
        //{0xE3,0x00,0x00,0x2C,0x00,0x00,0x50,0x79,0x00,0x26,0x80,0x00,0x00,0x00,0x80,0x00,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x00,0x00,0x00,0x00,0x08,0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};

        for (int i = 0; i < 48; i ++) {
            
            byte_Arr[i] = 0x00;
            
        }
        
        byte_Arr[0] = 0xE3;
        byte_Arr[3] = 0x2C;

        NSData *data = [NSData dataWithBytes:&byte_Arr length:sizeof(byte_Arr)];
        
        [self.peripheral writeValue:data
                  forCharacteristic:self.writeCharacteristic
                               type:CBCharacteristicWriteWithResponse];
        NSLog(@"====== 收到设备发送的请求包---发送回复包 ======");
        //开启定时器
        [self.checkDeviceStateTimer setFireDate:[NSDate distantPast]];
        
        
    }
    

#pragma mark -  0xE7 表示这为一个操作包
    if (readBytes[0] == 0xE7) {
        
        //   RPL_APP_STATU 设备工作状态               0x00 0xD1 – 表示为读状态
        if (readBytes[3] == 0x1B && readBytes[14] == 0x00 && readBytes[15] == 0xD1 ) {
            
            _isDeviceRespond = YES;
            
        }else{ _isDeviceRespond = NO;}
        
        //--------设备自动发来最新一次测量数据    0x01 0x01-表示只是为远程Invoke报告确认  0x0D 0x1D –事件种MDC_NOTI_SCAN_REPORT_FIXED
        if (readBytes[3] == 0x3E && readBytes[8] == 0x01 &&readBytes[9] == 0x01 &&readBytes[18] == 0x0D && readBytes[19]==0x1D) {
            
            NSString * ssy = [NSString stringWithFormat:@"%hhu",readBytes[39]];
            NSString * szy = [NSString stringWithFormat:@"%hhu",readBytes[41]];
            NSString * xl = [NSString stringWithFormat:@"%hhu",readBytes[57]];
            NSString * testTime = [self.dateformatter stringFromDate:[NSDate date]];
            [[NSNotificationCenter defaultCenter] postNotificationName:KBT_GetNewDataFromDevice object:nil userInfo:@{@"ssy":ssy,@"szy":szy,@"xl":xl,@"testTime":testTime}];
            NSLog(@"========收到设备自动发来的最新一次测量数据========");
            
            //-----------------------------------------------
            //设备自动发来数据 要在三秒内返回一个回复包 不然会断开连接
            //-----------------------------------------------
            Byte b_Arr[22] = {0xE7,0x00,0x00, 0x12,0x00, 0x10,0x00, 0x54,0x02, 0x01,0x00, 0x0A,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x0D,0x1D,0x00, 0x00};

            NSData *b_data = [NSData dataWithBytes:&b_Arr length:sizeof(b_Arr)];
            
            usleep(2);
            [self.peripheral writeValue:b_data
                      forCharacteristic:self.writeCharacteristic
                                   type:CBCharacteristicWriteWithResponse];
            NSLog(@"========发送回复包========");
            //开启定时器
            //[self.checkDeviceStateTimer setFireDate:[NSDate distantPast]];
        }
    }
    
    
    //断开
    // E4 表示这是一个断开  由设备发出的断开请求  需要回复一个同意包，如果三秒内没回复 设备会自己断开
    if (readBytes[0]== 0xE4) {
        Byte e5_bytes[6] = {0xE5,0x00,0X00,0x02,0x00,0x00};
        NSData * writeE5Data = [NSData dataWithBytes:&e5_bytes length:sizeof(e5_bytes)];
        [self.peripheral writeValue:writeE5Data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
        self.DeviceState = KDeviceState_Disassociating;
        //断开设备
        [self disconnectPeripheral:self.peripheral];
    }
    
    //由于异常或者是没有及时回复一个确认包，设备任性地自己断开会发来这个异常包
    if(readBytes[0] == 0xE6){
        
        NSString *str = @"设备异常断开";
        if (readBytes[5] == 0x02) {
            str = @"设备超时断开";
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KBT_DeviceAutoDisconnect object:nil userInfo:@{@"reason":str}];
        
        self.DeviceState = KDeviceState_Disassociating;
        //断开设备
        [self disconnectPeripheral:self.peripheral];
    }
}

#pragma mark - 发送异常断开
-(void)writeAbnormalToDevice{
    Byte byte_Arr[6] = {0xE6,0x00,0x00,0x02,0x00,0x02};
    
    
    NSData *data = [NSData dataWithBytes:&byte_Arr length:sizeof(byte_Arr)];
    
    [self.peripheral writeValue:data
              forCharacteristic:self.writeCharacteristic
                           type:CBCharacteristicWriteWithResponse];
    usleep(1);
    [self disconnectPeripheral:self.peripheral];
}


#pragma mark 获取蓝牙的信号强度
/**
 * -->描述：获取蓝牙的信号强度
 */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    //    NSLog(@"RSSI:%i", [[peripheral RSSI] intValue]);
    int rssi;
    rssi=[[peripheral RSSI] intValue];
    NSString *fid;
    fid= peripheral.identifier.UUIDString  ;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BLE-RSSI-信号强度通知-Name" object:[NSString stringWithFormat:@"%@,%i",fid,rssi]];
}

/*
 *写数据成功
 */
#pragma mark 写入数据成功会进入此方法,有些数据是要读一次才会返回数据过来的，就在这个方法里,比如按按钮发送一条指令就要进行一次读写操作
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error)
    {
        NSLog(@"写入数据失败---characteristic %@, reason: %@", characteristic.UUID.UUIDString, error);
    }
    else
    {
        NSLog(@"写入数据成功---characterstic %@, new value: %@", characteristic.UUID.UUIDString, [characteristic value]);
        
    }
    [peripheral readValueForCharacteristic:characteristic];
}

#pragma mark -
#pragma mark -其他自定义的方法
#pragma mark -

/**
 *  连接超时
 */
- (void)connectTimeOutAction {
    if (!self.isConnected) {
        if (self.connectBlock) {
            self.connectBlock(NO);
            self.connectBlock = nil;
        }
    }
}

#pragma mark ====== 断开计时后确认断开 ===========
/*
 *断开计时后确认断开
 */
- (void)disconnectTimerAction {
    if (!_isConnected) {  //确认是否断开
        NSLog(@"蓝牙已断开连接");
        self.DeviceState = KDeviceState_Unassociated;
        //[self.checkDeviceStateTimer setFireDate:[NSDate distantFuture]];
         //[[NSNotificationCenter defaultCenter]  postNotificationName:kBLEHasBroken object:nil];
    }
}

#pragma mark - 重新扫描
-(void)reScan {
    if (self.isScaning) {
        [self stopScan];
        if (_isConnected) {
            [self disconnectPeripheral:_peripheral];
        } else {
            [self startScan];
        }
    }else{
        [self startScan];
    }
}

-(void)disconnectForReScan {
    [self startScan];
}

-(void)disconnectRootPeripheral {
    [_manager cancelPeripheralConnection:_peripheral];
    _isConnected = NO;
    _isAutoDisconnect = NO;
//    kAppDelegate.isConnected = NO;
}



#pragma mark - APP 退出
///**
// *  退出
// */
-(void)appExit {
    NSLog(@"exit");
    if (self.checkDeviceStateTimer) {
        [self.checkDeviceStateTimer setFireDate:[NSDate distantFuture]];
    }
    [kBLEManager writeAbnormalToDevice];
    usleep(1);
    [kBLEManager disconnectPeripheral:self.peripheral];
}



@end
