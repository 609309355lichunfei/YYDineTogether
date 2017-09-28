//
//  IndentChooseAddressViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentChooseAddressViewController.h"
#import "IndentChooseAddressTableViewCell.h"
#import "IndentEditAddressViewController.h"
#import "JSYHAddressModel.h"
#import "JSAddAddressViewController.h"
#import "DB_Helper.h"

@interface IndentChooseAddressViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) JSYHAddressModel *selectAddressModel;

@end

@implementation IndentChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)registUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"IndentChooseAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentChooseAddressTableViewCell"];
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getConnect];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getConnect {
    [[JSRequestManager sharedManager] getMemberAddressSuccess:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.dataArray removeAllObjects];
        self.selectAddressModel = nil;
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *addressDicArray = dataDic[@"addresses"];
        for (NSDictionary *addressDic in addressDicArray) {
            JSYHAddressModel *model = [[JSYHAddressModel alloc] init];
            [model setValuesForKeysWithDictionary:addressDic];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (IBAction)addAddressAction:(id)sender {
    JSAddAddressViewController *addVC = [[JSAddAddressViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (IBAction)backAction:(id)sender {
    if (self.selectAddressModel == nil) {
        [AppManager showToastWithMsg:@"请选择地址"];
        return;
    }
    [[DB_Helper defaultHelper] updateAddress:self.selectAddressModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JSYHAddressChange" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender {
    if (self.selectAddressModel == nil) {
        [AppManager showToastWithMsg:@"请选择地址"];
        return;
    }
    [[DB_Helper defaultHelper] updateAddress:self.selectAddressModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JSYHAddressChange" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSYHAddressModel *model = self.dataArray[indexPath.row];
    NSDictionary *dataDic = @{@"addressid":[model.addressid stringValue],@"lng":model.lng,@"lat":model.lat,@"address":model.address,@"username":model.username,@"phone":model.phone};
    [MBProgressHUD showMessage:@"删除中"];
    [[JSRequestManager sharedManager] deleteMemeberAddressWithDic:dataDic Success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header beginRefreshing];
    } Failed:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IndentChooseAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndentChooseAddressTableViewCell" forIndexPath:indexPath];
    JSYHAddressModel *model = self.dataArray[indexPath.row];
    MJWeakSelf;
    cell.editBlock = ^(){
        IndentEditAddressViewController *editAddressVC = [[IndentEditAddressViewController alloc] init];
        editAddressVC.addressModel = model;
        [weakSelf.navigationController pushViewController:editAddressVC animated:YES];
    };
    cell.addressModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHAddressModel *model = self.dataArray[indexPath.row];
    self.selectAddressModel = model;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
