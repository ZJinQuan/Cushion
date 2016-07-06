//
//  TabBarViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "TabBarViewController.h"
#import "PostureViewController.h"
#import "DriveViewController.h"
#import "FriendsViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "ConnectViewController.h"
#import "RightCell.h"
#import "LeftView.h"
#import "PersonalViewController.h"
#import "SystemViewController.h"
#import "AnalysisViewController.h"
#import "SetUpViewController.h"

CGFloat const gestureMinimumTranslation = 20.0 ;

typedef enum : NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft
    
} CameraMoveDirection ;

@interface TabBarViewController ()<UITableViewDataSource, UITableViewDelegate>{
    CameraMoveDirection direction;
}
// mainView 的起始位置
@property (nonatomic,assign) CGFloat leftDistance;
@property (nonatomic,assign) CGFloat rightDistance;

@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) LeftView * leftBottomView;
@property (nonatomic, strong) UIView * rightBottomView;

@property (nonatomic, retain) UIPanGestureRecognizer *pan;
@end

@implementation TabBarViewController

-(UIView *)bottomView{
    
    if (_bottomView == nil) {
        
        _bottomView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bottomView.hidden = YES;
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _bottomView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_bottomView addGestureRecognizer:tap];
    }
    return _bottomView;
}

-(LeftView *)leftBottomView{
    
    if (_leftBottomView == nil) {
        
        _leftBottomView = [[LeftView alloc] initWithFrame:CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        _leftBottomView.backgroundColor = [UIColor yellowColor];
        
//        LeftViewController *left = [[LeftViewController alloc] init];
//        left.view.frame = CGRectMake(85, 0, _leftBottomView.width - 85, _leftBottomView.height);
//        
//        [_leftBottomView addSubview:left.view];
        
        LeftView *leftV = [[LeftView alloc] initWithFrame:CGRectMake(85, 0, _leftBottomView.width - 85, _leftBottomView.height)];
        
        [_leftBottomView addSubview:leftV];
        
    }
    return _leftBottomView;
}

-(UIView *)rightBottomView{
    
    if (_rightBottomView == nil) {
        
        _rightBottomView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        _rightBottomView.backgroundColor = [UIColor redColor];
        
        RightViewController *right = [[RightViewController alloc] init];
        right.view.frame = CGRectMake(0, 0, _rightBottomView.width - 85, _rightBottomView.height);
        right.rightTableVIew.dataSource = self;
        right.rightTableVIew.delegate = self;
        
        [right.rightTableVIew registerNib:[UINib nibWithNibName:@"RightCell" bundle:nil] forCellReuseIdentifier:@"rightCell"];
        
        [_rightBottomView addSubview:right.view];
        
    }
    return _rightBottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barTintColor = RGBA(1, 195, 169, 1);
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: RGBA(255, 169, 34, 1)} forState:UIControlStateSelected];
    
    //添加子控制器
    [self addChildViewController:[[PostureViewController alloc] init] andTitle:@"坐姿" andImageName:@"sit" addSeledImage:@"sit_s"];
    [self addChildViewController:[[DriveViewController alloc] init] andTitle:@"驾驶" andImageName:@"drive" addSeledImage:@"drive_s"];
    [self addChildViewController:[[FriendsViewController alloc] init] andTitle:@"优垫圈" andImageName:@"circle" addSeledImage:@"circle_s"];
    
    _leftDistance = -kScreenWidth;
    _rightDistance = kScreenWidth;

    //添加蒙版
    [self.view addSubview:self.bottomView];
    
    //添加左边View
    [self.view addSubview:self.leftBottomView];
    
    //添加右边View
    [self.view addSubview:self.rightBottomView];

    //添加滑动手势
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showViewAnima:) name:@"showViewAnima" object:nil];
    
    //添加滑动手势通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGestures) name:@"addGestures" object:nil];
    
    //移除手势通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeGestures) name:@"removeGestures" object:nil];
    
    //跳转界面通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickInterface:) name:@"clickInterface" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataIcon:) name:@"updataIcon" object:nil];
}

