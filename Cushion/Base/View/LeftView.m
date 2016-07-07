//
//  LeftView.m
//  Cushion
//
//  Created by QUAN on 16/6/30.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "LeftView.h"
#import "ConnectViewController.h"

@interface LeftView ()

@property (weak, nonatomic) IBOutlet UIView *mesgView;

@end

@implementation LeftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"LeftView" owner:self options:nil] lastObject];
        
        self.frame = frame;
        
        self.mesgView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        
        
    }
    return self;
}

-(void) drawRect:(CGRect)rect{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"iconImage.png"]];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    if (img != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _iconImage.image = [UIImage imageWithContentsOfFile:filePath];
        });
    }
    
}

-(void) updataIconImage{
    
    [self setNeedsDisplay];
}

- (IBAction)clicoConnect:(id)sender {
    
    
}

- (IBAction)clickSettingBtn:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeGestures" object:nil];
    
    switch (sender.tag) {
        case 100:{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickInterface" object:@"Personal"];
            
        }
            break;
        case 200:{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickInterface" object:@"System"];
        }
            break;
        case 300:{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickInterface" object:@"Analysis"];
        }
            break;
        case 400:{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickInterface" object:@"SetUp"];
        }
            break;
            
        default:
            break;
    }
    
}

@end
