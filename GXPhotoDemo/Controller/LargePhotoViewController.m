//
//  LargePhotoViewController.m
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/5.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import "LargePhotoViewController.h"
#import "GXPhotoAssetModel.h"
#import "GXPHKitTool.h"
#import "UIView+Extension.h"
#define  RGBA_COLOR(R,G,B,A)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
#define SCREEN_W        ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_H        ([UIScreen mainScreen].bounds.size.height)

@interface LargePhotoViewController ()
@property (nonatomic ,strong)UIImageView * largeImgV;
@property (nonatomic, copy) NSString * isFullScreen;

@end

@implementation LargePhotoViewController
- (UIImageView *)largeImgV
{
    if (!_largeImgV) {
        
        CGFloat height = (SCREEN_W *_model.asset.pixelHeight)/_model.asset.pixelWidth;
        _largeImgV.userInteractionEnabled = YES;
        _largeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, height)];
    }
    return _largeImgV;
}
- (void)tapEvent:(UITapGestureRecognizer *)tapGes
{
//    NSLog(@"点击放大");
    _isFullScreen = [_isFullScreen isEqualToString:@"YES"] ? @"NO": @"YES";
    if ([_isFullScreen isEqualToString:@"YES"]) {
        //隐藏导航条和底部工具条
        self.navigationController.navigationBar.hidden = YES;
        
    } else {
        //显示导航条和底部工具条
        self.navigationController.navigationBar.hidden = NO;

    }
    //发送是否全屏展示的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"largePhotoFullNotification" object:nil userInfo:@{@"isFull":_isFullScreen}];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGBA_COLOR(40, 42, 47, 1);
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.largeImgV];
    
    CGFloat height = (SCREEN_W *_model.asset.pixelHeight)/_model.asset.pixelWidth;
    CGSize imgSize = CGSizeMake(SCREEN_W*2,height*2);
    
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    [[GXPHKitTool sharedPHKitTool].phManager requestImageForAsset:_model.asset
                                                       targetSize:imgSize
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:options
                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                        
        UIWindow * mainWindow = [UIApplication sharedApplication].keyWindow;
        self.largeImgV.image = result;
        self.largeImgV.centerY = (mainWindow.height)/2;
        self.largeImgV.centerX = self.view.centerX;
                                                        
                                                        
    }];

    
    
}


@end
