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
#import "JSYHComboModel.h"
#import "HomeDishTableViewCell.h"
#import "JSYHDrinkViewController.h"
#import "JSYHCombListTableViewCell.h"
#import "JSYHMSSearchViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate ,UIGestureRecognizerDelegate, CLLocationManagerDelegate, SDCycleScrollViewDelegate, CAAnimationDelegate>{
    BOOL _isStoreDataSource;
    NSInteger _cellHeight;
    NSInteger _shoppageIndex;
    NSInteger _dishpageIndex;
    NSInteger _combpageIndex;
    CGFloat _lastOffSideY;
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

@property (strong, nonatomic) NSMutableArray *combArray;

@property (strong, nonatomic) NSMutableArray *bannerImageUrlArray;

@property (strong, nonatomic) HomeSearchView *homeSearchView;

@property (strong, nonatomic) UIBezierPath *path;
@property (nonatomic, strong) CALayer *dotLayer;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registUI];
    NSNumber *a = @(1.50);
    NSLog(@"====%@",a);
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
    _lastOffSideY = 0;
    [JSYHLocationManager sharedManager];
    
    self.shoppingCartCountLabel.layer.cornerRadius = 9;
    _isStoreDataSource = YES;
    _cellHeight = 150;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewFunctionCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewFunctionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDishTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeDishTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHCombListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHHomePageCombListTableViewCell"];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_isStoreDataSource) {
            [weakSelf getConnectHomePageComb:DataLoadTypeNone];
        } else {
            [weakSelf getConnectHomePageDish:DataLoadTypeNone];
        }
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        if (_isStoreDataSource) {
            [weakSelf getConnectHomePageComb:DataLoadTypeMore];
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

- (void)getConnectHomePageComb:(DataLoadType)dataloadType {
    _combpageIndex = dataloadType == DataLoadTypeNone ? 0 : _combpageIndex + 1;
    [[JSRequestManager sharedManager] homepageCombWithPage:[NSString stringWithFormat:@"%ld",_combpageIndex] lng:[JSYHLocationManager sharedManager].lng lat:[JSYHLocationManager sharedManager].lat Success:^(id responseObject) {
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *carttips = dataDic[@"carttips"];
        [ShoppingCartManager sharedManager].carttips = carttips;
        NSArray *combsArray = dataDic[@"combs"];
        if (combsArray.count < 20) {
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
        if (dataloadType == DataLoadTypeNone) {
            [self.combArray removeAllObjects];
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        for (NSDictionary *combDic in combsArray) {
            JSYHComboModel *model = [[JSYHComboModel alloc] init];
            [model setValuesForKeysWithDictionary:combDic];
            [self.combArray addObject:model];
        }
        self.dataArray = self.combArray;
        NSArray *bannersArray = dataDic[@"banners"];
        [self.bannerImageUrlArray removeAllObjects];
        for (NSDictionary *bannerDic in bannersArray) {
            [self.bannerImageUrlArray addObject:bannerDic[@"logo"]];
        }
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        if (dataloadType == DataLoadTypeNone) {
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
    JSYHDrinkViewController *controller = [[JSYHDrinkViewController alloc]init];
    controller.tagId = @"2";
    controller.titleStr = @"饮料";
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
}

- (void)fruitAction:(id)sender {
    
    JSYHDrinkViewController *controller = [[JSYHDrinkViewController alloc]init];
    controller.tagId = @"3";
    controller.titleStr = @"水果";
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
    
}
- (void)supermarketAction:(id)sender {
    
    JSYHDrinkViewController *controller = [[JSYHDrinkViewController alloc]init];
    controller.tagId = @"4";
    controller.titleStr = @"超市";
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
    
}

- (void)activityAction{
    JSYHHomeStoreActivityViewController *activityVC = [[JSYHHomeStoreActivityViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:activityVC animated:YES];
}

- (IBAction)comboActivityAction:(id)sender {
    HomeComboRecomendViewController *comboVC = [[HomeComboRecomendViewController alloc]init];
    [self.tabBarController.navigationController pushViewController:comboVC animated:YES];
}
- (IBAction)comboAction:(id)sender {
    HomeComboViewController *comboVC = [[HomeComboViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:comboVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 142 + KScreenWidth * 650 / 750;
    }
    if (_isStoreDataSource) {
//        JSYHShopModel *model = self.shopArray[indexPath.row];
        return 230;
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
                self.dataArray = self.combArray;
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
            self.bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth * 188 / 750) imageURLStringsGroup:self.bannerImageUrlArray];
            self.bannerScrollView.delegate = self;
            [cell.activityView addSubview:self.bannerScrollView];
        } else {
            self.bannerScrollView.imageURLStringsGroup = self.bannerImageUrlArray;
        }
        return cell;
    }
    if (_isStoreDataSource) {
//        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        JSYHShopModel *model = self.shopArray[indexPath.row];
//        cell.shopModel = model;
//        return cell;
        JSYHCombListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHHomePageCombListTableViewCell" forIndexPath:indexPath];
        __weak JSYHCombListTableViewCell *weakCell = cell;
        cell.addBlock = ^{
            CGRect parentRect = [weakCell convertRect:weakCell.addBT.frame toView:self.view];
            
            // 这里是动画开始的方法
            [self joinCartAnimationWithRect:parentRect];
        };
        MJWeakSelf;
        cell.didSelectBlock = ^{
            HomeActivityViewController *combVC = [[HomeActivityViewController alloc] init];
            JSYHComboModel *model = _dataArray[indexPath.row];
            combVC.combId = model.combid.stringValue;
            [weakSelf.tabBarController.navigationController pushViewController:combVC animated:YES];
        };
        JSYHComboModel *combModel = self.dataArray[indexPath.row];
        cell.combModel = combModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        HomeDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeDishTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        JSYHDishModel *model = self.dishArray[indexPath.row];
        cell.dishModel = model;
        return cell;
    }
}

#pragma mark -加入购物车动画
-(void)joinCartAnimationWithRect:(CGRect)rect
{
    CGFloat endPoint_x = 50;
    CGFloat endPoint_y = kScreenHeight - 100;
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    
    //三点曲线
    [_path addCurveToPoint:CGPointMake(endPoint_x, endPoint_y)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(startX - 180, startY - 200)];
    _dotLayer = [CALayer layer];
    _dotLayer.backgroundColor = UIColorFromRGB(0xfd5352).CGColor;
    _dotLayer.frame = CGRectMake(0, 0, 20, 20);
    _dotLayer.cornerRadius = 10;
    [self.view.layer addSublayer:_dotLayer];
    [self groupAnimation];
}
#pragma mark - 组合动画
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.6f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_dotLayer addAnimation:groups forKey:nil];
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.6f];
}
- (void)removeFromLayer:(CALayer *)layerAnimation{
    
    [layerAnimation removeFromSuperlayer];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:0.9];
        shakeAnimation.toValue = [NSNumber numberWithFloat:1];
        shakeAnimation.autoreverses = YES;
        // 这里是下方的自定义View上面 放的btn. 自己随便定义一个 0.-
        //        [_shopCartView.btnBackImg.layer addAnimation:shakeAnimation forKey:nil];
        
        
        [_shoppingCartCountLabel.layer addAnimation:shakeAnimation forKey:nil];
        
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    if (_isStoreDataSource) {
//        HomeStoreViewController *storeVC = [[HomeStoreViewController alloc] init];
//        JSYHShopModel *model = self.shopArray[indexPath.row];
//        storeVC.shopid = [model.shopid stringValue];
//        [self.tabBarController.navigationController pushViewController:storeVC animated:YES];
        HomeActivityViewController *combVC = [[HomeActivityViewController alloc] init];
        JSYHComboModel *model = self.dataArray[indexPath.row];
        combVC.combId = model.combid.stringValue;
        [self.tabBarController.navigationController pushViewController:combVC animated:YES];
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
//    if (self.homeSearchView == nil) {
//        self.homeSearchView = [[[NSBundle mainBundle] loadNibNamed:@"HomeSearchView" owner:self options:nil] lastObject];
//    }
//    _homeSearchView.frame = CGRectMake(0, 64, KScreenWidth, kScreenHeight - 64);
//    [self.view addSubview:_homeSearchView];
//    self.barView.backgroundColor = [UIColor whiteColor];
//    self.cancelBTWidth.constant = 46;
//    _homeSearchView.type = SearchViewTypeSearch;
//    __weak HomeSearchView *weakSearchView = _homeSearchView;
//    _homeSearchView.didSelectBlock = ^(NSString *keyword){
//        [searchBar resignFirstResponder];
//        weakSearchView.type = SearchViewTypeResult;
//        [weakSearchView getConnectWithSearchKeyWord:keyword];
//        searchBar.text = keyword;
//    };
//    [self.view bringSubviewToFront:self.shoppingcartBGView];
    JSYHMSSearchViewController *searchVC = [[JSYHMSSearchViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [searchBar resignFirstResponder];
//    self.homeSearchView.type = SearchViewTypeResult;
//    [self.homeSearchView getConnectWithSearchKeyWord:searchBar.text];
//}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (index == 0) {
        JSYHHomeStoreActivityViewController *activityVC = [[JSYHHomeStoreActivityViewController alloc] init];
        activityVC.type = [NSString stringWithFormat:@"%ld",index + 1];
        [self.tabBarController.navigationController pushViewController:activityVC animated:YES];
    } else if (index == 1) {
        HomeComboRecomendViewController *combVC = [[HomeComboRecomendViewController alloc] init];
        combVC.mytitle = @"套餐活动";
        [self.tabBarController.navigationController pushViewController:combVC animated:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > _lastOffSideY && scrollView.contentOffset.y > 30) {
        self.barView.hidden = YES;
    } else {
        self.barView.hidden = NO;
        if (scrollView.contentOffset.y > 100) {
            self.barView.backgroundColor = [UIColor whiteColor];
        } else {
            self.barView.backgroundColor = [UIColor clearColor];
        }
    }
    _lastOffSideY = scrollView.contentOffset.y;
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

- (NSMutableArray *)combArray {
    if (_combArray == nil) {
        _combArray = [NSMutableArray array];
    }
    return _combArray;
}

- (NSMutableArray *)bannerImageUrlArray {
    if (_bannerImageUrlArray == nil) {
        _bannerImageUrlArray = [NSMutableArray array];
    }
    return _bannerImageUrlArray;
}



@end
