//
//  AppDelegate+AppService.m
//  EWDicom
//
//  Created by 李春菲 on 17/6/1.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "MainTabBarController.h"
#import "LCPanNavigationController.h"
#import "JSYHGuideViewController.h"
@implementation AppDelegate (AppService)

#pragma  mark -----------  初始化window--------

- (void)initWindow {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = KWhiteColor;
    self.mainTabBar = [MainTabBarController new];
    self.mainNavi = [[LCPanNavigationController alloc]initWithRootViewController:self.mainTabBar];
    self.mainNavi.navigationBar.hidden = YES;
    
    
    
    if (CurrentSystemVersion != [[NSUserDefaults standardUserDefaults] doubleForKey:@"JSZPAPP_Version"]) {
        JSYHGuideViewController *guideVC = [[JSYHGuideViewController alloc] init];
        guideVC.changeRootBlock = ^(){
            self.window.rootViewController = self.mainNavi;
        };
        self.window.rootViewController = guideVC;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"JSZPAPP_Dish"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"JSZPAPP_Comb"];
    } else {
        self.window.rootViewController = self.mainNavi;
    }
    [[NSUserDefaults standardUserDefaults] setDouble:CurrentSystemVersion forKey:@"JSZPAPP_Version"];
    [self.window makeKeyAndVisible];
    
    [[UIButton appearance] setExclusiveTouch:YES];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = KWhiteColor;
}
- (void)YYKeyboardManager {
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
}

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

@end
