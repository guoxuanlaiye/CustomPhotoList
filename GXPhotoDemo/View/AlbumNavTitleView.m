//
//  CustomNavTitleView.m
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/6.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import "AlbumNavTitleView.h"
#define  RGBA_COLOR(R,G,B,A)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

@interface AlbumNavTitleView ()

@property (nonatomic ,strong)UIImageView * iconImgV;
@property (nonatomic ,strong)UIButton * clickButton;

@end

@implementation AlbumNavTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        
        [self setupView];
        
    }
    return self;
}
- (void)setupView
{
    UILabel * titleLab     = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
    titleLab.text          = @"照片";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font          = [UIFont systemFontOfSize:15.0];
    titleLab.textColor     = RGBA_COLOR(70, 70, 70, 1);
    [self addSubview:titleLab];
    
    UILabel *detailLab  = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 70, 20)];
    detailLab.textColor = [UIColor grayColor];
    detailLab.font      = [UIFont systemFontOfSize:13.0];
    detailLab.text      = @"相机胶卷";
    detailLab.textAlignment = NSTextAlignmentCenter;
    self.detailLab      = detailLab;
    [self addSubview:detailLab];
    
    UIImageView * iconImgV = [[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 15, 7)];
    iconImgV.image = [UIImage imageNamed:@"jiantou_xia"];
    self.iconImgV  = iconImgV;
    [self addSubview:iconImgV];
    
    UIButton * clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.frame = self.frame;
    self.clickButton  = clickButton;
    [clickButton addTarget:self action:@selector(clickButtonDid:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clickButton];
    
}
//点击头部按钮
- (void)clickButtonDid:(UIButton *)button
{
    button.selected = !button.selected;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (button.selected == YES) {
            self.iconImgV.transform = CGAffineTransformMakeRotation(M_PI);//旋转180度
            
        } else {
            self.iconImgV.transform = CGAffineTransformMakeRotation(M_PI*2);//旋转360度
            
        }
    }];
    self.navTitleButtonClick(button);
}
//选取后箭头翻转过来
- (void)rotationBack
{
    self.clickButton.selected = NO;
    self.iconImgV.transform   = CGAffineTransformMakeRotation(M_PI*2);//旋转360度
}
@end
