//
//  HomeStoreViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/11.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeStoreViewController.h"
#import "HomeStoreRightTableViewCell.h"
#import "HomeFoodDetailViewController.h"
#import "HomeActivityViewController.h"
#import "HomeStandardChooseView.h"
#import "JSYHHomeStoreActivityView.h"
#import "JSYHShopModel.h"
#import "JSYHCateModel.h"
#import "JSYHActivityModel.h"
#import "JSYHHomeStoreLeftTableViewCell.h"

@interface HomeStoreViewController ()<UITableViewDelegate, UITableViewDataSource>{
    BOOL _isCombo;
    BOOL _isScroll;
}
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UIButton *comboButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoppingCartBTBottom;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *activityButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *shoppingCartCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;


@property (strong, nonatomic) NSMutableArray *catesArray;


@property (strong, nonatomic) JSYHShopModel *shopModel;


@end

@implementation HomeStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)getConnectShopDetail {
    [MBProgressHUD showMessage:@"进入店铺"];
    [[JSRequestManager sharedManager] shopDetailWithShopid:self.shopid Success:^(id responseObject) {
        NSDictionary *dataDic = responseObject[@"data"];
        NSDictionary *shop = dataDic[@"shop"];
        self.shopModel = [[JSYHShopModel alloc] init];
        [self.shopModel setValuesForKeysWithDictionary:shop];
        [self fillData];
        [MBProgressHUD hideHUD];
    } Failed:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
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
    _isCombo = NO;
    [self.leftTableView registerNib:[UINib nibWithNibName:@"JSYHHomeStoreLeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeStoreLeftTableViewCell"];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"HomeStoreRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeStoreRightTableViewCell"];
    
    //  创建需要的毛玻璃特效类型
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    //  毛玻璃view 视图
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    //添加到要有毛玻璃特效的控件中
    
    effectView.frame = [UIScreen mainScreen].bounds;
    
    [self.backgroundImageView addSubview:effectView];
    
    //设置模糊透明度
    
    effectView.alpha = 1;

    
    
    [self getConnectShopDetail];
}

- (void)fillData {
    self.shopNameLabel.text = _shopModel.name;
    self.noticeLabel.text = _shopModel.notice_info;
    self.catesArray = self.shopModel.cates;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:self.shopModel.logo] placeholder:[UIImage imageNamed:@"icon"]];
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:self.shopModel.logo] placeholder:[UIImage imageNamed:@"icon"]];
    [self.activityButton setTitle:[NSString stringWithFormat:@"%ld个活动",_shopModel.activites.count] forState:(UIControlStateNormal)];
    for (NSInteger i = 0; i < _shopModel.activites.count; i ++){
        JSYHActivityModel *model = _shopModel.activites[i];
        JSYHHomeStoreActivityView *view = [[[NSBundle mainBundle] loadNibNamed:@"JSYHHomeStoreActivityView" owner:self options:nil] lastObject];
        view.frame = CGRectMake(8, 4 + i * 20, 100, 20);
        [self.activityView addSubview:view];
        [view setActivityModel:model];
    }
    [self.leftTableView reloadData];
    if (_shopModel.cates.count > 0) {
        [self.rightTableView reloadData];
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionTop)];
        [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)flowAction:(id)sender {
    
}

- (IBAction)clearShoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

- (IBAction)foodAction:(id)sender {
    if (_isCombo) {
        [_foodButton setTitleColor:RGB(219, 83, 64) forState:(UIControlStateNormal)];
        [_comboButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _isCombo = NO;
        self.bottomLineLeading.constant = 0;
    }
}

- (IBAction)comboAction:(id)sender {
    if (!_isCombo) {
        [_comboButton setTitleColor:RGB(219, 83, 64) forState:(UIControlStateNormal)];
        [_foodButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _isCombo = YES;
        self.bottomLineLeading.constant = KScreenWidth / 2;
    }
}

- (IBAction)activityAction:(id)sender {
    if (self.activityViewHeight.constant == 46) {
        self.activityViewHeight.constant = 23 * _shopModel.activites.count;
        self.arrowImageView.image = [UIImage imageNamed:@"home_up"];
    } else {
        self.activityViewHeight.constant = 46;
        self.arrowImageView.image = [UIImage imageNamed:@"home_down"];
        
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        JSYHCateModel *cateModel = self.catesArray[indexPath.row];
        if (cateModel.catename.length > 5) {
            return 67;
        }
        return 53;
    } else {
        return 96;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _rightTableView) {
        return self.catesArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.catesArray.count;
    } else {
        JSYHCateModel *model = self.catesArray[section];
        return model.dishs.count;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (tableView == _rightTableView) {
//        JSYHCateModel *model = self.catesArray[section];
//        return model.catename;
//    }
//    return nil;
//
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc] init];
        JSYHCateModel *model = self.catesArray[section];
        title.text = model.catename;
        title.font = [UIFont systemFontOfSize:11];
        title.frame = CGRectMake(0, 0, 200, 20);
        [view addSubview:title];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        JSYHHomeStoreLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeStoreLeftTableViewCell" forIndexPath:indexPath];
        JSYHCateModel *model = self.catesArray[indexPath.row];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.textColor = model.selected ? [UIColor redColor] : [UIColor lightGrayColor];
        cell.nameLabel.text = model.catename;
        return cell;
    } else {
        HomeStoreRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeStoreRightTableViewCell" forIndexPath:indexPath];
        JSYHCateModel *cateModel = self.catesArray[indexPath.section];
        JSYHDishModel *model = cateModel.dishs[indexPath.row];
        cell.dishModel = model;
        cell.shopname = _shopModel.name;
        cell.shoplogo = _shopModel.logo;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _rightTableView) {
        if (_isCombo) {
            HomeActivityViewController *comboVC = [[HomeActivityViewController alloc]init];
            [self.navigationController pushViewController:comboVC animated:YES];
        } else {
            HomeFoodDetailViewController *foodDetailVC = [[HomeFoodDetailViewController alloc] init];
            JSYHCateModel *cateModel = self.catesArray[indexPath.section];
            JSYHDishModel *dishModel = cateModel.dishs[indexPath.row];
            foodDetailVC.dishModel = dishModel;
            [self.navigationController pushViewController:foodDetailVC animated:YES];
        }
    } else {
        JSYHCateModel *model = self.catesArray[indexPath.row];
        for (JSYHCateModel *catemodle in self.catesArray) {
            catemodle.selected = NO;
        }
        model.selected = YES;
        [_leftTableView reloadData];
        
        if (model.dishs.count > 0) {
            _isScroll = NO;
            [_rightTableView scrollToRow:0 inSection:indexPath.row atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
        }
        
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _rightTableView) {
        if (_isScroll == NO) {
            return;
        }
        NSIndexPath *index = [_rightTableView indexPathsForVisibleRows].firstObject;
        for (JSYHCateModel *cateModel in self.catesArray) {
            cateModel.selected = NO;
        }
        JSYHCateModel *cate = self.catesArray[index.section];
        cate.selected = YES;
        [_leftTableView reloadData];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == _rightTableView) {
        _isScroll = YES;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)catesArray {
    if (_catesArray == nil) {
        _catesArray = [NSMutableArray array];
    }
    return _catesArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
