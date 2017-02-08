//
//  LargePhotoPageViewController.h
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/5.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargePhotoPageViewController : UIViewController
//已选的图片数组
@property (nonatomic ,strong)NSMutableArray * selectedImgArray;

@property (nonatomic ,strong)NSMutableDictionary * allImgDict;

@property (nonatomic ,strong)NSMutableArray * allDateArray;

@property (nonatomic ,strong)NSIndexPath * indexPath;
//回调已选照片数组
@property (nonatomic ,copy)void (^largePhotoBlock)(NSMutableArray * selectedArray);
//回调开始写记忆
@property (nonatomic ,copy)void (^largePhotoWriteBlock)();

@end
