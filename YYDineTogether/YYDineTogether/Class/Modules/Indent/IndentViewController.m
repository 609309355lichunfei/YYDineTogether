//
//  IndentViewController.m
//  EWDicom
//
//  Created by 李春菲 on 17/6/4.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentViewController.h"
#import "IndentTableViewCell.h"
#import "IndentConfirmViewController.h"
#import "IndentDetailViewController.h"

@interface IndentViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *completeBT;
@property (weak, nonatomic) IBOutlet UIButton *unpaidBT;
@property (weak, nonatomic) IBOutlet UIButton *refundBT;

@property (strong, nonatomic) UIButton *currentBT;

@end

@implementation IndentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    self.currentBT = _completeBT;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"IndentTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentTableViewCell"];
}

- (IBAction)completeAction:(id)sender {
    if (self.currentBT == _completeBT) {
        return;
    }
    [self.currentBT setTitleColor:RGB(120, 120, 120) forState:(UIControlStateNormal)];
    [_completeBT setTitleColor:RGB(205, 77, 62) forState:(UIControlStateNormal)];
    self.currentBT = _completeBT;
}

- (IBAction)unpayAction:(id)sender {
    if (self.currentBT == _unpaidBT) {
        return;
    }
    [self.currentBT setTitleColor:RGB(120, 120, 120) forState:(UIControlStateNormal)];
    [_unpaidBT setTitleColor:RGB(205, 77, 62) forState:(UIControlStateNormal)];
    self.currentBT = _unpaidBT;
}

- (IBAction)refundAction:(id)sender {
    if (self.currentBT == _refundBT) {
        return;
    }
    [self.currentBT setTitleColor:RGB(120, 120, 120) forState:(UIControlStateNormal)];
    [_refundBT setTitleColor:RGB(205, 77, 62) forState:(UIControlStateNormal)];
    self.currentBT = _refundBT;
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 368;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IndentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndentTableViewCell" forIndexPath:indexPath];
    MJWeakSelf
    cell.againblock = ^(){
        IndentConfirmViewController *confirmVC = [[IndentConfirmViewController alloc]init];
        [weakSelf.tabBarController.navigationController pushViewController:confirmVC animated:YES];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IndentDetailViewController *detailVC = [[IndentDetailViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
