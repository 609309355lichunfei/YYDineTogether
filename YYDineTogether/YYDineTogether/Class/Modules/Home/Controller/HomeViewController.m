//
//  HomeViewController.m
//  EWDicom
//
//  Created by 李春菲 on 17/6/2.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HomeSearchView.h"
#import "HomeActivityViewController.h"
#import "HomeComboRecomendViewController.h"
#import "HomeClassificationListViewController.h"
#import "HomeStoreViewController.h"
#import "HomeFoodDetailViewController.h"
#import "HomeComboViewController.h"
#import "ShoppingChartViewController.h"
#import "HomeCityViewController.h"
#import "HomeTableViewFunctionCell.h"
#import "JSYHHomeStoreActivityViewController.h"
#import "SDCycleScrollView.h"
#import "JSYHDishModel.h"
#import "JSYHShopModel.h"
#import "HomeDishTableViewCell.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate ,UIGestureRecognizerDelegate, CLLocationManagerDelegate, SDCycleScrollViewDelegate>{
    BOOL _isStoreDataSource;
    NSInteger _cellHeight;
    NSInteger _shoppageIndex;
    NSInteger _dishpageIndex;
}
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBTWidth;
@property (weak, nonatomic) IBOutlet UILabel *shoppingCartCountLabel;
@property (weak, nonatomic) IBOutlet UIView *shoppingcartBGView;

@property (strong, nonatomic) SDCycleScrollView *bannerScrollView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSMutableArray *shopArray;

@property (strong, nonatomic) NSMutableArray *dishArray;

@property (strong, nonatomic) NSMutableArray *bannerImageUrlArray;

@property (strong, nonatomic) HomeSearchView *homeSearchView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (JSYHDishModel *model in self.dishArray) {
        [[ShoppingCartManager sharedManager] updateCountWithModel:model];
    }
    if ([ShoppingCartManager sharedManager].count == 0) {
        self.shoppingCartCountLabel.hidden = YES;
    } else {
        self.shoppingCartCountLabel.hidden = NO;
        self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].count];
    }
    [self.tableView reloadData];
}

- (void)registUI {
//    if ([JSRequestManager sharedManager].token == nil || [JSRequestManager sharedManager].token.length == 0) {
//        
//    }
    [JSYHLocationManager sharedManager];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.tabBarController presentViewController:loginVC animated:YES completion:^{
        
    }];
    self.shoppingCartCountLabel.layer.cornerRadius = 9;
    _isStoreDataSource = YES;
    _cellHeight = 150;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewFunctionCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewFunctionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDishTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeDishTableViewCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_isStoreDataSource) {
            [weakSelf getConnectHomePageShop:DataLoadTypeNone];
        } else {
            [weakSelf getConnectHomePageDish:DataLoadTypeNone];
        }
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        if (_isStoreDataSource) {
            [weakSelf getConnectHomePageShop:DataLoadTypeMore];
        } else {
            [weakSelf getConnectHomePageDish:DataLoadTypeMore];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"JSYHShoppingCartCountChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if ([ShoppingCartManager sharedManager].count == 0) {
            self.shoppingCartCountLabel.hidden = YES;
        } else {
            self.shoppingCartCountLabel.hidden = NO;
            self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].count];
        }
        
    }];
}



