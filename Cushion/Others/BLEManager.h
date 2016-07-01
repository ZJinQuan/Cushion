//
//  BLEManage.h
//  
//
//  Created by femto01 on 15/11/20.
//  Copyright © 2015年 WTT. All rights reserved.
//

/**
 *  #define kBLEM [BLEManager sharedBLEManager]
    if (kBLEM.isConnected) {
        [kBLEM writeDataToDevice:@[@(0)] command:1];
        [kBLEM writeDataToDevice:@[@(1),@(2)] command:2];
    }
 *
 *
 */

/*********//*********//*********//*********//*********//*********//*********/
// 车体数据	// 20B
//typedef struct
//{
//    uint16_t u32Mileage;
//    uint16_t u32Mileage1;// 里程（单位：km）				// 4B
//    uint16_t u16Speed;			// 时速（单位：0.1km/h）			// 2B
//    uint8_t u8Stat;			// 运行状态						// 1B
//    uint8_t u8ProtCause;		// 保护原因						// 1B
//    uint16_t u16BatV;			// 电池电压（单位：0.1V）		// 2B
//    uint8_t u8BatVStat;			// 电量状态（0~7代表0~7格电）	// 1B
//    uint8_t u8Mode;			// 模式（0:正常, 1:夜间, 2:龟速）	// 1B
//    int8_t i8LMotorT;			// 左电机温度（暂时为空）		// 1B
//    int8_t i8RMotorT;			// 右电机温度（暂时为空）		// 1B
//    int8_t i8MotorDrvT;		// 电机驱动温度（暂时为空）		// 1B
//    uint8_t u8ProductType;// 产品型号（01休闲款02越野款03smart04城市款）// 1B
//    uint8_t u8Rev0;			// 保留字节（数值为0）			// 1B
//    uint8_t u8Rev1;			// 保留字节（数值为01）			// 1B
//    uint8_t u8Rev2;			// 保留字节（数值为0）			// 1B
//    uint8_t u8Rev3;			// 保留字节（数值为0）			// 1B
//} TX_DAT;
//
//// 车体标志量	// 4B
//typedef struct
//{
//    uint8_t u8F0;		// 标志0
//    uint8_t u8F1;		// 标志1
//    uint8_t u8Rev0;	// 保留字节（数值为0）
//    uint8_t u8Rev1; 	// 保留字节（数值为0
//} TX_FLAG;
//
//struct
//{
//    uint8_t u8Preamble0;	// 帧头0 (0xAA)	// 1B
//    uint8_t u8Preamble1;	// 帧头1 (0x55)	// 1B
//    TX_DAT	stDat;		// 数据			// 20B
//    TX_FLAG	stFlag;		// 标志量		// 4B
//    uint16_t u16CRC;		// 校验码		// 2B
//} g_stRF_TxPac;
//
//struct
//{
//    uint8_t u8Preamble;	//(0x55)
//    uint8_t u8Cmd;		// 命令字节
//    uint32_t u8Dat;			// 数据字节
//    uint8_t u8Chk;			// 校验字节（前3个字节的异或校验值）
//} g_stComRxPac;
//
//struct
//{
//    uint32_t char1;
//    uint32_t char2;
//    uint32_t char3;
//    uint32_t char4;
//    uint32_t char5;
//} checkpassword;
//
//struct
//{
//    uint16_t char1;
//    uint16_t char2;
//    uint16_t char3;
//    uint16_t char4;
//    uint16_t char5;
//    uint16_t char6;
//    uint16_t char7;
//    uint16_t char8;
//    uint16_t char9;
//    uint16_t char10;
//} checkpassword1;
///*********//*********//*********//*********//*********//*********//*********/

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AppDelegate.h"
//扫描发现设备回调block
typedef void (^BleManagerDiscoverPeripheralCallBack) (NSArray *peripherals);
typedef void (^BleManagerConnectPeripheralCallBack) (BOOL isConnected);

@interface BLEManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
    
    BOOL isRenovatei;
    CBCharacteristic *read_characteristic;
    NSString * kServiceUUID;
    
    
    NSInteger write;

    NSInteger initlicheng;
//    CBCharacteristic *upDataCharacteristic;

}

#pragma mark -
#pragma mark 基本属性
@property (nonatomic, strong) AppDelegate * appBLE;
@property (strong, nonatomic) CBCentralManager *manager;        //BLE 管理中心

@property (strong, nonatomic) CBPeripheral     *peripheral;     //外设-蓝牙硬件

@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;     //外设-蓝牙硬件

@property (nonatomic,assign ) BOOL             isConnected;   //连接成功= yes，失败=no

@property (nonatomic,assign ) BOOL             isAutoDisconnect;     //是否自动连接，是=yes，不=no

@property (atomic,assign    ) BOOL           connectStatu;// 蓝牙连接状态

