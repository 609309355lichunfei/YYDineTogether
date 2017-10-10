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
#import "JSYHMSShopViewController.h"
#import "JSYHMSDishViewController.h"
#import "JSYHMSSearchViewController.h"

@interface HomeClassificationListViewController ()<HomeFilterViewDelegate>{
    BOOL _isShops;
    NSInteger _shoppageIndex;
    NSInteger _dishpageIndex;
}
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UILabel *shoppingCartCountLabel;
@property (weak, nonatomic) IBOutlet UIView *shoppingcartBGView;



@property (strong, nonatomic)  HomeFilterView *filterView;


@property (strong, nonatomic) JSYHMSShopViewController *shopVC;
@property (strong, nonatomic) JSYHMSDishViewController *dishVC;


@end

@implementation HomeClassificationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    self.shoppingCartCountLabel.layer.cornerRadius = 9;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isShops = YES;
    
    
    self.shopVC = [[JSYHMSShopViewController alloc] init];
    self.shopVC.view.frame = self.mainView.bounds;
    self.shopVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addChildViewController:self.shopVC];
    [self.mainView addSubview:self.shopVC.view];
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

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchAction:(id)sender {
    JSYHMSSearchViewController *searchVC = [[JSYHMSSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
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
        [self.dishVC.view removeFromSuperview];
        [self.dishVC willMoveToParentViewController:nil];
        [self.dishVC removeFromParentViewController];
        [self.dishVC didMoveToParentViewController:nil];
        [self addChildViewController:self.shopVC];
        self.shopVC.view.frame = self.mainView.bounds;
        self.shopVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.mainView addSubview:self.shopVC.view];
    } else {
        if (self.dishVC == nil) {
            self.dishVC = [[JSYHMSDishViewController alloc] init];
        }
        [self.shopVC.view removeFromSuperview];
        [self.shopVC willMoveToParentViewController:nil];
        [self.shopVC removeFromParentViewController];
        [self.shopVC didMoveToParentViewController:nil];
        [self addChildViewController:self.dishVC];
        self.dishVC.view.frame = self.mainView.bounds;
        self.dishVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.mainView addSubview:self.dishVC.view];
    }
}

- (IBAction)clearShoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

#pragma mark - HomeFilterViewDelegate
- (void)homeFilterViewSelectedString:(NSString *)string {
    
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
