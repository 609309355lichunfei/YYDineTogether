//
//  shippingViewController.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "shippingViewController.h"
#import "shippTableViewCell.h"
@interface shippingViewController ()<UITableViewDelegate,UITableViewDataSource,shippTableViewCellDelegate>
@property (retain, nonatomic)  UITableView *tableview;
@end

@implementation shippingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收货地址";
    
    [self.view addSubview:self.tableview];
    UIView * view = [UIView new];
    self.tableview.tableFooterView = view;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem
                                             itemWithImageName:@"Navigation_left" highImageName:@"Navigation_left" target:self action:(@selector(back))];
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableview {
    
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMakeAdapt(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource= self;
       
    }
    return _tableview;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 152;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    shippTableViewCell * cell = [shippTableViewCell InstallTableViewCellWith:tableView indexPath:indexPath];
    [cell configInstallTableCellWith:indexPath];
    
    cell.delegate = self;
    return cell;
}
//编辑
- (void)CompileWithBt {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
