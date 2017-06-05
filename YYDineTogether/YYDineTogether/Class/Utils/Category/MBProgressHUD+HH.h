//
//  MBProgressHUD+HH.h
//  ManyMouseMall
//
//  Created by 韩珍珍 on 15/10/27.
//  Copyright © 2015年 DS. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
/**
 * @ 弹窗样式
 */

@interface MBProgressHUD (HH)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)dimBackgroundShowMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)dimBackgroundShowMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;


@end
