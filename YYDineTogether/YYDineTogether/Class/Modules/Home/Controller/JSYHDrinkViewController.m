//
//  JSYHDrinkViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/8.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHDrinkViewController.h"
#import "JSYHShopModel.h"
#import "HomeTableViewCell.h"
#import "HomeStoreViewController.h"

@interface JSYHDrinkViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger _pageIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *shoppingCartCountLabel;
@property (weak, nonatomic) IBOutlet UIView *shoppingcartBGView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation JSYHDrinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ShoppingCartManager sharedManager].count == 0) {
        self.shoppingCartCountLabel.hidden = YES;
    } else {
        self.shoppingCartCountLabel.hidden = NO;
        self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].count];
    }
}

- (void)registUI {
    self.shoppingCartCountLabel.layer.cornerRadius = 9;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTitleLabel.text = self.titleStr;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHDrinkTableViewCell"];
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getConnectWithDataLoadType:DataLoadTypeNone];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getConnectWithDataLoadType:DataLoadTypeMore];
    }];
    [self.tableView.mj_header beginRefreshing];

}

- (void)getConnectWithDataLoadType:(DataLoadType)dataLoadType {
    _pageIndex = dataLoadType == DataLoadTypeNone ? 0 : _pageIndex + 1;
    [[JSRequestManager sharedManager] shopsWithPage:[NSString stringWithFormat:@"%ld",_pageIndex] lng:[JSYHLocationManager sharedManager].lng lat:[JSYHLocationManager sharedManager].lat tagid:_tagId Success:^(id responseObject) {
        
        
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *shopsArray = dataDic[@"shops"];
        if (dataLoadType == DataLoadTypeNone) {
            [self.tableView.mj_header endRefreshing];
            [self.dataArray removeAllObjects];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        for (NSDictionary *shopDic in shopsArray) {
            JSYHShopModel *model = [[JSYHShopModel alloc] init];
            [model setValuesForKeysWithDictionary:shopDic];
            [model updateHeightWithActivity];
            [self.dataArray addObject:model];
        }
        self.tableView.mj_footer.hidden = shopsArray.count < 20 ? YES : NO;
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        if (dataLoadType == DataLoadTypeNone) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearShoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHShopModel *model = self.dataArray[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHDrinkTableViewCell" forIndexPath:indexPath];
    JSYHShopModel *model = self.dataArray[indexPath.row];
    cell.shopModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeStoreViewController *storeVC = [[HomeStoreViewController alloc] init];
    JSYHShopModel *model = self.dataArray[indexPath.row];
    storeVC.shopid = [model.shopid stringValue];
    [self.navigationController pushViewController:storeVC animated:YES];
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
