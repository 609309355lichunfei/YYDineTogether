//
//  AppDelegate+AppService.h
//  EWDicom
//
//  Created by 李春菲 on 17/6/1.
//  Copyright © 2017年 lichunfei. All rights reserved.
//
/**
 包含第三方 和 应用内业务的实现，减轻入口代码压力
 */
#import "AppDelegate.h"

@interface AppDelegate (AppService)
/**
 *  @ 初始化window
 */
- (void)initWindow;
/**
 *  @ UMeng初始化  用于第三方登陆第三方分享一些
 */
- (void)initUMeng;
/**
 *  @ 创建单例方法
 */
+ (AppDelegate *)shareAppDelegate;

/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;

@end
