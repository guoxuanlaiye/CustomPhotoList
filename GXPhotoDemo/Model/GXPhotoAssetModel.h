//
//  GXPhotoAssetModel.h
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/4.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface GXPhotoAssetModel : NSObject
/**
 照片拍摄日期
 */
@property (nonatomic ,copy)NSString * dateStr;
//照片本地url (AssetsLibrary框架下用到)
//@property (nonatomic ,copy)NSURL * imageUrl;
//长宽 (AssetsLibrary框架下用到)
//@property (nonatomic ,assign)CGSize dimension;
/**
 image
 */
@property (nonatomic ,strong)UIImage * image;
/**
 全路径
 */
@property (nonatomic ,copy) NSString * fullObjectKey;
/**
 网络url
 */
@property (nonatomic ,copy) NSString * netUrl;
/**
 照片资源
 */
@property (nonatomic ,strong)PHAsset * asset;

@end
