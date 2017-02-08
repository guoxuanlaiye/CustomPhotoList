//
//  LargePhotoViewController.h
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/5.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXPhotoAssetModel;

@interface LargePhotoViewController : UIViewController
@property (nonatomic ,strong)NSIndexPath * indexPath;
@property (nonatomic ,strong)GXPhotoAssetModel * model;

@end
