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
#import "JSYHOrderModel.h"
#import <JPUSHService.h>

@interface IndentViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSInteger _pageIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *completeBT;
@property (weak, nonatomic) IBOutlet UIButton *unpaidBT;
@property (weak, nonatomic) IBOutlet UIButton *refundBT;
@property (weak, nonatomic) IBOutlet UIView *unloginBGView;
@property (weak, nonatomic) IBOutlet UIButton *loginBT;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UIButton *currentBT;

@end

@implementation IndentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
    
}

- (void)registUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentBT = _completeBT;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"IndentTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentTableViewCell"];
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getConnectWithType:DataLoadTypeNone];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getConnectWithType:DataLoadTypeMore];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if ([JSRequestManager sharedManager].userName == nil || [JSRequestManager sharedManager].userName.length == 0) {
        self.unloginBGView.hidden = NO;
    }else {
        self.unloginBGView.hidden = YES;
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)getConnectWithType:(DataLoadType)dataloadType {
    _pageIndex = dataloadType == DataLoadTypeNone ? 0 : _pageIndex + 1;
    [[JSRequestManager sharedManager] getOrdersWithPage:[NSString stringWithFormat:@"%ld",_pageIndex] Success:^(id responseObject) {
        if (dataloadType == DataLoadTypeNone) {
            [self.dataArray removeAllObjects];
        }
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *orderDicArray = dataDic[@"orders"];
        for (NSDictionary *orderDic in orderDicArray) {
            JSYHOrderModel *model = [[JSYHOrderModel alloc] init];
            [model setValuesForKeysWithDictionary:orderDic];
            [UserManager sharedManager].timerinterval = model.nowtime - [AppManager getNowTimestamp];
            [model updateOrderHeight];
            [self.dataArray addObject:model];
        }
        if (dataloadType == DataLoadTypeNone) {
            
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        self.tableView.mj_footer.hidden = orderDicArray.count < 20 ? YES : NO;
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        if (dataloadType == DataLoadTypeNone) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (IBAction)loginAction:(id)sender {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.tabBarController presentViewController:loginVC animated:YES completion:nil];
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
    JSYHOrderModel *model = self.dataArray[indexPath.row];
    return model.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IndentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndentTableViewCell" forIndexPath:indexPath];
    JSYHOrderModel *model = self.dataArray[indexPath.row];
    cell.orderModel = model;
    cell.firstBlock = ^(JSYHOrderModel *model){
        [self.tableView.mj_header beginRefreshing];
    };
    MJWeakSelf
    cell.firstBlock = ^(JSYHOrderModel *model){
        
    };
    cell.secondBlock = ^(JSYHOrderModel *model){
        
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IndentDetailViewController *detailVC = [[IndentDetailViewController alloc] init];
    JSYHOrderModel *model = self.dataArray[indexPath.row];
    detailVC.order_no = model.order_no;
    [self.tabBarController.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 懒加载
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
