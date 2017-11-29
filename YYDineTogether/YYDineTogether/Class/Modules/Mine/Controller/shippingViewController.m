//
//  shippingViewController.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "shippingViewController.h"
#import "shippTableViewCell.h"
#import "IndentEditAddressViewController.h"
#import "IndentChooseAddressTableViewCell.h"
#import "JSYHAddressModel.h"
#import "JSAddAddressViewController.h"
@interface shippingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation shippingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)registUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"IndentChooseAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"shippTableViewCell"];
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getConnect];
    }];
}

- (void)getConnect {
    [[JSRequestManager sharedManager] getMemberAddressSuccess:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.dataArray removeAllObjects];
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

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addAddressAction:(id)sender {
    JSAddAddressViewController *addVC = [[JSAddAddressViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
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
    
    IndentChooseAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shippTableViewCell" forIndexPath:indexPath];
    JSYHAddressModel *model = self.dataArray[indexPath.row];
    MJWeakSelf;
    cell.editBlock = ^(){
        IndentEditAddressViewController *editAddressVC = [[IndentEditAddressViewController alloc] init];
        editAddressVC.addressModel = model;
        [weakSelf.navigationController pushViewController:editAddressVC animated:YES];
    };
    cell.addressModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//编辑
- (void)CompileWithBt {
    
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

@end
