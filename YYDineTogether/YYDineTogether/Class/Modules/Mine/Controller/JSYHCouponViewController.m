//
//  JSYHCouponViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/4.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHCouponViewController.h"
#import "JSYHCouponTableViewCell.h"
#import "JSYHCouponModel.h"

@interface JSYHCouponViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger _pageIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation JSYHCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHCouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHCouponTableViewCell"];
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCouponConnectWithDataloadType:DataLoadTypeNone];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getCouponConnectWithDataloadType:DataLoadTypeMore];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getCouponConnectWithDataloadType:(DataLoadType)dataLoadType {
    _pageIndex = dataLoadType == DataLoadTypeNone ? 0 : _pageIndex + 1;
    [[JSRequestManager sharedManager] getCouponWithPage:[NSString stringWithFormat:@"%ld",_pageIndex] Success:^(id responseObject) {
        if (dataLoadType == DataLoadTypeNone) {
            [self.dataArray removeAllObjects];
        }
        
        NSArray *couponDicArray = responseObject[@"data"][@"coupons"];
        for (NSDictionary *couponDic in couponDicArray) {
            JSYHCouponModel * model = [[JSYHCouponModel alloc] init];
            [model setValuesForKeysWithDictionary:couponDic];
            if (model.is_first == 1 && _shopcount < 2) {
                model.overdue = 1;
            }
            [self.dataArray addObject:model];
        }
        
        if (dataLoadType == DataLoadTypeNone) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        if (dataLoadType == DataLoadTypeNone) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHCouponTableViewCell" forIndexPath:indexPath];
    JSYHCouponModel *model = self.dataArray[indexPath.row];
    cell.couponModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHCouponModel *model = self.dataArray[indexPath.row];
    if (model.overdue == 1) {
        return;
    }
    if (self.chooseCoupon != nil) {
        if (model.is_first && _shopcount < 2) {
            [AppManager showToastWithMsg:@"该订单不支持首单红包"];
            return;
        }
        self.chooseCoupon (model);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
