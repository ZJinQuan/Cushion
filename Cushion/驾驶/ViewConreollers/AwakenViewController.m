//
//  AwakenViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/24.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "AwakenViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AwakenViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDevice *_audioDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureDeviceInput *_audioInput;
    AVCaptureMovieFileOutput *_movieOutput;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
}

@property (weak, nonatomic) IBOutlet UIView *videoView;

@end

@implementation AwakenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    [self getAuthorization];
}

//获取授权
- (void)getAuthorization{
    
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        case AVAuthorizationStatusAuthorized:       //已授权，可使用
        {
            NSLog(@"授权摄像头使用成功");
            [self setupAVCaptureInfo];
            break;
        }
        case AVAuthorizationStatusNotDetermined:    //未进行授权选择
        {
            //则再次请求授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){    //用户授权成功
                    [self setupAVCaptureInfo];
                    return;
                } else {        //用户拒绝授权
                    [self pop];
                    [self showMsgWithTitle:@"出错了" andContent:@"用户拒绝授权摄像头的使用权,返回上一页.请打开\n设置-->隐私/通用等权限设置"];
                    return;
                }
            }];
            break;
        }
        default:   //用户拒绝授权/未授权
        {
            [self pop];
            [self showMsgWithTitle:@"出错了" andContent:@"拒绝授权,返回上一页.请检查下\n设置-->隐私/通用等权限设置"];
            break;
        }
    }
    
}

- (void)setupAVCaptureInfo{
 
    [self addSession];
    
    [_captureSession beginConfiguration];
    
    [self addVideo];
    [self addPreviewLayer];
    
    [_captureSession commitConfiguration];
    [_captureSession startRunning];
}

- (void)addSession
{
    _captureSession = [[AVCaptureSession alloc] init];
    
    //设置视频分辨率
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
}

- (void)addVideo{

    _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];
    
    [self addVideoInput];
    [self addMovieOutput];
}

#pragma mark 获取摄像头-->前/后
- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position{
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

- (void)addVideoInput
{
    NSError *videoError;
    
    // 视频输入对象
    // 根据输入设备初始化输入对象，用户获取输入数据
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&videoError];
    if (videoError) {
        NSLog(@"---- 取得摄像头设备时出错 ------ %@",videoError);
        return;
    }
    
    // 将视频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    
}

- (void)addMovieOutput
{
    // 拍摄视频输出对象
    // 初始化输出设备对象，用户获取输出数据
    _movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    if ([_captureSession canAddOutput:_movieOutput]) {
        [_captureSession addOutput:_movieOutput];
        AVCaptureConnection *captureConnection = [_movieOutput connectionWithMediaType:AVMediaTypeVideo];
        
        // 视频稳定设置
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        captureConnection.videoScaleAndCropFactor = captureConnection.videoMaxScaleAndCropFactor;
    }
    
}

- (void)addPreviewLayer{
    
    [self.view layoutIfNeeded];
    
    // 通过会话 (AVCaptureSession) 创建预览层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _captureVideoPreviewLayer.frame = self.view.layer.bounds;

    //有时候需要拍摄完整屏幕大小的时候可以修改这个
//    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 如果预览图层和视频方向不一致,可以修改这个
    _captureVideoPreviewLayer.connection.videoOrientation = [_movieOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation;
    _captureVideoPreviewLayer.position = CGPointMake(self.view.width*0.5,self.videoView.height*0.5);
    
    // 显示在视图表面的图层
    CALayer *layer = self.videoView.layer;
    layer.masksToBounds = true;
    [self.view layoutIfNeeded];
    [layer addSublayer:_captureVideoPreviewLayer];
    
}

-(void)pop{
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showMsgWithTitle:(NSString *)title andContent:(NSString *)content{
    
    [[[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

- (IBAction)clickCallNavigation:(UIButton *)sender {
    

}

@end
