//
//  CircleView.h
//  空瀞
//
//  Created by femtoapp's macbook pro  on 15/8/24.
//  Copyright (c) 2015年 WL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView
@property (nonatomic,strong) UIView *centerView;    //中心区域显示
@property (nonatomic,strong) UIView *dataView;      //有数据的半弧
@property (nonatomic,strong) UIView *defaultView;   //剩余部分默认颜色
@property (nonatomic,assign) CGFloat arcWidth;      //弧宽
@property (nonatomic,assign) CGFloat percentage;    //百分比
@property (nonatomic,assign) CGFloat startAngle;

@property (nonatomic, strong) UILabel *weightLab;

@end
