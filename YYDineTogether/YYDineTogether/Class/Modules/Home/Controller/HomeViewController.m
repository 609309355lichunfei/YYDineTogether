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


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate ,UIGestureRecognizerDelegate>{
    BOOL _isStoreDataSource;
}
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (strong, nonatomic) HomeSearchView *homeSearchView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registUI];
    [PPNetworkHelper POST:URL_Register parameters:@{@"username":@"15325747141",@"password":@"123456"} success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)registUI {
    _isStoreDataSource = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewFunctionCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewFunctionCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (IBAction)locationAction:(id)sender {
    HomeCityViewController *cityVC = [[HomeCityViewController alloc]init];
    cityVC.cityLabel = self.cityLabel;
    [self presentViewController:cityVC animated:YES completion:nil];
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
        return 507;
    }
    return 128;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 20;
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
            [weakSelf drinkAction:nil];
        };
        cell.comboBlock = ^(){
            [weakSelf comboAction:nil];
        };
        cell.fruitBlock = ^(){
            [weakSelf fruitAction:nil];
        };
        cell.supermarketBlock = ^(){
            [weakSelf supermarketAction:nil];
        };
        __weak HomeTableViewFunctionCell *weakCell = cell;
        cell.merchantBlock = ^(){
            if (!_isStoreDataSource) {
                [weakCell.merchantBt setTitleColor:RGB(253, 89, 95) forState:(UIControlStateNormal)];
                [weakCell.dishesBt setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                _isStoreDataSource = YES;
                [weakSelf.tableView reloadSection:1 withRowAnimation:(UITableViewRowAnimationNone)];
            }
        };
        cell.dishesBlock = ^(){
            if (_isStoreDataSource) {
                [weakCell.dishesBt setTitleColor:RGB(253, 89, 95) forState:(UIControlStateNormal)];
                [weakCell.merchantBt setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                _isStoreDataSource = NO;
                [weakSelf.tableView reloadSection:1 withRowAnimation:(UITableViewRowAnimationNone)];
            }
        };
        return cell;
    }
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = _isStoreDataSource ? ViewControllerTypeTypeStore : ViewControllerTypeTypeFood;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    if (_isStoreDataSource) {
        HomeStoreViewController *storeVC = [[HomeStoreViewController alloc] init];
        [self.tabBarController.navigationController pushViewController:storeVC animated:YES];
    } else {
        HomeFoodDetailViewController *controller = [[HomeFoodDetailViewController alloc]init];
        [self.tabBarController.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.homeSearchView = [[[NSBundle mainBundle] loadNibNamed:@"HomeSearchView" owner:self options:nil] lastObject];
    _homeSearchView.frame = CGRectMake(0, 64, KScreenWidth, kScreenHeight - 64);
    [kAppWindow addSubview:_homeSearchView];
    self.barView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [_homeSearchView removeFromSuperview];
    if (_tableView.contentOffset.y > 450) {
        self.barView.backgroundColor = [UIColor whiteColor];
    } else {
        self.barView.backgroundColor = [UIColor clearColor];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [_homeSearchView removeFromSuperview];
    _tableView.scrollEnabled = YES;
    _tableView.bounces = YES;
    if (_tableView.contentOffset.y > 450) {
        self.barView.backgroundColor = [UIColor whiteColor];
    } else {
        self.barView.backgroundColor = [UIColor clearColor];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 450) {
        self.barView.backgroundColor = [UIColor whiteColor];
    } else {
        self.barView.backgroundColor = [UIColor clearColor];
    }
}


@end
