//
//  HomeClassificationListViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/11.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeClassificationListViewController.h"
#import "HomeTableViewCell.h"
#import "HomeFilterView.h"
#import "HomeStoreViewController.h"
#import "HomeStandardChooseView.h"
#import "HomeDishTableViewCell.h"
#import "JSYHShopModel.h"
#import "JSYHDishModel.h"

@interface HomeClassificationListViewController ()<UITableViewDelegate, UITableViewDataSource, HomeFilterViewDelegate>{
    BOOL _isShops;
    NSInteger _shoppageIndex;
    NSInteger _dishpageIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSMutableArray *shopArray;

@property (strong, nonatomic) NSMutableArray *dishArray;

@property (strong, nonatomic) HomeShoppingCartView *shoppingView;

@property (strong, nonatomic)  HomeFilterView *filterView;


@end

@implementation HomeClassificationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)getConnectWithShops:(DataLoadType)dataLoadType {
    _shoppageIndex = dataLoadType == DataLoadTypeNone ? 0 : _shoppageIndex + 1;
    [[JSRequestManager sharedManager] shopsWithPage:NSStringFormat(@"%ld",(long)_shoppageIndex) lng:@"122.34321" lat:@"32.2222" tagid:@"0" Success:^(id responseObject) {
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *shopsArray = dataDic[@"shops"];
        if (dataLoadType == DataLoadTypeNone) {
            [self.tableView.mj_header endRefreshing];
            [self.shopArray removeAllObjects];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        for (NSDictionary *shopDic in shopsArray) {
            JSYHDishModel *model = [[JSYHDishModel alloc] init];
            [model setValuesForKeysWithDictionary:shopDic];
            [[ShoppingCartManager sharedManager] updateCountWithModel:model];
            [self.shopArray addObject:model];
        }
        self.dataArray = self.shopArray;
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        if (dataLoadType == DataLoadTypeNone) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)getConnectWithDish:(DataLoadType)dataloadType {
    _dishpageIndex = dataloadType == DataLoadTypeNone ? 0 : _dishpageIndex + 1;
}

- (void)registUI {
    _isShops = YES;
    MJWeakSelf;
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_isShops) {
            [weakSelf getConnectWithShops:DataLoadTypeNone];
        } else {
            
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        if (_isShops) {
            [weakSelf getConnectWithShops:DataLoadTypeMore];
        } else {
            
        }
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeClassificationTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDishTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeClassificationDishTableViewCell"];
    [self.tableView.mj_header beginRefreshing];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchAction:(id)sender {
    
}

- (IBAction)filterAction:(id)sender {
    if (_filterView.superview == _mainView) {
        [self.filterView removeFromSuperview];
        return;
    }
    self.filterView = [[[NSBundle mainBundle] loadNibNamed:@"HomeFilterView" owner:self options:nil] lastObject];
    self.filterView.frame = self.mainView.bounds;
    self.filterView.delegate = self;
    [self.mainView addSubview:self.filterView];
}

- (IBAction)changeTityle:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _isShops = YES;
    } else {
        _isShops = NO;
        
    }
    [self.tableView reloadData];
}

- (IBAction)clearShoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

- (IBAction)shoppingCartAction:(id)sender {
    if (_shoppingView == nil) {
        self.shoppingView = [[[NSBundle mainBundle] loadNibNamed:@"HomeShoppingCartView" owner:self options:nil] lastObject];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [_shoppingView removeShoppingCartView];
            _shoppingView = nil;
        }];
        [_shoppingView addGestureRecognizer:tap];
        [_shoppingView showShoppingCartView];
    } else {
        [_shoppingView removeShoppingCartView];
        _shoppingView = nil;
    }
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isShops) {
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeClassificationTableViewCell" forIndexPath:indexPath];
        JSYHShopModel *model = self.shopArray[indexPath.row];
        cell.shopModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        HomeDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeClassificationDishTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeStoreViewController *storeVC = [[HomeStoreViewController alloc] init];
    [self.navigationController pushViewController:storeVC animated:YES];
}

#pragma mark - HomeFilterViewDelegate
- (void)homeFilterViewSelectedString:(NSString *)string {
    
}

#pragma makr - 懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)shopArray {
    if (_shopArray == nil) {
        _shopArray = [NSMutableArray array];
    }
    return _shopArray;
}

- (NSMutableArray *)dishArray {
    if (_dishArray == nil) {
        _dishArray = [NSMutableArray array];
    }
    return _dishArray;
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
