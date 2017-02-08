//
//  NSObject+GXAlertView.m
//  MiaoLive
//
//  Created by yingcan on 17/2/6.
//  Copyright © 2017年 Guoxuan. All rights reserved.
//

#import "NSObject+GXAlertView.h"

@implementation NSObject (GXAlertView)
- (void)showAlertWithVC:(UIViewController *)viewController message:(NSString *)message
{
    if ([self isKindOfClass:[UIViewController class]] || [self isKindOfClass:[UIView class]]) {
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
                                       
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:action];
        [viewController presentViewController:alertVC animated:YES completion:nil];
    }
}

@end
