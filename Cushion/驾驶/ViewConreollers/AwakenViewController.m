//
//  AwakenViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/24.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "AwakenViewController.h"

#import "FaceLandTrack.hpp"

#import <MobileCoreServices/MobileCoreServices.h>

#import "LVECatpureSessionHelper.h"

#import "YDGLOperationKit.h"

#import <mach/mach_time.h>

static int width_s=480;
static int height_s=640;

@interface AwakenViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property(nonatomic)LVECatpureSessionHelper *captureSessionHelper;
@property(nonatomic)dispatch_queue_t captureQueue;

@property(nonatomic)YDGLOperationNodeDisplayView *displayView;
//摄像头图层
//视频格式是NV12的,大小是480*640的
@property(nonatomic)YDGLOperationCVPixelBufferSourceNode *captureSource;
@property(nonatomic)YDGLOperationNodeLayer *captureLayer;

//人脸识别图层,用来绘制识别的点的
@property(nonatomic)YDGLOperationCGContextSourceNode *drawableSource;
@property(nonatomic)YDGLOperationNodeLayer *drawableLayer;


@end

@implementation AwakenViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //移除手势通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    
//    _captureSessionHelper=[[LVECatpureSessionHelper alloc]init];
//    
//    _displayView=[[YDGLOperationNodeDisplayView alloc]initWithFrame:_videoView.bounds];
//    
//    [self.videoView addSubview:_displayView];
//    
//    [self buildLayers];
//    
//    [_displayView setContentProviderNode:self.captureLayer];
//    
//    _captureQueue=dispatch_queue_create([@"拍摄线程" UTF8String], DISPATCH_QUEUE_SERIAL);
//    
//    [_captureSessionHelper setSampleBufferDelegate:self queue:_captureQueue];
//    
//    [YDGLOperationContext pushContext];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
//    [_captureSessionHelper startRunning];
    
}

