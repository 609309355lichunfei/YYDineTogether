//
//  AppManager.h
//  EWDicom
//
//  Created by 李春菲 on 17/6/2.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 包含应用层的相关服务
 */
@interface AppManager : NSObject
#pragma mark - ——————— APP启动接口 ————————
+(void)appStart;

#pragma mark - 实时监测网络状态
+ (void)monitorNetworkStatus;
@end
