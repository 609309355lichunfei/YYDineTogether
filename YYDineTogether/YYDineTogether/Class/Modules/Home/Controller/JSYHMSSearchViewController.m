//
//  JSYHMSSearchViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/8.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHMSSearchViewController.h"
#import "HomeSearchView.h"

@interface JSYHMSSearchViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoppingCartCountLabel;
@property (weak, nonatomic) IBOutlet UIView *shopcartBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopcartBGViewHeight;

@property (strong, nonatomic) HomeSearchView *homeSearchView;

@end

@implementation JSYHMSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registUI];
}

- (void)registUI {
    self.shoppingCartCountLabel.layer.cornerRadius = 9;
    if ([ShoppingCartManager sharedManager].count == 0) {
        self.shoppingCartCountLabel.hidden = YES;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
    } else {
        self.shoppingCartCountLabel.hidden = NO;
        self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].count];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
    }
    [[NSNotificationCenter defaultCenter] addObserverForName:@"JSYHShoppingCartCountChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if ([ShoppingCartManager sharedManager].count == 0) {
            self.shoppingCartCountLabel.hidden = YES;
            self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
        } else {
            self.shoppingCartCountLabel.hidden = NO;
            self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].count];
            self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
        }
        
    }];
    
    
    if (self.homeSearchView == nil) {
        self.homeSearchView = [[[NSBundle mainBundle] loadNibNamed:@"HomeSearchView" owner:self options:nil] lastObject];
    }
    _homeSearchView.frame = self.mainView.bounds;
    [self.mainView addSubview:_homeSearchView];
    _homeSearchView.type = SearchViewTypeSearch;
    __weak HomeSearchView *weakSearchView = _homeSearchView;
    MJWeakSelf;
    _homeSearchView.didSelectBlock = ^(NSString *keyword){
        [weakSelf.mySearchBar resignFirstResponder];
        weakSearchView.type = SearchViewTypeResult;
        weakSelf.shopcartBGViewHeight.constant = 45;
        [weakSearchView getConnectWithSearchKeyWord:keyword];
        weakSelf.mySearchBar.text = keyword;
    };
}

- (IBAction)clearShoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _homeSearchView.type = SearchViewTypeSearch;
    self.shopcartBGViewHeight.constant = 0;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.homeSearchView.type = SearchViewTypeResult;
    self.shopcartBGViewHeight.constant = 45;
    [self.homeSearchView getConnectWithSearchKeyWord:searchBar.text];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
