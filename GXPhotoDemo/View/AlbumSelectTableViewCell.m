//
//  AlbumSelectTableViewCell.m
//  RememberTime
//
//  Created by 郭轩 on 16/11/29.
//  Copyright © 2016年 yingcan. All rights reserved.
//

#import "AlbumSelectTableViewCell.h"
#import "GXPHKitTool.h"
@interface AlbumSelectTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *groupImgV;
@property (weak, nonatomic) IBOutlet UILabel *groupTitle;
@property (weak, nonatomic) IBOutlet UILabel *groupPhotoCount;

@end

@implementation AlbumSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)createAlbumSelectTableViewCellWithTableView:(UITableView *)tableView
{

    return [[[NSBundle mainBundle]loadNibNamed:@"AlbumSelectTableViewCell" owner:nil options:nil] lastObject];

}
- (void)setGroupCellWithGroup:(PHAssetCollection *)group
{
    
    self.groupTitle.text = [NSString stringWithFormat:@"%@",group.localizedTitle];
    
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    // 同步获得图片, 只会返回1张图片
//    options.synchronous = YES;
    
    PHFetchResult <PHAsset *>* assets = [PHAsset fetchAssetsInAssetCollection:group options:nil];
    
    // 从asset中获得图片
    [[GXPHKitTool sharedPHKitTool].phManager requestImageForAsset:[assets firstObject] targetSize:CGSizeZero contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        self.groupImgV.image = result;
    }];
    
    self.groupPhotoCount.text = [NSString stringWithFormat:@"(%zd)",assets.count];

}

@end