-(void)updataIcon:(NSNotification *)notf{
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"iconImage.png"]];
//    
//    if ([UIImage imageWithContentsOfFile:filePath] != nil) {
//        _leftBottomView.iconImage.image = [UIImage imageWithContentsOfFile:filePath];
//    }
    
    [_leftBottomView updataIconImage];
}

//跳转界面
-(void) clickInterface: (NSNotification *)notf{
    
    [UIView animateWithDuration:0.2 animations:^{
        _leftBottomView.x =  -kScreenWidth;
        _rightBottomView.x = kScreenWidth;
        _leftDistance = _leftBottomView.x;
        _rightDistance = _rightBottomView.x;
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        _bottomView.hidden = YES;

        
        if ([notf.object isEqualToString:@"connectBlue"]) {
            
            ConnectViewController *connectVC = [[ConnectViewController alloc] init];
            [connectVC setHidesBottomBarWhenPushed:YES];
            
            [self.selectedViewController pushViewController:connectVC animated:YES];
        }
        
        if ([notf.object isEqualToString:@"Personal"]) {
            
            PersonalViewController *persinalVC = [[PersonalViewController alloc] init];
            persinalVC.title = @"个人中心";
            [persinalVC setHidesBottomBarWhenPushed:YES];
            
            [self.selectedViewController pushViewController:persinalVC animated:YES];
        }
        
        if ([notf.object isEqualToString:@"System"]) {
            
            SystemViewController *systemVC = [[SystemViewController alloc] init];
            systemVC.title = @"系统消息";
            [systemVC setHidesBottomBarWhenPushed:YES];
            
            [self.selectedViewController pushViewController:systemVC animated:YES];
        }
        
        if ([notf.object isEqualToString:@"Analysis"]) {
            
            AnalysisViewController *analysisVC = [[AnalysisViewController alloc] init];
            analysisVC.title = @"报告分析";
            [analysisVC setHidesBottomBarWhenPushed:YES];
            
            [self.selectedViewController pushViewController:analysisVC animated:YES];
        }
        
        if ([notf.object isEqualToString:@"SetUp"]) {
            
            [self setSelectedIndex:0];
            
            SetUpViewController *setupVC = [[SetUpViewController alloc] init];
            setupVC.title = @"系统设置";
            [setupVC setHidesBottomBarWhenPushed:YES];
            
            [self.selectedViewController pushViewController:setupVC animated:YES];
        }
    }];

}

-(void)showViewAnima:(NSNotification *) noti {
    
    if (noti.object == nil) {
        [self showLeftWithAnimaTime:0.1];
    }else{
        [self showRightWithAnimaTime:0.1];
    }
    
}

#pragma mark  UITableViewDataSource and UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"rightCell";
    
    RightCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *iconArr = @[@"bg_photo2", @"bg_my", @"bg_photo2", @"bg_photo3", @"bg_photo4", @"bg_photo2", @"bg_my"];
    NSArray *nameArr = @[@"LIM",@"林涛", @"汉诺", @"张三", @"李四" ,@"王五", @"赵六"];
    
    cell.iconImage.image = [UIImage imageNamed:iconArr[indexPath.row]];
    cell.nameLab.text = nameArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark 移除和添加手势
-(void) addGestures{
    
    if (self.pan == nil) {

        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        [self.view addGestureRecognizer:self.pan];
        
    }
}

-(void) removeGestures{
    
    [self.view removeGestureRecognizer:self.pan];
    self.pan = nil;
}

