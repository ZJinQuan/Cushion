//
//  FriendsCell.h
//  Cushion
//
//  Created by QUAN on 16/6/23.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankingLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;

@end
