//
//  MyViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/27.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "MyViewController.h"
#import "ThatDayCell.h"
#import "ChartCell.h"
#import "WhoShockViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "MyShareCell.h"

@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,XSChartDataSource,XSChartDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property(nonatomic,strong)NSArray *data;

@property (nonatomic, strong) AppDelegate *app;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _app = kAppDelegate;
    
    //移除手势
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickShock) name:@"ShockMe" object:nil];
    
    _data=@[@1,@6,@3,@4,@9,@6,@12];
    
    [self.messageTableView registerNib:[UINib nibWithNibName:@"MyShareCell" bundle:nil] forCellReuseIdentifier:@"myShareCell"];
    [self.messageTableView registerNib:[UINib nibWithNibName:@"ThatDayCell" bundle:nil] forCellReuseIdentifier:@"thatDayCell"];
    [self.messageTableView registerNib:[UINib nibWithNibName:@"ChartCell" bundle:nil] forCellReuseIdentifier:@"chartCell"];
}

-(void) clickShare{

    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到朋友圈",@"分享给微信好友", nil];
    [action showInView:self.view];
    
}

- (void)clickShock {
    
    WhoShockViewController *whoVC = [[WhoShockViewController alloc] init];
    whoVC.title = @"谁震了我";
    
    [self.navigationController pushViewController:whoVC animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            
            [self shareWeiXin:1 andImage:[self captureScrollView:_messageTableView]];
        }
            break;
        case 1:
            [self shareWeiXin:0 andImage:[self captureScrollView:_messageTableView]];
            break;
            
        default:
            break;
    }
    
}

//截屏
- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}

-(void) shareWeiXin:(int) scene andImage: (UIImage *) image{
    
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;
    sendReq.scene = scene;
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];

    WXImageObject *imageObj = [WXImageObject object];
    
    UIImage *shareImage = image;
    
    NSData *data ;
    
    if (UIImagePNGRepresentation(shareImage) == nil) {
        data = UIImageJPEGRepresentation(shareImage, 1);
    } else {
        data = UIImagePNGRepresentation(shareImage);
    }
    
    imageObj.imageData = data;
    
    //完成发送对象实例
    urlMessage.mediaObject = imageObj;
    
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
}

#pragma mark XSChartDataSource and XSChartDelegate

-(NSInteger)numberForChart:(XSChart *)chart
{
    return _data.count;
}
-(NSInteger)chart:(XSChart *)chart valueAtIndex:(NSInteger)index
{
    return [_data[index] floatValue];
}
-(BOOL)showDataAtPointForChart:(XSChart *)chart
{
    return YES;
}
-(NSString *)chart:(XSChart *)chart titleForXLabelAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%ld",(long)index];
}
-(NSString *)titleForChart:(XSChart *)chart
{
    return @"正常坐姿占比曲线图";
}
-(NSString *)titleForXAtChart:(XSChart *)chart
{
    return nil;
}
-(NSString *)titleForYAtChart:(XSChart *)chart
{
    return nil;
}
-(void)chart:(XSChart *)view didClickPointAtIndex:(NSInteger)index
{
    NSLog(@"click at index:%ld",(long)index);
}


#pragma mark UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 150;
    }
    
    return 200;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    btn.centerX = view.centerX;
    btn.centerY = view.centerY;
    
    [btn setTitle:@"分享到微信" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:RGBA(8, 167, 23, 1) forState:UIControlStateNormal];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = RGBA(8, 167, 23, 1).CGColor;
    btn.layer.cornerRadius = 5;
    
    [btn addTarget:self action:@selector(clickShare) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];

    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            
            MyShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myShareCell"];
            
            cell.timeLab.text = _app.currentTime;
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"iconImage.png"]];
            
            if ([UIImage imageWithContentsOfFile:filePath] != nil) {
                cell.iconImage.image = [UIImage imageWithContentsOfFile:filePath];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }
            break;
        case 1:{
            
            ThatDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thatDayCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }
            break;
            
        case 2:{
            
            ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chartCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.chart.dataSource = self;
            cell.chart.delegate = self;
            
            return cell;
            
        }
            break;
            
        default:
            break;
    }

    return nil;
}



@end
