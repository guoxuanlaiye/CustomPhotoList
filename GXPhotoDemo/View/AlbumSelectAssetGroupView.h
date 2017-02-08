//
//  AlbumSelectGroupView.h
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/6.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetsLibrary/AssetsLibrary.h"
#import <Photos/Photos.h>
@interface AlbumSelectAssetGroupView : UIView

//- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic ,copy)void (^selectALGroupBlock)(PHAssetCollection * group,NSString * groupName);

- (void)showGroupListView;

- (void)hideGroupListView;

@end
