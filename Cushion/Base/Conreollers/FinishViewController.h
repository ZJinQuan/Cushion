//
//  FinishViewController.h
//  Cushion
//
//  Created by QUAN on 16/7/1.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "BaseViewController.h"
#import "BabyBluetooth.h"

@interface FinishViewController : BaseViewController{
@public
    BabyBluetooth *baby;
}

@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@end
