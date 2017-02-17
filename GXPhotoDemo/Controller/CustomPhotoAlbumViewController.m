//
//  CustomPhotoAlbumViewController.m
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/4.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import "CustomPhotoAlbumViewController.h"
#import "AlbumCollectionViewCell.h"
#import "AlbumDateHeaderView.h"
#import "GXPhotoAssetModel.h"
#import "AlbumNavTitleView.h"
#import "AlbumSelectAssetGroupView.h"
#import "LargePhotoPageViewController.h"
#import "GXPHKitTool.h"
#import "NSObject+GXAlertView.h"

#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_H ([UIScreen mainScreen].bounds.size.height)

#define  RGBA_COLOR(R,G,B,A)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

@interface CustomPhotoAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic ,strong)UICollectionView * albumCollectionView;
@property (nonatomic ,strong)AlbumNavTitleView    * navTitleView;
@property (nonatomic ,strong)AlbumSelectAssetGroupView * selectGroupView;

@property (nonatomic ,strong)NSMutableArray      * photosDateArray;
@property (nonatomic ,strong)NSMutableDictionary * photosDict;
@property (nonatomic ,strong)NSMutableArray      * selectedImageArray;

@end

@implementation CustomPhotoAlbumViewController
- (void)dealloc
{
    NSLog(@"释放CustomPhotoAlbumViewController");
}
#pragma mark - lazy 头部选择相册组视图
- (AlbumNavTitleView *)navTitleView
{
    if (!_navTitleView) {
        
        __weak typeof(self) weakSelf = self;
        _navTitleView = [[AlbumNavTitleView alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
        _navTitleView.navTitleButtonClick = ^(UIButton *button) {
        
            if (button.selected == YES) {
                
                [weakSelf.view addSubview:weakSelf.selectGroupView];
                [weakSelf.selectGroupView showGroupListView];
            } else {
            
                [weakSelf.selectGroupView hideGroupListView];
            }
        };
    }
    return _navTitleView;
}
#pragma mark - lazy 选择相册薄
- (AlbumSelectAssetGroupView *)selectGroupView
{
    if (!_selectGroupView) {
        
        __weak typeof(self) weakSelf = self;
        _selectGroupView = [[AlbumSelectAssetGroupView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W, self.view.frame.size.height -64)];
        _selectGroupView.selectALGroupBlock = ^(PHAssetCollection * group,NSString * groupName) {
          
            NSLog(@" 开始读取 -------- 相簿 = %zd",groupName);
            dispatch_async(dispatch_get_main_queue(), ^{
            
                weakSelf.navTitleView.detailLab.text = groupName;
                [weakSelf.navTitleView rotationBack];
                PHFetchResult * fetch = [[GXPHKitTool sharedPHKitTool] getFetchResult:group];
                [[GXPHKitTool sharedPHKitTool] getPhotoAssets:fetch resultBlock:^(NSMutableArray<GXPhotoAssetModel *> *imageArray) {
                    
                    NSLog(@"读取完的相簿 = %@ --- 个数%zd",groupName,imageArray.count);
                    [weakSelf setupPhotosDataWithArray:imageArray];
                }];
                
            });

        };
    }
    return _selectGroupView;
}

#pragma mark - lazy 已选中的照片数组
- (NSMutableArray *)selectedImageArray
{
    if (!_selectedImageArray) {
        _selectedImageArray = [NSMutableArray array];
    }
    return _selectedImageArray;
}

#pragma mark - lazy 日期数组
- (NSMutableArray *)photosDateArray
{
    if (!_photosDateArray) {
        _photosDateArray = [NSMutableArray array];
    }
    return _photosDateArray;
}
#pragma mark - lazy 图片字典
- (NSMutableDictionary *)photosDict
{
    if (!_photosDict) {
        _photosDict = [NSMutableDictionary dictionary];
    }
    return _photosDict;
}

- (UICollectionView *)albumCollectionView
{
    if (!_albumCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing      = 0.0;
        _albumCollectionView                    = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
        _albumCollectionView.backgroundColor    = [UIColor whiteColor];
        _albumCollectionView.dataSource         = self;
        _albumCollectionView.delegate           = self;
        _albumCollectionView.alwaysBounceVertical = YES; //不够一屏也能滚
        _albumCollectionView.pagingEnabled      = NO;
        [_albumCollectionView registerClass:[AlbumCollectionViewCell class] forCellWithReuseIdentifier:@"AlbumCell"];
        [_albumCollectionView registerClass:[AlbumDateHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];

    }
    return _albumCollectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavTitle];
    
    [self setupNav];
    
    [self setupView];
   
    [self loadPhotosData];
    
}
- (void)loadPhotosData
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    
    dispatch_after(time, dispatch_get_main_queue(), ^{
        //执行操作
        NSLog(@"after 0.1s");
        
        [self loadLocalPhotoAlbumData];
        
    });

}
#pragma mark - title
- (void)setupNavTitle
{
    self.navigationItem.titleView = self.navTitleView;
}

#pragma mark - 导航条
- (void)setupNav
{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame      = CGRectMake(0, 0, 40, 40);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame      = CGRectMake(0, 0, 40, 40);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [rightButton addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}
- (void)cancelBtnClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 设置UI
- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.albumCollectionView];
    
}
#pragma mark - 首次进入加载相机胶卷照片资源
- (void)loadLocalPhotoAlbumData
{
    __weak typeof(self) weakSelf = self;
    [[GXPHKitTool sharedPHKitTool] getCameraRollAssetsWithResultBlock:^(PHAuthorizationStatus status,NSArray<GXPhotoAssetModel *> *imageArray) {
        
        if (imageArray.count > 0) {
            [weakSelf setupPhotosDataWithArray:imageArray];
        }
        if (status == PHAuthorizationStatusDenied) { //拒绝访问需弹窗提示用户
            [weakSelf showAlertWithVC:weakSelf message:@"请在设备的“设置-隐私-照片”中允许访问照片。"];
        }
    }];

}
#pragma mark - 对照片进行日期分组
- (void)setupPhotosDataWithArray:(NSArray <GXPhotoAssetModel*>* )imageArray
{
    __weak typeof(self) weakSelf = self;

    [weakSelf.photosDict      removeAllObjects];
    [weakSelf.photosDateArray removeAllObjects];

    __block NSString * lastDateStr = @"";
    [imageArray enumerateObjectsUsingBlock:^(GXPhotoAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            
            lastDateStr = obj.dateStr;
            [weakSelf.photosDict setObject:[NSMutableArray arrayWithObjects:obj, nil] forKey:obj.dateStr];
            
        } else {
            
            if ([obj.dateStr isEqualToString:lastDateStr]) {
                
                //把图片添加到字典中
                [weakSelf.photosDict[obj.dateStr] addObject:obj];
            } else {
                
                lastDateStr = obj.dateStr;
                [weakSelf.photosDict setObject:[NSMutableArray arrayWithObjects:obj, nil] forKey:obj.dateStr];
            }
        }
    }];

    weakSelf.photosDateArray  = [NSMutableArray arrayWithArray:[weakSelf.photosDict allKeys]];
    
    //按日期排序
    NSArray * descriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:nil ascending:NO]];
    
    NSArray * tmpArray    = [NSArray arrayWithArray:weakSelf.photosDateArray];
    
    weakSelf.photosDateArray  = [NSMutableArray arrayWithArray:[tmpArray sortedArrayUsingDescriptors:descriptors]];
    
    [weakSelf.albumCollectionView reloadData];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.photosDateArray.count == 0) {
        return 0;
    } else {
        NSArray * array = self.photosDict[self.photosDateArray[section]];
        return array.count;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.photosDateArray.count == 0 ? 1 : self.photosDateArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"AlbumCell";
    AlbumCollectionViewCell * collect = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (self.photosDateArray.count > 0) {
        
        //判断是否是已选的照片
        NSArray * array           = self.photosDict[self.photosDateArray[indexPath.section]];
        GXPhotoAssetModel * model = array[indexPath.row];
        collect.assetModel        = model;

        collect.isSelected = NO;
        
        [self.selectedImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GXPhotoAssetModel * tmpModel = (GXPhotoAssetModel *)obj;
            
            if ([tmpModel.asset isEqual:model.asset]) {
                collect.isSelected = YES;
                *stop = YES;
            }
        }];
        
    }
    __weak typeof(self) weakSelf = self;
    __weak typeof(collect)weakCell = collect;
    //单个添加已选的照片model
    weakCell.albumCellSelectBlock = ^(GXPhotoAssetModel *model,UIButton * isSelectBtn) {
    
        if (isSelectBtn.selected == YES) {
            
            [weakSelf.selectedImageArray addObject:model];
        } else {
            
            [weakSelf.selectedImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                GXPhotoAssetModel * m = (GXPhotoAssetModel*)obj;
                if ([m.asset isEqual:model.asset]) {
                    [weakSelf.selectedImageArray removeObject:m];
                    *stop = YES;
                }
                
            }];
        }
        //刷新section(为了判断该组是否是全选)
        [UIView performWithoutAnimation:^{
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        }];
    };
    return collect;
}
#pragma mark - 头部视图（日期和全选）
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader){
        
        AlbumDateHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
        if (self.photosDateArray.count > 0) {
            
            headerView.allSelectButton.hidden = NO;
            //显示日期
            headerView.dateStr = self.photosDateArray[indexPath.section];

            //判断是否是全选的
            NSArray * sectionArray = [NSArray arrayWithArray:self.photosDict[self.photosDateArray[indexPath.section]]];
            __block NSInteger i = 0;
            __weak typeof(self) weakSelf = self;

            [sectionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                GXPhotoAssetModel * sectionModel = (GXPhotoAssetModel *)obj;
                
                [weakSelf.selectedImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    GXPhotoAssetModel * objModel = (GXPhotoAssetModel *)obj;
                    if ([sectionModel.asset isEqual:objModel.asset]) {
                        i++;
                    }
                }];
            }];
            headerView.isAllSelect = i == sectionArray.count ? YES : NO;
            
        } else {
            headerView.allSelectButton.hidden = YES;
        }
        __weak typeof(self) weakSelf = self;
        __weak typeof(headerView) weakHeader = headerView;
        //全选按钮被点击
        weakHeader.allSelectBlock = ^(NSInteger section,UIButton * isAllSelectBtn) {
            
                NSArray * array = weakSelf.photosDict[weakSelf.photosDateArray[indexPath.section]];
                
                if (isAllSelectBtn.selected == YES) {
                    
                    for (GXPhotoAssetModel * model in array) {
                        
                        NSInteger i = 0;
                        for (GXPhotoAssetModel * selectModel in weakSelf.selectedImageArray) {
                            
                            if ([model.asset isEqual:selectModel.asset]) {
                                break;
                            }
                            i++;
                        }
                        
                        if (i == weakSelf.selectedImageArray.count) {
                            
                            //限制50张照片
                            if (weakSelf.selectedImageArray.count <= 49) {
                                
                                if (model.asset != nil) {
                                    [weakSelf.selectedImageArray addObject:model];
                                }
                                
                            } else {
                                
                                [weakSelf showAlertWithVC:weakSelf message:@"不能添加更多了哦亲~"];
                                break;
                            }
                        }
                    }
                    
                } else {
                    
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        GXPhotoAssetModel * model = (GXPhotoAssetModel *)obj;
                        
                        [weakSelf.selectedImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            GXPhotoAssetModel * objModel = (GXPhotoAssetModel *)obj;
                            
                            if ([model.asset isEqual:objModel.asset]) {
                                [weakSelf.selectedImageArray removeObject:objModel];
                                *stop = YES;
                            }
                        }];
                    }];
                }

            //全选需要刷新section
            [UIView performWithoutAnimation:^{
                [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            }];
        };
        return headerView;
    } else {
        return nil;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_W-5)/4, (SCREEN_W-5)/4);
}
//横向间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}
//纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size={self.view.frame.size.width, 56};
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    LargePhotoPageViewController * largePageVC = [[LargePhotoPageViewController alloc]init];
    largePageVC.indexPath    = indexPath;
    largePageVC.allDateArray = self.photosDateArray;
    largePageVC.allImgDict   = self.photosDict;
    largePageVC.selectedImgArray = self.selectedImageArray;
    largePageVC.largePhotoBlock  = ^(NSMutableArray * largeArray) {
    
        weakSelf.selectedImageArray  = [NSMutableArray arrayWithArray:largeArray];

        [weakSelf.albumCollectionView reloadData];
    };
    //浏览大图完成，开始写记忆
    largePageVC.largePhotoWriteBlock = ^{
    
        NSLog(@"选照片结束------%@",weakSelf.selectedImageArray);
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    [self.navigationController pushViewController:largePageVC animated:YES];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - 选照片完成
- (void)completeBtnClick
{
    if (self.selectedImageArray.count == 0) {
        return;
    }
    NSLog(@"选照片结束------%@",self.selectedImageArray);

    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
}
//#pragma mark - 调起摄像头拍照（暂时没用上，不支持照相）
//- (void)setupImagePicker
//{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    //支持相机功能
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        
//        //支持视频
////        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
////        picker.mediaTypes    = temp_MediaTypes;
//        
//        picker.delegate      = self;
//        picker.allowsEditing = YES;
//    }
//    
//    [self presentViewController:picker animated:YES completion:nil];
//}
//#pragma mark - UIImagePickerControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    
////    NSLog(@"info == %@",info);
////    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
////取消按钮
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
@end