//-(void)dealloc{
//    
//    [_captureSessionHelper stopRunning];
//    
//    NSLog(@"视频测试页面已经销毁了");
//    
//    [self.captureSource destory];
//    [self.captureLayer destory];
//    [self.drawableLayer destory];
//    [self.drawableSource destory];
//    
//    [self.displayView removeFromSuperview];
//    
//    [YDGLOperationContext popContext];
//    
//}
//
//-(void)buildLayers{
//    
//    self.captureSource=[YDGLOperationCVPixelBufferSourceNode new];
//    
//    self.captureLayer=[YDGLOperationNodeLayer new];
//    
//    [self.captureLayer addDependency:self.captureSource];
//    
//    //self.drawableSource=[[YDGLOperationCGContextSourceNode alloc]initWithSize:CGSizeMake(480, 640)];
//    
//    self.drawableSource=[[YDGLOperationCGContextSourceNode alloc]initWithSize:CGSizeMake(width_s, height_s)];
//    
//    self.drawableLayer=[YDGLOperationNodeLayer new];
//    
//    [self.drawableLayer addDependency:self.drawableSource];
//    
//    //  self.drawableLayer.frame=CGRectMake(0, 0, 480, 640);
//    self.drawableLayer.frame=CGRectMake(0, 0, width_s,height_s);
//    
//    [self.captureLayer addSubNodeLayer:self.drawableLayer];
//    
//}
//
//
//#pragma -mark 系统SDK输出视频数据
//
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
//    
//    CVImageBufferRef imageBufferRef=CMSampleBufferGetImageBuffer(sampleBuffer);
//    
//    CVPixelBufferLockBaseAddress(imageBufferRef, 0);
//    
//    NSMutableArray<NSValue*>*points=[self getFaceRectAndPoints:imageBufferRef];
//    
//    //TODO:在这里进行绘制识别出来的点,context的(0,0)是手机屏幕左下角
//    [self.drawableSource commitCGContextTransaction:^(CGContextRef _Nonnull context) {
//        
//        CGContextRotateCTM(context, M_PI);
//        CGContextScaleCTM(context, -1,1);
//        CGContextTranslateCTM(context, 0, -(int)CGBitmapContextGetHeight(context));
//        
//        
//        CGMutablePathRef path=CGPathCreateMutable();
//        
//        //绘制人脸区域
//        CGRect faceRect=[points firstObject].CGRectValue;
//        
//        CGContextAddRect(context, faceRect);
//        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
//        
//        CGContextDrawPath(context, kCGPathStroke);
//        
//        [points removeObject:points.firstObject];
//        
//        //drawRect()；
//        
//        
//        for (NSValue *value in points){
//            
//            CGPoint point=value.CGPointValue;
//            
//            CGPathAddArc(path,NULL,point.x,point.y, 3.0,0,2*M_PI, 0);
//            
//            CGPathCloseSubpath(path);
//            
//        }
//        
//        CGContextAddPath(context, path);
//        
//        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
//        
//        CGContextDrawPath(context, kCGPathFill);
//        
//    }];
//    
//    [self.drawableSource start];
//    
//    [self.captureSource uploadCVPixelBuffer:imageBufferRef];
//    
//    [self.captureSource start];
//    
//    [self.captureSource setNeedDisplay];
//    
//    CVPixelBufferUnlockBaseAddress(imageBufferRef, 0);
//    
//}
//
//#pragma -mark 人脸识别
//
//
//BOOL initReadModel()
//{
//    //  printf("模型初始化begin------\n");
//    BOOL iisok=FaceAlignInit_ColorReco();
//    if(iisok==TRUE)
//    {
//        printf("模型初始化成功\n");
//    }
//    else
//    {
//        printf("模型初始化failed\n");
//        
//    }
//    return TRUE;
//}
////initReadModel();
//static BOOL  initflag = FALSE;
//static BOOL  isneed = TRUE;
//static float landmark[68*2];
//
////TODO:在这里进行人脸识别
//
///**
// *  @author 9527, 16-05-16 13:50:32
// *
// *  通过pixelBuffer 进行人脸识别
// *
// *  @param pixelBuffer 摄像头返回的视频数据,格式是NV12的,目前的大小是480*640的
// *
// *  @return NSMutableArray 第一个数组元素是人脸的CGRect,之后的数组元素是识别的点CGPoint,坐标也是需要注意的,绘制代码是以屏幕左下角为原点的(0,0)
// *
// *  @since 1.0.0
// */
//-(NSMutableArray<NSValue*>*)getFaceRectAndPoints:(CVPixelBufferRef)pixelBuffer
////landtrack version
//{
//    //float GetEyeStatus(unsigned char *gray_image_data,int width,int height,float *landmark,float lefteye,float righteye);
//    
//    float eyestatus[2];
//    if(initflag==FALSE)
//    {
//        initReadModel();
//        initflag=TRUE;
//        printf("*****Init Done\n");
//    }
//    float pose[3];
//    int facebox[100];
//    unsigned char *ptr_image=CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
//    
//    if(isneed == TRUE)
//    {
//        
//        memset(facebox,0,sizeof(int)*100);
//        FaceDetect_ColorReco(ptr_image, width_s, height_s, facebox);
//        if(facebox[0]>=1)
//        {
//            float score=FaceAlignProcess_ColorReco(ptr_image,width_s,height_s,facebox+1,landmark,pose);
//            
//            NSLog(@"=========----Detection get score is %f\n",score);
//            
//            if(score>-1.5f)
//            {
//                isneed=FALSE;
//            }
//            else
//            {
//                isneed=TRUE;
//            }
//        }
//        
//    }
//    else
//    {
//        float score=FaceAlignTrackProcess_ColorReco(ptr_image,width_s,height_s,facebox,landmark,pose);
//        // NSLog(@"+++++++Tracking get score is %f \n,score");
//        
//        float sum22=GetEyeStatus(ptr_image,width_s,height_s,landmark,eyestatus);
//        
//        NSLog(@"++++++++----Tracking get score is %f and eye status is %f\n",score,sum22);
//        
//        if(score>-1.5f)
//        {
//            isneed=FALSE;
//        }
//        else
//        {
//            isneed=TRUE;
//        }
//    }
//
//    if(isneed==TRUE)
//    {
//        memset(landmark,0,sizeof(float)*68*2);
//    }
//    //printf("We get Land pos is %f  %f\n",landmark[0],landmark[1]);
//    
//    //DLog("Detect face num is %d\n",facebox[0]);
//    NSMutableArray<NSValue*>*points=[NSMutableArray array];
//    
//    
//    //   [points addObject:[NSValue valueWithCGRect:CGRectMake(facebox[1], 100+640-facebox[2], facebox[3], 640-facebox[4])]];
//    [points addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, 0, 1)]];
//    
//    
//    
//    for(int iland=0;iland<68;iland++)
//    {
//        [points addObject:[NSValue valueWithCGPoint:CGPointMake(landmark[2*iland],landmark[2*iland+1])]];
//        // [points addObject:[NSValue valueWithCGPoint:CGPointMake(0,0)]];
//    }
//    
//    return points;
//    
//}
//

- (IBAction)clickCallNavigation:(UIButton *)sender {
    

}

@end
