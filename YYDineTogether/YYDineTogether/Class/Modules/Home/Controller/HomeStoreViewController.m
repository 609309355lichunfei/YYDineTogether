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

@interface HomeStoreViewController ()<UITableViewDelegate, UITableViewDataSource>{
    BOOL _isCombo;
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
@property (strong, nonatomic) NSMutableArray *dishsArray;


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
    [self.leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeStoreLeftTableViewCell"];
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
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionTop)];
        [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        JSYHCateModel *cateModel = [_shopModel.cates firstObject];
        self.dishsArray = cateModel.dishs;
        [self.rightTableView reloadData];
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
        return 30;
    } else {
        return 65;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.catesArray.count;
    } else {
        return self.dishsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeStoreLeftTableViewCell" forIndexPath:indexPath];
        JSYHCateModel *model = self.catesArray[indexPath.row];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.text = model.catename;
        cell.textLabel.font = [UIFont systemFontOfSize:11];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.numberOfLines = 0;
        return cell;
    } else {
        HomeStoreRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeStoreRightTableViewCell" forIndexPath:indexPath];
        JSYHDishModel *model = self.dishsArray[indexPath.row];
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
            JSYHDishModel *dishModel = self.dishsArray[indexPath.row];
            foodDetailVC.dishModel = dishModel;
            [self.navigationController pushViewController:foodDetailVC animated:YES];
        }
    } else {
        JSYHCateModel *model = self.catesArray[indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor redColor];
        self.dishsArray = model.dishs;
        [self.rightTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)dishsArray {
    if (_dishsArray == nil) {
        _dishsArray = [NSMutableArray array];
    }
    return _dishsArray;
}

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
