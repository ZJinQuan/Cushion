//
//  WeightViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/24.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "WeightViewController.h"
#import "CircleView.h"

@interface WeightViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, strong) CircleView *circle;

@end

@implementation WeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    CircleView *circle = [[CircleView alloc] initWithFrame:_topView.bounds];
    circle.centerView.backgroundColor = [UIColor whiteColor];
    circle.dataView.backgroundColor = RGBA(0, 233, 253, 1);
    circle.defaultView.backgroundColor = RGBA(232, 234, 234, 1);
    circle.percentage = 0.2;
    circle.arcWidth = 20;
//    circle.startAngle = 0.2;
    [self.topView addSubview:circle];
    self.circle = circle;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.circle.percentage = 0.4;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
