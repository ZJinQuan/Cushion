//
//  TopScollCell.h
//  Cushion
//
//  Created by QUAN on 16/6/28.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollImage.h"

@interface TopScollCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *scollView;

@property (nonatomic, strong) ScrollImage *scrollImage;

@end
