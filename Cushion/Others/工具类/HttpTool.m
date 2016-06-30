//
//  HttpTool.m
//  Cushion
//
//  Created by QUAN on 16/6/29.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"

@interface HttpTool (){
    //HTTP请求管理器
    AFHTTPSessionManager *manager;
}
@end

@implementation HttpTool

//单例
+ (HttpTool *)sharedManager
{
    static HttpTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HttpTool alloc] init];
        
    });
    return instance;
}

//初始化
- (instancetype)init
{
    if (self = [super init]) {
        
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 15;
        
    }
    return self;
}

//隐藏加载
- (void)hideHUD
{
    [self.hud hide:YES];
}

//GET请求
-(void)GET:(NSString *)url params:(id)params result:(ResultBlock)resultBlock
{
//    manager.requestSerializer.timeoutInterval = 30;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //获取到data数组
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@ %@",url, params);
        
        NSLog(@"===%@===", dict);
        
        if (resultBlock) {
            
            resultBlock(dict, nil);

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        //回传错误信息
        if (resultBlock) {
            
            resultBlock(nil, error);

        }
        
    }];
    
}


//POST请求
- (void)POST:(NSString *)url params:(id)params result:(ResultBlock)resultBlock
{
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@  %@",url, params);
        
        NSLog(@"===%@", responseObject);
        
        NSDictionary * dict = responseObject;
        //        NSArray * dataArr = dict[@"resultData"];
        if(resultBlock){
            
            resultBlock(dict, nil);
            
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            
            [MBProgressHUD hideAllHUDsForView:app.window animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        if (resultBlock) {
            
            resultBlock(nil, error);
            
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            
            [MBProgressHUD hideAllHUDsForView:app.window animated:YES];
        }
        
    }];
    
}

- (void)POSTImage:(NSString *)url params:(id)params image:(UIImage *)image result:(ResultBlock)resultBlock
{
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // jpg图片转二进制
        NSData *iconData = UIImageJPEGRepresentation(image, 0.5);
        
        //如果你的图片本身就是2进制的NSData形式，那么可以判断第一个字节得出类型：
        uint8_t c;
        NSString * mimeType;
        [iconData getBytes:&c length:1];
        switch (c) {
                
            case 0xFF:
                
                mimeType = @"image/jpeg";
                break;
            case 0x89:
                
                mimeType = @"image/png";
                break;
            case 0x47:
                
                mimeType = @"image/gif";
                break;
            case 0x4D:
                
                mimeType = @"image/tiff";
                break;
            default:
                break;
        }
        // 拼装Body
        [formData appendPartWithFileData:iconData name:@"headimage" fileName:[NSString stringWithFormat:@"photo.jpg"] mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = responseObject;
        NSLog(@"dict = %@", dict);
        
        if(resultBlock){
            
            resultBlock(dict, nil);
            
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            
            [MBProgressHUD hideAllHUDsForView:app.window animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error == %@", error);
        
        if (resultBlock) {
            
            resultBlock(nil, error);
            
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            
            [MBProgressHUD hideAllHUDsForView:app.window animated:YES];
        }
        
        
    }];
    
}

#pragma mark-- 头像上传
//- (void)me_UpdateHeadImageWithFileData:(NSData *)data parame:(id)parem imageName:(NSString *)imageName callBack:(ResultBlock)block errorBack:(ResultBlock)errorBack  {
//    NSString *urlString=[NSString stringWithFormat:BaseUrl@"userupdateUserIn"];
//    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
//    [manager POST:urlString parameters:parem constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSString *newImageName = [NSString stringWithFormat:@"%@.png",imageName];
//        [formData appendPartWithFileData:data name:@"doc" fileName:newImageName mimeType:@"image/png"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        block(responseObject, nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        errorBack(nil, error);
//
//    }];
//}

@end
