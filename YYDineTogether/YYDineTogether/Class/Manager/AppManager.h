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

/**
 *  显示提示
 *
 *  @param msgStr 提示消息
 */
+ (void)showToastWithMsg:(NSString *)msgStr;


/**
 获取时间戳
 */
+ (NSInteger)getNowTimestamp;

#pragma mark - 将某个时间转化成 时间戳

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime;

#pragma mark - 将某个时间戳转化成 时间

+(NSString *)timestampSwitchTime:(NSInteger)timestamp;

+ (NSString *)couponTimestampSwitchTime:(NSInteger)timestamp;

+(NSInteger)birthTimeSwitchTimestamp:(NSString *)formatTime;

+ (NSString *)birthTimestanpSwitchTime:(NSInteger)timestamp;

@end