@property (strong, nonatomic  ) NSMutableArray        *peripherals;// 发现的所有 硬件设备

@property (strong, nonatomic) NSMutableArray *connectedPeripherals;//连接过的Peripherals

@property (strong, nonatomic) NSMutableArray *RSSIArray;// 蓝牙信号数组

@property (assign, readonly) BOOL isScaning; //是否正在扫描 是=yes，没有=no

@property (nonatomic,copy) NSString *DeviceState;

@property (nonatomic,strong) NSTimer *checkDeviceStateTimer;


/**
 * Completion block for peripheral scanning
 */
@property (copy, nonatomic) BleManagerDiscoverPeripheralCallBack scanBlock;

@property (nonatomic,strong) NSMutableArray *dataArray;

/*
 *连接蓝牙回调
 */
@property (copy, nonatomic) BleManagerConnectPeripheralCallBack connectBlock;

#pragma mark -
#pragma mark 基本方法
/**
 *  单例方法
 *
 *  @return self
 */
+ (instancetype)sharedBLEManager;

/*
 *  获取手机蓝牙状态
 */
- (BOOL)isLECapableHardware;

/**
 *  开启蓝牙扫描
 */
- (void)startScan;

/*
 *  开始扫描并在scanInterval秒后停止
 */
- (void)startScanWithInterval:(NSInteger)scanInterval completion:(BleManagerDiscoverPeripheralCallBack)callBack;

/**
 *  停止扫描
 */
- (void)stopScan;

/**
 *  连接到指定设备
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral;

/*
 *  连接蓝牙设备
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral completion:(BleManagerConnectPeripheralCallBack)callBack;

/*
 *  尝试重新连接
 */
- (void)reConnectPeripheral:(CBPeripheral *)peripheral;

/**
 *  断开连接
 */
- (void)disconnectPeripheral:(CBPeripheral *)peripheral;


-(void)reScan;  //断开现有设备的重新扫描

-(void)disconnectRootPeripheral;  //断开现连设备

-(void)check;  //检查是否有已连接的设备

#pragma mark -
#pragma mark 自定义其他属性或方法

#pragma mark - *********************************************
#pragma mark - 判断是否为浮点形
/**
 *  判断是否为浮点形
 *
 *  @param string 旧密码
 *
 *  @return yes or no
 */
//- (BOOL)isPureFloat:(NSString*)string;
//#pragma mark - APP 到 BLE 发送的指令
//
//#pragma mark - 连接成功后，登录到BLE
///**
// *  连接成功后，登录到BLE
// *
// *  @param password 登录的密码 默认（可修改） 000000
// */
//- (void)loginBle:(NSString *)password;
//#pragma mark - APP 退出
///**
// *  退出
// */
-(void)appExit;
//#pragma mark -
//#pragma mark - 开机或关机
///**
// *  开机或关机
// */
//- (void)onOrOffClick;
//#pragma mark -
//#pragma mark - 锁机
///**
// *  锁机
// */
//- (void)lockBle;
//#pragma mark -
//#pragma mark - 助力
///**
// *  助力
// */
//- (void)addPower;
//#pragma mark -
//#pragma mark - 模式切换
///**
// *  模式切换
// */
//- (void)modelChange;
//#pragma mark -
//#pragma mark - 校正平衡车
///**
// *  校正平衡车
// */
//- (void)correctionBalanceCar;
//#pragma mark -
//#pragma mark - 验证旧密码
///**
// *  验证旧密码
// *
// *  @param oldpwd 旧的密码
// */
//- (void)checkOldPassword:(NSString *)oldPwd;
//#pragma mark -
//#pragma mark - 修改BLE登录密码
///**
// *  修改BLE登录密码
// *
// *  @param newPwd 新密码 （如果发送：000000，则为重置密码）
// */
//- (void)modifyPassword:(NSString *)newPwd;
//#pragma mark -
//#pragma mark - 校验密码是否正确
///**
// *  校验密码是否正确
// *
// *  @param data 返回的数据
// *
// *  @return 代表的数字 0，1，2，3
// */
//-(NSInteger)ispwdcheck:(NSData *)data;
//
///**
// *  计算里程
// *
// *  @param index <#index description#>
// *
// *  @return <#return value description#>
// */
//- (NSString *)returnlicheng:(NSInteger)index;

/**
 *  确定是否为第一次登陆:用于蓝牙密码登陆成功后提示用户使用的判断
 */
//@property (assign, nonatomic) BOOL isFirstLogin;
///**
// *  有接收数据=yes 没有接收数据=no
// */
//@property (assign, nonatomic) BOOL haveData;
//
//@property (assign, nonatomic) NSInteger bleLoginFailCount;
///**
// *  检查蓝牙密码是否正确
// */
//- (BOOL)checkLoginBlePassword;
//
//
////我自己添加的属性
//@property (nonatomic, strong) NSUserDefaults * userDefault;
@end
