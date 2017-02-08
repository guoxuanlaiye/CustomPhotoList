//
//  CustomNavTitleView.h
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/6.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumNavTitleView : UIView

@property (nonatomic ,strong)UILabel * detailLab;

@property (nonatomic ,copy)void (^navTitleButtonClick)(UIButton * button);

- (void)rotationBack;

@end
