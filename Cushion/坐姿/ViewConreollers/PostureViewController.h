//
//  PostureViewController.h
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "BaseViewController.h"
#import "BabyBluetooth.h"

@interface PostureViewController : BaseViewController{
@public
    BabyBluetooth *baby;
}

@property (nonatomic, assign) NSInteger *index;
@end
