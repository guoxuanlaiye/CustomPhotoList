//
//  AlbumSelectGroupView.m
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/6.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import "AlbumSelectAssetGroupView.h"
#import "AlbumSelectTableViewCell.h"
#import "GXPHKitTool.h"
@interface AlbumSelectAssetGroupView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView * groupListView;
@property (nonatomic ,copy)  NSArray <PHAssetCollection*>* groupsArray;

@end

@implementation AlbumSelectAssetGroupView
#pragma mark - lazy 相册组数组
- (NSArray <PHAssetCollection*>*)groupsArray
{
    if (!_groupsArray) {
        _groupsArray = [NSArray array];
    }
    return _groupsArray;
}
#pragma mark - lazy 相册组列表
- (UITableView *)groupListView
{
    if (!_groupListView) {
        
        _groupListView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
        _groupListView.delegate        = self;
        _groupListView.dataSource      = self;
        _groupListView.tableFooterView = [[UIView alloc]init];
        _groupListView.backgroundColor = [UIColor orangeColor];
        
    }
    return _groupListView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self loadALAssetGroupArray];
        [self addSubview:self.groupListView];
    }
    return self;
}
- (void)loadALAssetGroupArray
{
    
    [[GXPHKitTool sharedPHKitTool] getPhotoListDatasWithResultBlock:^(NSMutableArray<PHAssetCollection *> *groups) {
       
        self.groupsArray = [NSArray arrayWithArray:groups];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumSelectTableViewCell * cell = [AlbumSelectTableViewCell createAlbumSelectTableViewCellWithTableView:tableView];
    [cell setGroupCellWithGroup:self.groupsArray[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupsArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PHAssetCollection * phAsset = self.groupsArray[indexPath.row];
    
    [self hideGroupListView];
    
    self.selectALGroupBlock(phAsset,phAsset.localizedTitle);

}
//显示相簿组
- (void)showGroupListView
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    self.frame = CGRectMake(0, window.bounds.size.height, window.bounds.size.width, window.bounds.size.height-64);
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.frame = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height);
    }];
}
//隐藏相簿组
- (void)hideGroupListView
{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;

    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, window.bounds.size.height, window.bounds.size.width, window.bounds.size.height-64);

    } completion:^(BOOL finished) {
        
    }];
}
@end
