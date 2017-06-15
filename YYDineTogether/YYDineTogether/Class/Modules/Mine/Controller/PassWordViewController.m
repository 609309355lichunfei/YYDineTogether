//
//  PassWordViewController.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/6.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "PassWordViewController.h"

@interface PassWordViewController ()

@end

@implementation PassWordViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.navigationItem.title = @"密码修改";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem
                                             itemWithImageName:@"Navigation_left" highImageName:@"Navigation_left" target:self action:(@selector(back))];
  
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
