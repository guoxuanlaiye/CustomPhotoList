//
//  AlbumCollectionViewCell.h
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/4.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXPhotoAssetModel;

@interface AlbumCollectionViewCell : UICollectionViewCell
//照片
@property (nonatomic ,strong)UIButton * photoButton;


//为了记住选中状态
@property (nonatomic ,assign)BOOL isSelected;

@property (nonatomic ,strong)GXPhotoAssetModel * assetModel;
//单个点击选择
@property (nonatomic ,copy)void (^albumCellSelectBlock)(GXPhotoAssetModel * model,UIButton * isSelectBtn);

@end
