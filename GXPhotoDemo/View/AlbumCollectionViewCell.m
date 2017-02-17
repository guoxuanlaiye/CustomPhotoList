//
//  AlbumCollectionViewCell.m
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/4.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import "AlbumCollectionViewCell.h"
#import "GXPhotoAssetModel.h"
#import "GXPHKitTool.h"

#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)

@interface AlbumCollectionViewCell ()
@property (nonatomic ,strong)UIButton * selectButton;

@end

@implementation AlbumCollectionViewCell
- (void)dealloc
{

}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];

        //图片按钮，点击进入大图预览模式
        UIButton * photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.frame      = self.bounds;
        [photoBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
        photoBtn.imageView.clipsToBounds = YES;
        photoBtn.userInteractionEnabled  = NO;
        self.photoButton    = photoBtn;
        [self.contentView addSubview:photoBtn];
        
        //选择按钮
        UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame      = CGRectMake(photoBtn.frame.size.width-40, 0, 40, 40);
        [selectBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"xuanzhong_hui"] forState:UIControlStateNormal];
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"xuanzhong_lv"] forState:UIControlStateSelected];


        [selectBtn addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.selectButton    = selectBtn;
        [self.contentView addSubview:selectBtn];
        
    }
    return self;
}
#pragma mark - 是否被选中
- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.selectButton.selected = isSelected;
}

- (void)setAssetModel:(GXPhotoAssetModel *)assetModel
{
    _assetModel = assetModel;
    
    CGSize imgSize = CGSizeMake(((SCREEN_W-5)/4)*2, ((SCREEN_W-5)/4)*2);
    
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    [[GXPHKitTool sharedPHKitTool].phManager requestImageForAsset:assetModel.asset
                                                       targetSize:imgSize
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:options
                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                        
                                                        [self.photoButton setImage:result forState:UIControlStateNormal];
                                                        
                                                        
                                                    }];

}
#pragma mark - 选择按钮被点击
- (void)selectButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    _albumCellSelectBlock(_assetModel,button);
}

@end
