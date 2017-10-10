//
//  SettingUpController.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/6.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "SettingUpController.h"
#import "PassWordViewController.h"
#import <JPUSHService.h>

@interface SettingUpController ()
@property (weak, nonatomic) IBOutlet UIButton *logOutBT;
@property (weak, nonatomic) IBOutlet UIButton *messageBT;
@property (weak, nonatomic) IBOutlet UIButton *locationBT;

@end

@implementation SettingUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registUI];
}

- (void)registUI {
    self.logOutBT.layer.cornerRadius = 2;
    if ([JSRequestManager sharedManager].token == nil || [JSRequestManager sharedManager].token.length == 0) {
        self.logOutBT.hidden = YES;
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changePasswordAction:(id)sender {
    PassWordViewController *passwordVC = [[PassWordViewController alloc] init];
    [self.navigationController pushViewController:passwordVC animated:YES];
}

- (IBAction)clearCacheAction:(id)sender {
}

- (IBAction)logOutAction:(id)sender {
    [MBProgressHUD showMessage:@"退出中"];
    [[JSRequestManager sharedManager] logoutWithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        
        
        [AppManager showToastWithMsg:@"已退出"];
        [[ShoppingCartManager sharedManager] shoppingCartReloadData];
        self.logOutBT.hidden = YES;
        [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
        [self.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

@end
