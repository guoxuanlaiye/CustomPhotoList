//
//  AlbumDateHeaderView.h
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/4.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXPhotoAssetModel;

@interface AlbumDateHeaderView : UICollectionViewCell
//全选按钮
@property (nonatomic ,strong)UIButton * allSelectButton;

@property (nonatomic ,copy)NSString * dateStr;
//记录是否是全选状态
@property (nonatomic ,assign)BOOL isAllSelect;

//当前全选按钮所在的section
@property (nonatomic ,assign)NSInteger headerSection;
//全选回调
@property (nonatomic ,strong)void (^allSelectBlock)(NSInteger section,UIButton * isAllSelectBtn);

@end
