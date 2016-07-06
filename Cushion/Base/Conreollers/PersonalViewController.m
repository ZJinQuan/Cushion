//
//  PersonalViewController.m
//  Cushion
//
//  Created by QUAN on 16/7/4.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "PersonalViewController.h"

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
        

        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //把刚刚图片转换的data对象拷贝至沙盒中
        NSData *data ;
        
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 1);
            
        } else {
            
            data = UIImagePNGRepresentation(image);
        }
        
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/iconImage.png"] contents:data attributes:nil];
        
        
        //得到选择后沙盒中图片的完整路径
        NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath, @"/iconImage.png"];
        
        _iconImage.image = [UIImage imageWithContentsOfFile:filePath];
        
        NSLog(@"%@",filePath);
    
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

@end
