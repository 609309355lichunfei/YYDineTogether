//
//  SettingUpController.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/6.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "SettingUpController.h"
#import "PassWordViewController.h"

@interface SettingUpController ()

@end

@implementation SettingUpController

- (void)viewDidLoad {
    [super viewDidLoad];
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


@end
