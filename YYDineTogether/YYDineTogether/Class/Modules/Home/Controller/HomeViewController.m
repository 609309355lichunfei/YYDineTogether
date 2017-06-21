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


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate>{
    BOOL _isStoreDataSource;
    CGFloat _mainScrollViewLastContentOffSetY;
    CGFloat _tableViewLastContentOffSetY;
}
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (strong, nonatomic) HomeSearchView *homeSearchView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registUI];
}

- (void)registUI {
    _isStoreDataSource = YES;
    _mainScrollViewLastContentOffSetY = 0;
    _tableViewLastContentOffSetY = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
}

- (IBAction)locationAction:(id)sender {
    HomeCityViewController *cityVC = [[HomeCityViewController alloc]init];
    cityVC.cityLabel = self.cityLabel;
    [self presentViewController:cityVC animated:YES completion:nil];
}

- (IBAction)shoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:shoppingCartVC animated:YES];
}

- (IBAction)cateAction:(id)sender {
    HomeClassificationListViewController *classificationVC = [[HomeClassificationListViewController alloc]init];
    [self.tabBarController.navigationController pushViewController:classificationVC animated:YES
     ];
}

- (IBAction)drinkAction:(id)sender {
    HomeStoreViewController *controller = [[HomeStoreViewController alloc]init];
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
}

- (IBAction)fruitAction:(id)sender {
    
    HomeActivityViewController *controller = [[HomeActivityViewController alloc]init];
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
    
}
- (IBAction)supermarketAction:(id)sender {
    
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

- (IBAction)storeAction:(id)sender {
    if (!_isStoreDataSource) {
        [_storeButton setTitleColor:RGB(219, 82, 64) forState:(UIControlStateNormal)];
        [_foodButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _isStoreDataSource = YES;
        [self.tableView reloadData];
    }
}

- (IBAction)foodAction:(id)sender {
    if (_isStoreDataSource) {
        [_foodButton setTitleColor:RGB(219, 82, 64) forState:(UIControlStateNormal)];
        [_storeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _isStoreDataSource = NO;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = _isStoreDataSource ? ViewControllerTypeTypeStore : ViewControllerTypeTypeFood;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [_homeSearchView removeFromSuperview];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [_homeSearchView removeFromSuperview];
    [_mainScrollView setContentOffset:CGPointMake(0, 256) animated:NO];
    _mainScrollView.scrollEnabled = NO;
    _tableView.scrollEnabled = YES;
    _tableView.bounces = YES;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        if (scrollView.contentOffset.y > 240) {
            if (scrollView.contentOffset.y > _mainScrollViewLastContentOffSetY) {
                [scrollView scrollToBottomAnimated:NO];
                scrollView.scrollEnabled = NO;
                _tableView.scrollEnabled = YES;
                _tableView.bounces = YES;
            }
        }
        
        _mainScrollViewLastContentOffSetY = scrollView.contentOffset.y;
    }
    
    if (scrollView == _tableView) {
        if (scrollView.contentOffset.y < 10) {
            if (scrollView.contentOffset.y < _tableViewLastContentOffSetY) {
                [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                scrollView.scrollEnabled = NO;
                _mainScrollView.scrollEnabled = YES;
                _mainScrollView.bounces = YES;
            }
        }
        _tableViewLastContentOffSetY = scrollView.contentOffset.y;
    }
}

@end
