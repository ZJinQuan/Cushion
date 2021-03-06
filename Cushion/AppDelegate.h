//
//  AppDelegate.h
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ByteModel.h"
#import "UserModel.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) CBCharacteristic *characteristics;

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) ByteModel *byte;

@property (nonatomic, strong) UserModel *user;

@property (nonatomic, copy) NSString *currentTime;
@end

