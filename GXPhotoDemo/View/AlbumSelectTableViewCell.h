//
//  AlbumSelectTableViewCell.h
//  RememberTime
//
//  Created by 郭轩 on 16/11/29.
//  Copyright © 2016年 yingcan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetsLibrary/AssetsLibrary.h"
#import <Photos/Photos.h>
@interface AlbumSelectTableViewCell : UITableViewCell

+ (instancetype)createAlbumSelectTableViewCellWithTableView:(UITableView *)tableView;

- (void)setGroupCellWithGroup:(PHAssetCollection *)group;

@end
