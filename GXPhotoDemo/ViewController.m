//
//  ViewController.m
//  GXPhotoDemo
//
//  Created by yingcan on 17/2/8.
//  Copyright © 2017年 Guoxuan. All rights reserved.
//

#import "ViewController.h"
#import "CustomPhotoAlbumViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(self.view.frame.size.width/2-40, 200, 80, 30);
    [button setTitle:@"选择照片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)btnClick
{
    CustomPhotoAlbumViewController * photoVC = [[CustomPhotoAlbumViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:photoVC];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
