//
//  AppDelegate.h
//  EWDicom
//
//  Created by 李春菲 on 17/6/1.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainTabBarController.h"
#import "LCPanNavigationController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
@property (strong, nonatomic) MainTabBarController *mainTabBar;

@property (strong, nonatomic) LCPanNavigationController *mainNavi;

@property (strong, nonatomic) NSString *order_no;

@end