- (void)getConnectHomePageShop:(DataLoadType)dataLoadType {
    _shoppageIndex = dataLoadType == DataLoadTypeNone ? 0 : _shoppageIndex + 1;
    [[JSRequestManager sharedManager] homepageShopWithPage:NSStringFormat(@"%ld",_shoppageIndex) lng:[JSYHLocationManager sharedManager].lng lat:[JSYHLocationManager sharedManager].lat Success:^(id responseObject) {
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *shopsArray = dataDic[@"shops"];
        if (shopsArray.count < 20) {
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
        if (dataLoadType == DataLoadTypeNone) {
            [self.shopArray removeAllObjects];
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        for (NSDictionary *dishDic in shopsArray) {
            JSYHShopModel *model = [[JSYHShopModel alloc] init];
            [model setValuesForKeysWithDictionary:dishDic];
            [model updateHeightWithActivity];
            [self.shopArray addObject:model];
        }
        self.dataArray = self.shopArray;
        NSArray *bannersArray = dataDic[@"banners"];
        [self.bannerImageUrlArray removeAllObjects];
        for (NSDictionary *bannerDic in bannersArray) {
            [self.bannerImageUrlArray addObject:bannerDic[@"logo"]];
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

- (void)getConnectHomePageDish:(DataLoadType)dataLoadType {
    _dishpageIndex = dataLoadType == DataLoadTypeNone ? 0 : _dishpageIndex + 1;
    [[JSRequestManager sharedManager] homepageDishWithPage:NSStringFormat(@"%ld",_dishpageIndex) lng:[JSYHLocationManager sharedManager].lng lat:[JSYHLocationManager sharedManager].lat Success:^(id responseObject) {
        
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *dishesArray = dataDic[@"dishs"];
        if (dishesArray.count < 20) {
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
        if (dataLoadType == DataLoadTypeNone) {
            [self.dishArray removeAllObjects];
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        for (NSDictionary *dishDic in dishesArray) {
            JSYHDishModel *model = [[JSYHDishModel alloc] init];
            [model setValuesForKeysWithDictionary:dishDic];
            [[ShoppingCartManager sharedManager] updateCountWithModel:model];
            [self.dishArray addObject:model];
        }
        self.dataArray = self.dishArray;
        NSArray *bannersArray = dataDic[@"banners"];
        [self.bannerImageUrlArray removeAllObjects];
        for (NSDictionary *bannerDic in bannersArray) {
            [self.bannerImageUrlArray addObject:bannerDic[@"logo"]];
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

- (IBAction)cancelAction:(id)sender {
    [self.searchBar resignFirstResponder];
    self.barView.backgroundColor = [UIColor clearColor];
    [_homeSearchView removeFromSuperview];
    self.cancelBTWidth.constant = 1;
}

- (IBAction)locationAction:(id)sender {
    HomeCityViewController *cityVC = [[HomeCityViewController alloc]init];
    cityVC.cityLabel = self.cityLabel;
    [self presentViewController:cityVC animated:YES completion:nil];
}
- (IBAction)shoppingCartTapAction:(id)sender {
    [self shoppingCartAction:nil];
}

- (void)shoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:shoppingCartVC animated:YES];
}

- (void)cateAction:(id)sender {
    HomeClassificationListViewController *classificationVC = [[HomeClassificationListViewController alloc]init];
    [self.tabBarController.navigationController pushViewController:classificationVC animated:YES
     ];
}

- (void)drinkAction:(id)sender {
    HomeStoreViewController *controller = [[HomeStoreViewController alloc]init];
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
}

- (void)fruitAction:(id)sender {
    
    HomeActivityViewController *controller = [[HomeActivityViewController alloc]init];
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
    
}
- (void)supermarketAction:(id)sender {
    
    HomeActivityViewController *controller = [[HomeActivityViewController alloc]init];
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
    
}

- (void)activityAction{
    JSYHHomeStoreActivityViewController *activityVC = [[JSYHHomeStoreActivityViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:activityVC animated:YES];
}

- (IBAction)comboActivityAction:(id)sender {
    HomeComboRecomendViewController *comboVC = [[HomeComboRecomendViewController alloc]init];
    comboVC.type = ViewControllerTypeTypeStore;
    [self.tabBarController.navigationController pushViewController:comboVC animated:YES];
}
- (IBAction)comboAction:(id)sender {
    HomeComboViewController *comboVC = [[HomeComboViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:comboVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 475;
    }
    if (_isStoreDataSource) {
        JSYHShopModel *model = self.shopArray[indexPath.row];
        return model.height;
    }
    return _cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeTableViewFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewFunctionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MJWeakSelf;
        cell.cateBlock = ^(){
            [weakSelf cateAction:nil];
        };
        cell.drinkBlock = ^(){
           // [weakSelf drinkAction:nil];
        };
        cell.comboBlock = ^(){
            [weakSelf comboAction:nil];
        };
        cell.fruitBlock = ^(){
           // [weakSelf fruitAction:nil];
        };
        cell.supermarketBlock = ^(){
           // [weakSelf supermarketAction:nil];
        };
        cell.activity = ^(){
            [weakSelf activityAction];
        };
        __weak HomeTableViewFunctionCell *weakCell = cell;
        cell.merchantBlock = ^(){
            if (!_isStoreDataSource) {
                [weakCell.merchantBt setTitleColor:RGB(253, 89, 95) forState:(UIControlStateNormal)];
                [weakCell.dishesBt setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                _isStoreDataSource = YES;
                _cellHeight = 150;
                self.dataArray = self.shopArray;
                [self.tableView reloadSection:1 withRowAnimation:(UITableViewRowAnimationNone)];
            }
        };
        cell.dishesBlock = ^(){
            if (_isStoreDataSource) {
                [weakCell.dishesBt setTitleColor:RGB(253, 89, 95) forState:(UIControlStateNormal)];
                [weakCell.merchantBt setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                _isStoreDataSource = NO;
                _cellHeight = 100;
                self.dataArray = self.dishArray;
                [self.tableView reloadSection:1 withRowAnimation:(UITableViewRowAnimationNone)];
                if (self.dishArray.count == 0) {
                    [self.tableView.mj_header beginRefreshing];
                }
            }
        };
        if (self.bannerScrollView == nil) {
            self.bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, 128) imageURLStringsGroup:self.bannerImageUrlArray];
            self.bannerScrollView.delegate = self;
            [cell.activityView addSubview:self.bannerScrollView];
        } else {
            self.bannerScrollView.imageURLStringsGroup = self.bannerImageUrlArray;
        }
        return cell;
    }
    if (_isStoreDataSource) {
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        JSYHShopModel *model = self.shopArray[indexPath.row];
        cell.shopModel = model;
        return cell;
    } else {
        HomeDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeDishTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        JSYHDishModel *model = self.dishArray[indexPath.row];
        cell.dishModel = model;
        return cell;
    }
    
    
    
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    if (_isStoreDataSource) {
        HomeStoreViewController *storeVC = [[HomeStoreViewController alloc] init];
        JSYHShopModel *model = self.shopArray[indexPath.row];
        storeVC.shopid = [model.shopid stringValue];
        [self.tabBarController.navigationController pushViewController:storeVC animated:YES];
    } else {
        HomeFoodDetailViewController *controller = [[HomeFoodDetailViewController alloc]init];
        JSYHDishModel *model = self.dishArray[indexPath.row];
//        NSString *dishId = [model.dishid stringValue];
        controller.dishModel = model;
        [self.tabBarController.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (self.homeSearchView == nil) {
        self.homeSearchView = [[[NSBundle mainBundle] loadNibNamed:@"HomeSearchView" owner:self options:nil] lastObject];
    }
    _homeSearchView.frame = CGRectMake(0, 64, KScreenWidth, kScreenHeight - 64);
    [self.view addSubview:_homeSearchView];
    self.barView.backgroundColor = [UIColor whiteColor];
    self.cancelBTWidth.constant = 46;
    _homeSearchView.type = SearchViewTypeSearch;
    __weak HomeSearchView *weakSearchView = _homeSearchView;
    _homeSearchView.didSelectBlock = ^(NSString *keyword){
        [searchBar resignFirstResponder];
        weakSearchView.type = SearchViewTypeResult;
        [weakSearchView getConnectWithSearchKeyWord:keyword];
        searchBar.text = keyword;
    };
    [self.view bringSubviewToFront:self.shoppingcartBGView];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.homeSearchView.type = SearchViewTypeResult;
    [self.homeSearchView getConnectWithSearchKeyWord:searchBar.text];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    JSYHHomeStoreActivityViewController *activityVC = [[JSYHHomeStoreActivityViewController alloc] init];
    activityVC.type = [NSString stringWithFormat:@"%ld",index + 1];
    [self.tabBarController.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)shopArray {
    if (_shopArray  == nil) {
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

- (NSMutableArray *)bannerImageUrlArray {
    if (_bannerImageUrlArray == nil) {
        _bannerImageUrlArray = [NSMutableArray array];
    }
    return _bannerImageUrlArray;
}



@end
