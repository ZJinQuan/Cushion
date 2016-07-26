//
//  PersonalViewController.m
//  Cushion
//
//  Created by QUAN on 16/7/4.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "PersonalViewController.h"
#import "HttpTool.h"
#import "AFHTTPSessionManager.h"

@interface PersonalViewController ()<UIAlertViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *genderLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (nonatomic, strong) UIImagePickerController *imgPicker;
@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"iconImage.png"]];

    if ([UIImage imageWithContentsOfFile:filePath] != nil) {
        _iconImage.image = [UIImage imageWithContentsOfFile:filePath];
    }

    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [userdefaults objectForKey:@"username"];
    NSString *phone = [userdefaults objectForKey:@"user_phone"];
    NSString *image = [userdefaults objectForKey:@"user_url"];
    NSString *sex = [userdefaults objectForKey:@"user_sex"];
    NSString *age = [userdefaults objectForKey:@"user_age"];
    
    
    NSLog(@"%@\n%@\n%@\n%@\n%@", name, phone, image, sex, age);
}

- (IBAction)clickEditBtn:(UIButton *)sender {
    
    switch (sender.tag) {
        case 111:{
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
            sheet.tag = 1001;
            [sheet showInView:self.view];
            
        }
            break;
        case 222:{

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入昵称" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];

            alert.tag = 222;
            
            [alert show];
            
        }
            break;
        case 333:{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypePhonePad;
            
            alert.tag = 333;
            [alert show];
            
        }
            break;
        case 444:{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入年龄" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
            
            alert.tag = 444;
            [alert show];
            
        }
            break;
        case 555:{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入性别" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            alert.tag = 555;
            [alert show];
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0: {  //相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                // 呈现图库
                [self presentViewController:_imgPicker animated:YES completion:nil];
            }
        }
            break;
        case 1: { //拍照
            // 调用摄像头
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                // 呈现图库
                [self presentViewController:_imgPicker animated:YES completion:nil];
            }
        }
            break;
        default:
            break;
    }
    
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UITextField *text=[alertView textFieldAtIndex:0];
    
    switch (alertView.tag) {
        case 222:{
            
            if (text.text.length > 1) {
                
                _nameLab.text = text.text;
                
                NSString *Userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_userId"];
                
                NSString *url = BaseUrl@"userupdateUserName";
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                
                [params setObject:text.text forKey:@"username"];
                [params setObject:Userid forKey:@"id"];

                
                [[HttpTool sharedManager] GET:url params:params result:^(id responseObj, NSError *error) {
                    
                    NSDictionary * dict = responseObj;
                    
                    NSLog(@"%@",(NSDictionary *)responseObj[@"message"]);
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"username"] forKey:@"username"];
                    
                }];

                
//                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//                manager.responseSerializer = [AFJSONResponseSerializer serializer];
//                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//                
//                [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//                
//                [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
//                    
//                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                    
//                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//                    
//                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"username"] forKey:@"username"];
//                    
//                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                    
//                }];
                
                
                
            }
            
        }
            break;
        case 333:{
            
            if (text.text.length > 1) {
                
                _phoneNum.text = text.text;
            }
            
        }
            break;
        case 444:{
            
            if (text.text.length > 1) {
                
                _ageLab.text = text.text;
            }
        }
            break;
        case 555:{
            
            if (text.text.length > 1) {
                
                _genderLab.text = text.text;
            }
        }
            break;
            
        default:
            break;
    }
    
    
    

}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        

        UIImage *newImage = [self fixOrientation:image];
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中
        NSData *data ;
        
        if (UIImagePNGRepresentation(newImage) == nil) {
            data = UIImageJPEGRepresentation(newImage, 1);
        } else {
            data = UIImagePNGRepresentation(newImage);
        }
        
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/iconImage.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath, @"/iconImage.png"];

        _iconImage.image = [UIImage imageWithContentsOfFile:filePath];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
