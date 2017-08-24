//
//  MsgViewController.m
//  EWDicom
//
//  Created by 李春菲 on 17/6/2.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "MsgViewController.h"
#import "MsgTableViewCell.h"
#import "MsgTableHeaderView.h"
#import "HomeActivityViewController.h"
#import "MsgEditViewController.h"
#import "MsgDetailViewController.h"

@interface MsgViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MsgTableHeaderView *headerView;
@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registUI];
}

- (void)registUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"MsgTableViewCell"];
}

- (IBAction)editAction:(id)sender {
    MsgEditViewController *editVC = [[MsgEditViewController alloc] init];
    if (_isMine) {
        [self.navigationController pushViewController:editVC animated:YES];
    } else {
        [self.tabBarController.navigationController pushViewController:editVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 260;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.headerView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgDetailViewController *detailVC = [[MsgDetailViewController alloc] init];
    if (_isMine) {
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        [self.tabBarController.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - 懒加载
- (MsgTableHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"MsgTableHeaderView" owner:self options:nil] lastObject];
        
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
