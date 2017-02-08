//
//  GXPHKitTool.h
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/14.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


@class GXPhotoAssetModel;


@interface GXPHKitTool : NSObject

+ (GXPHKitTool *)sharedPHKitTool;

@property (nonatomic ,strong)PHImageManager * phManager;

//权限询问
//- (void)isAuthorizationWithResultBlock:(void(^)(PHAuthorizationStatus status))result;

//获取全部相册
-(void)getPhotoListDatasWithResultBlock:(void(^)(NSMutableArray <PHAssetCollection *>* groups))result;

//获取某个相册的结果集
-(PHFetchResult *)getFetchResult:(PHAssetCollection *)assetCollection;

//获取相应结果集下的照片资源
-(void)getPhotoAssets:(PHFetchResult *)fetchResult resultBlock:(void(^)(NSMutableArray <GXPhotoAssetModel*>*imageArray))result;

//获取相机胶卷下的照片资源
- (void)getCameraRollAssetsWithResultBlock:(void (^)(PHAuthorizationStatus status,NSArray<GXPhotoAssetModel *> *imageArray))result;

@end
