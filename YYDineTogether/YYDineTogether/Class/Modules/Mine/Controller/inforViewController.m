//
//  inforViewController.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "inforViewController.h"

@interface inforViewController ()

@end

@implementation inforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息通知";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem
                                                       itemWithImageName:@"Navigation_left" highImageName:@"Navigation_left" target:self action:(@selector(back))];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
