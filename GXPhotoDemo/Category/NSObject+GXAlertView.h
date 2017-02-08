//
//  NSObject+GXAlertView.h
//  MiaoLive
//
//  Created by yingcan on 17/2/6.
//  Copyright © 2017年 Guoxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (GXAlertView)
- (void)showAlertWithVC:(UIViewController *)viewController message:(NSString *)message;
@end
