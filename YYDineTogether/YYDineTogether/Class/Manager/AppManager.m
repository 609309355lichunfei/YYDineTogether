//
//  AppManager.m
//  EWDicom
//
//  Created by 李春菲 on 17/6/2.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "AppManager.h"
#import "UIView+Toast.h"

@implementation AppManager
#pragma mark - 实时监测网络状态
+ (void)monitorNetworkStatus
{
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
        
        switch (networkStatus) {
                // 未知网络
            case PPNetworkStatusUnknown:
                DLog(@"网络环境：未知网络");
                // 无网络
            case PPNetworkStatusNotReachable:
                DLog(@"网络环境：无网络");
                break;
                // 手机网络
            case PPNetworkStatusReachableViaWWAN:
                DLog(@"网络环境：手机自带网络");
                // 无线网络
            case PPNetworkStatusReachableViaWiFi:
                DLog(@"网络环境：WiFi");
                break;
        }
        
    }];
    
}

+ (void)showToastWithMsg:(NSString *)msgStr
{
    if (!msgStr || msgStr.length == 0) {
        return;
    }
    [kAppWindow makeToast:msgStr duration:2.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:nil];
}

@end
