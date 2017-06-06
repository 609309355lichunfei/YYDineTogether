//
//  RootNavigationController.m
//  EWDicom
//
//  Created by 李春菲 on 2017/5/18.
//  Copyright © 2017年 李春菲. All rights reserved.
//

#import "RootNavigationController.h"
#import "UIBarButtonItem+Extension.h"
@interface RootNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, weak) id popDelegate;
@end

@implementation RootNavigationController

//APP生命周期中 只会执行一次
+ (void)initialize
{
    //导航栏主题 title文字属性
    UINavigationBar *navBar = [UINavigationBar appearance];
    //导航栏背景图
//    [navBar setBackgroundImage:[UIImage imageNamed:@"tabBarBj"] forBarMetrics:UIBarMetricsDefault];
    [navBar setBarTintColor:[UIColor colorWithHexString:@"00AE68"]];
    [navBar setTintColor:KWhiteColor];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :KWhiteColor, NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    //导航栏左右文字主题
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    
//    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : KWhiteColor, NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    
//    //tabBar主题 title文字属性
//    UITabBarItem *tabBarItem = [UITabBarItem appearance];
//    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : GRAYTEXTCOLOR} forState:UIControlStateNormal];
//    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : ButtonNormalColor} forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    //navigationBar样式设置
//    self.navigationBar.barTintColor = KBlueColor;
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : KWhiteColor, NSFontAttributeName : [UIFont boldSystemFontOfSize:16]}];
//    [self.navigationBar setTintColor:KWhiteColor];    // Do any additional setup after loading the view.
}

////解决手势失效问题
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (viewController == self.viewControllers[0]) {
//        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
//    }else{
//        self.interactivePopGestureRecognizer.delegate = nil;
//    }
//}

//push时隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem
                                                           itemWithImageName:@"Navigation_left" highImageName:@"Navigation_left" target:self action:(@selector(back))];
    }
    [super pushViewController:viewController animated:animated];
}
-(void)back{
    
    [self popViewControllerAnimated:YES];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([viewController isKindOfClass:[RootViewController class]]) {
        RootViewController * vc = (RootViewController *)viewController;
        if (vc.isHidenNaviBar) {
            [vc.navigationController setNavigationBarHidden:YES animated:animated];
        }else{
            [vc.navigationController setNavigationBarHidden:NO animated:animated];
        }
    }
}

////设置样式
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

-(UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
