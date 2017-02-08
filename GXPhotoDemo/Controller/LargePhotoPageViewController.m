//
//  LargePhotoPageViewController.m
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/5.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import "LargePhotoPageViewController.h"
#import "LargePhotoViewController.h"
#import "GXPhotoAssetModel.h"
#define  RGBA_COLOR(R,G,B,A)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

@interface LargePhotoPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIGestureRecognizerDelegate>
@property (nonatomic ,strong)UIPageViewController * pageVC;
@property (nonatomic ,strong)UIButton * completeBtn;
@property (nonatomic ,strong)UIButton * selectBtn;

//@property (nonatomic ,strong)NSIndexPath * currentIndexPath;
@property (nonatomic ,strong)NSIndexPath * nextIndexPath;
@property (nonatomic, strong) UIView * bottomToolBar;

@end

@implementation LargePhotoPageViewController
#pragma mark - lazy 已选的照片数组
- (NSMutableArray *)selectedImgArray
{
    if (!_selectedImgArray) {
        _selectedImgArray = [NSMutableArray array];
    }
    return _selectedImgArray;
}
#pragma mark - lazy 分页控制器
- (UIPageViewController *)pageVC
{
    if (!_pageVC) {
        
        NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
        
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
        _pageVC.delegate   = self;
        _pageVC.dataSource = self;
    
    }
    return _pageVC;
}
#pragma mark - lazy 底部工具栏
- (UIView *)bottomToolBar
{
    if (!_bottomToolBar) {
        _bottomToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, self.view.frame.size.width, 50)];
        _bottomToolBar.backgroundColor = RGBA_COLOR(40, 42, 47, 1);
        UIButton * completeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        completeBtn.frame       = CGRectMake(self.view.frame.size.width - 60, 0, 50, 50);
        [completeBtn setTitle:@"完成" forState:UIControlStateSelected];
        [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [completeBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [completeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [completeBtn addTarget:self action:@selector(completeBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        self.completeBtn = completeBtn;
        
        if (self.selectedImgArray.count == 0) {
            self.completeBtn.selected = NO;
        } else {
            self.completeBtn.selected = YES;
        }
        
        [_bottomToolBar addSubview:completeBtn];
    }
    return _bottomToolBar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    //是否全屏展示监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(largePhotoFull:) name:@"largePhotoFullNotification" object:nil];
    
    [self setupNav];

    [self initPageVC];
    
    [self setupToolBar];
    
}
- (void)largePhotoFull:(NSNotification *)notification
{
    NSDictionary * infoDict = notification.userInfo;
    
    if ([infoDict[@"isFull"] isEqualToString:@"YES"]) {
        
        self.bottomToolBar.hidden = YES;
    } else {
        
        self.bottomToolBar.hidden = NO;
    }
}
#pragma mark - 设置导航条和底部工具条
- (void)setupNav
{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"xuanzhong_hui"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"xuanzhong_lv"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn    = rightButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];

}
- (void)setupToolBar
{
    [self.view addSubview:self.bottomToolBar];
}
#pragma mark - 完成按钮被点击
- (void)completeBtnDidClick:(UIButton *)button
{

    if (self.selectedImgArray.count == 0) {
        return;
    }
    self.largePhotoBlock(self.selectedImgArray);
    self.largePhotoWriteBlock();
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 截取返回按钮点击事件
- (void)backBtnClick
{
    self.largePhotoBlock(self.selectedImgArray);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 选择或取消选择当前的照片
- (void)rightBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    NSArray * array = self.allImgDict[self.allDateArray[self.indexPath.section]];
    GXPhotoAssetModel * model = array[self.indexPath.row];
    if (button.selected == YES) {
        
        [self.selectedImgArray addObject:model];
        
    } else {
        
        if ([self.selectedImgArray containsObject:model]) {
            [self.selectedImgArray removeObject:model];
        }
    }
    
    if (self.selectedImgArray.count == 0) {
        self.completeBtn.selected = NO;
    } else {
        self.completeBtn.selected = YES;
    }
}
#pragma mark - 初始化分页控制器
- (void)initPageVC
{
    
    LargePhotoViewController * largeVC = [[LargePhotoViewController alloc]init];
    
    largeVC.indexPath = _indexPath;
    NSArray * array   = self.allImgDict[self.allDateArray[_indexPath.section]];
    largeVC.model     = array[_indexPath.row];
    
    [self decideSelectedButtonWithIndexPath:_indexPath];
    
    [self.pageVC setViewControllers:@[largeVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:nil];
    
    [self.pageVC didMoveToParentViewController:self];
    self.pageVC.view.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.pageVC.view];
    [self addChildViewController:self.pageVC];

}
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    LargePhotoViewController * lastVC = (LargePhotoViewController *)viewController;
    NSIndexPath * lastIndexPath       = lastVC.indexPath;
    
    NSInteger lastSection = lastIndexPath.section;
    NSInteger lastRow     = lastIndexPath.row;
    
    NSArray * array       = self.allImgDict[self.allDateArray[lastSection]];

    lastRow ++;
    if (lastRow == array.count) {
        lastRow = 0;
        lastSection ++;
        if (lastSection == self.allDateArray.count) {
            return nil;
        }
    }

    return [self viewCintrollerAtIndex:[NSIndexPath indexPathForRow:lastRow inSection:lastSection]];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    LargePhotoViewController * lastVC = (LargePhotoViewController *)viewController;
    NSIndexPath * lastIndexPath       = lastVC.indexPath;
    
    NSInteger lastSection = lastIndexPath.section;
    NSInteger lastRow     = lastIndexPath.row;
    
    
    lastRow --;
    if (lastRow < 0) {
        
        lastSection --;
        if (lastSection < 0) {
            return nil;
        }
        NSArray * array = self.allImgDict[self.allDateArray[lastSection]];

        lastRow = array.count - 1;
    }
    
    return [self viewCintrollerAtIndex:[NSIndexPath indexPathForRow:lastRow inSection:lastSection]];
    
}
//检查是否已经选择该图片
- (void)decideSelectedButtonWithIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray * array = self.allImgDict[self.allDateArray[indexPath.section]];
    GXPhotoAssetModel * model = array[indexPath.row];
    self.selectBtn.selected   = [_selectedImgArray containsObject:model];
    
    
}
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    //如果翻转过去下一页
    if (completed)
    {
        
//        NSLog(@"完成");
        self.indexPath = self.nextIndexPath;
        //检查是否已选
        [self decideSelectedButtonWithIndexPath:self.indexPath];

    }
}
//将要翻到下一界面，但不一定翻转成功
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    
    LargePhotoViewController * lastVC = (LargePhotoViewController *)pendingViewControllers[0];
    self.nextIndexPath = lastVC.indexPath;
//    NSLog(@"IndexPath-----%@",lastVC.indexPath);

}
#pragma mark - 封装VC
- (LargePhotoViewController *)viewCintrollerAtIndex:(NSIndexPath *)indexPath
{
    
    NSArray * array = self.allImgDict[self.allDateArray[indexPath.section]];
    GXPhotoAssetModel * model = array[indexPath.row];
    if (model.asset == nil) {
        return nil;
    }
    
    LargePhotoViewController * larVC = [[LargePhotoViewController alloc]init];
    larVC.indexPath = indexPath;
    larVC.model     = model;
    return larVC;
}



@end