#pragma mark 手势
- ( void )handleSwipe:( UIPanGestureRecognizer *)gesture{
    
    CGPoint translation = [gesture translationInView: self .view];
    
    if (gesture.state == UIGestureRecognizerStateBegan ){
        
        direction = kCameraMoveDirectionNone;
        
    }else if (gesture.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone){
        
        direction = [ self determineCameraDirectionIfNeeded:translation];
        
        // ok, now initiate movement in the direction indicated by the user's gesture
        switch (direction) {
                
            case kCameraMoveDirectionDown:
                
//                NSLog (@ "Start moving down" );
                
                break ;
                
            case kCameraMoveDirectionUp:
                
//                NSLog (@ "Start moving up" );
                
                break ;
                
            case kCameraMoveDirectionRight:
                
//                NSLog (@ "Start moving right" );
                
                if (_rightBottomView.x < kScreenWidth) {
                    [self tapAction];
                    
                }else{
                    [self showLeftWithAnimaTime:0.3];
                }

                break ;
                
            case kCameraMoveDirectionLeft:
                
//                NSLog (@ "Start moving left" );
                
                if (_leftBottomView.x > -kScreenWidth) {
                    [self tapAction];
                    
                }else{
                   [self showRightWithAnimaTime:0.3];
                }
                
                
                break ;
                
            default :
                
                break ;
                
        }
        
    }else if (gesture.state == UIGestureRecognizerStateEnded ) {
        
        // now tell the camera to stop
        
//        NSLog (@ "Stop" );
    }
    
}

// This method will determine whether the direction of the user's swipe
- ( CameraMoveDirection )determineCameraDirectionIfNeeded:(CGPoint)translation{
    
    if (direction != kCameraMoveDirectionNone)
        
        return direction;
    
    // determine if horizontal swipe only if you meet some minimum velocity
    
    if (fabs(translation.x) > gestureMinimumTranslation){
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0 ) gestureHorizontal = YES;
        
        else gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        
        if (gestureHorizontal){
            
            if (translation.x > 0.0 )
                
                return kCameraMoveDirectionRight;
            
            else
                
                return kCameraMoveDirectionLeft;
            
        }
        
    } // determine if vertical swipe only if you meet some minimum velocity
    else if (fabs(translation.y) > gestureMinimumTranslation){
        
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0 )
            
            gestureVertical = YES;
        
        else
            
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        
        if (gestureVertical){
            
            if (translation.y > 0.0 )
                
                return kCameraMoveDirectionDown;
            
            else
                
                return kCameraMoveDirectionUp;
            
        }
    }
    return direction;
}

/**
 出现左边视图
 */
- (void)showLeftWithAnimaTime:(CGFloat)time {
    
    [self.view bringSubviewToFront:self.leftBottomView];
    
    
    [self updataIcon:nil];
    
    [UIView animateWithDuration:time animations:^{
        
        _rightBottomView.x = kScreenWidth;
        _leftBottomView.x =  -85;
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _leftDistance = _leftBottomView.x;
        _bottomView.hidden = NO;
    }];
    
}
/**
 出现右边视图
 */
- (void)showRightWithAnimaTime:(CGFloat)time {
    
    [self.view bringSubviewToFront:self.rightBottomView];
    
    [UIView animateWithDuration:time animations:^{
        
        _leftBottomView.x = -kScreenWidth;
        _rightBottomView.x =  85;
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _rightDistance = _rightBottomView.x;
        _bottomView.hidden = NO;
    }];
}

//点击蒙版隐藏视图
- (void)tapAction {
    
    [UIView animateWithDuration:0.2 animations:^{
        _leftBottomView.x =  -kScreenWidth;
        _rightBottomView.x = kScreenWidth;
        _leftDistance = _leftBottomView.x;
        _rightDistance = _rightBottomView.x;
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        _bottomView.hidden = YES;
    }];
    
    
}

#pragma mark 添加子控制器
-(void) addChildViewController: (UIViewController *)childController andTitle:(NSString *)title andImageName: (NSString *)image addSeledImage:(NSString *)selectImage{
    
    childController.title = title;
    
    [childController.tabBarItem setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [childController.tabBarItem setSelectedImage:[[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:childController];
    
    [self addChildViewController:navVC];
}

@end
