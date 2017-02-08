//
//  GXPHKitTool.m
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/14.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import "GXPHKitTool.h"
#import "GXPhotoAssetModel.h"

@interface GXPHKitTool ()
@property (nonatomic ,strong)NSMutableArray * tmpImageArray;

@end

@implementation GXPHKitTool

+ (GXPHKitTool *)sharedPHKitTool
{
    static GXPHKitTool * instancePHTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instancePHTool = [[GXPHKitTool alloc]init];
    });
    return instancePHTool;
}
- (PHImageManager *)phManager
{
    if (!_phManager) {
        _phManager = [[PHImageManager alloc]init];
    }
    return _phManager;
}

- (NSMutableArray *)tmpImageArray
{
    if (!_tmpImageArray) {
        _tmpImageArray = [NSMutableArray array];
    }
    return _tmpImageArray;
}

- (void)isAuthorizationWithResultBlock:(void(^)(PHAuthorizationStatus status))result
{

    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) { //未授权
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) { //弹窗询问
            
            result(status);
           
        }];
    
    } else {
        
        result([PHPhotoLibrary authorizationStatus]);
    }
}

#pragma mark - 获取全部相册列表
- (void)getPhotoListDatasWithResultBlock:(void (^)(NSMutableArray<PHAssetCollection *> *))result
{
    
    [self isAuthorizationWithResultBlock:^(PHAuthorizationStatus status) {
       
        if (status == PHAuthorizationStatusAuthorized) { //已授权
            
            NSMutableArray *dataArray = [NSMutableArray array];
            //获取资源时的参数，为nil时则是使用系统默认值
//            PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
            
            //列出所有的智能相册
            PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            
            for (PHAssetCollection * smart in smartAlbumsFetchResult) {
                
                PHFetchResult * res = [self getFetchResult:smart];
                
                if (res.count > 0) {  //去除照片个数为0的结果集
                    
                    [dataArray addObject:smart];

                }
            }
            NSLog(@"smart.count = %zd",dataArray.count);
            
            //列出所有用户创建的相册
            PHFetchResult *smartAlbumsFetchResult1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum | PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];

            //遍历
            for (PHAssetCollection *sub in smartAlbumsFetchResult1) {
                [dataArray addObject:sub];
            }
            
            NSLog(@"count = %zd",dataArray.count);

            result(dataArray);
        } else {
            
            result(nil);
        }
        
    }];
   
}
-(PHFetchResult *)getFetchResult:(PHAssetCollection *)assetCollection{
    
    //只读取照片内容
    PHFetchOptions *option  = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    //获取某个相册的结果集
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    return fetchResult;
}
#pragma mark - 获取相应相簿下的照片
-(void)getPhotoAssets:(PHFetchResult *)fetchResult resultBlock:(void(^)(NSMutableArray <GXPhotoAssetModel*>*imageArray))result
{
    
    [self isAuthorizationWithResultBlock:^(PHAuthorizationStatus status) {

        if (status == PHAuthorizationStatusAuthorized) { //已授权
            
            for (PHAsset *asset in fetchResult) {
                //只添加图片类型资源，去除视频类型资源
                //当mediatype == 2时，之歌资源则视为视频资源
                //        NSLog(@"%ld",asset.mediaSubtypes);
                if (asset.mediaSubtypes == 0) {
                    [self setupAssetsDataWithALAsset:asset];
                }
            }
            result(self.tmpImageArray);
            [self.tmpImageArray removeAllObjects];
            
        } else {
            
            result(nil);
        }
        
    }];
}


#pragma mark - 获取相机胶卷下的照片资源
- (void)getCameraRollAssetsWithResultBlock:(void (^)(PHAuthorizationStatus status,NSArray<GXPhotoAssetModel *> *imageArray))result
{
    
    [self isAuthorizationWithResultBlock:^(PHAuthorizationStatus status) {
       
        if (status == PHAuthorizationStatusAuthorized) { //已授权
    
            dispatch_async(dispatch_get_main_queue(), ^{
               
                PHFetchOptions * fetchOptions = [[PHFetchOptions alloc]init];
                PHFetchResult * smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
                PHFetchResult * fetch = [PHAsset fetchAssetsInAssetCollection:[smartAlbumsFetchResult objectAtIndex:0] options:nil];
                
                for (PHAsset * asset in fetch) {
                    [self setupAssetsDataWithALAsset:asset];
                }
                
                result(status,self.tmpImageArray);
                [self.tmpImageArray removeAllObjects];
                
            });
           
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                result(status,nil);
            });
        }
    
    }];
    
}
- (void)setupAssetsDataWithALAsset:(PHAsset *)result
{
    GXPhotoAssetModel * model = [[GXPhotoAssetModel alloc]init];
    
    NSDate * date = result.creationDate;
    model.dateStr = [date.description substringToIndex:10];
    
    model.asset   = result;
    
    [self.tmpImageArray addObject:model];
    
}


@end
