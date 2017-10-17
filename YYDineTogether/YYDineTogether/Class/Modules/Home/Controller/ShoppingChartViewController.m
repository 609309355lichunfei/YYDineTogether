//
//  ShoppingChartViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "ShoppingChartViewController.h"
#import "ShoppingChartTableViewCell.h"
#import "IndentConfirmViewController.h"
#import "JSYHShopModel.h"
#import "JSYHComboModel.h"
#import "JSYHShoppingCartCombTableViewCell.h"
#import <MAMapKit/MAMapKit.h>
#import "CBAutoScrollLabel.h"

@interface ShoppingChartViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *shoppingCartCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *scrollLabel;

@property (strong, nonatomic) NSMutableArray *shopsArray;
@property (strong, nonatomic) NSMutableArray *combsArray;

@end

@implementation ShoppingChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ShoppingCartManager sharedManager] clearUpDataArrayWithShop];
    for (JSYHShopModel *model in [ShoppingCartManager sharedManager].shoppingCartDataShopArray) {
        [model updateHeightWithDish];
    }
    self.shopsArray = [ShoppingCartManager sharedManager].shoppingCartDataShopArray;
    self.combsArray = [ShoppingCartManager sharedManager].shoppingCartComboArray;
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"JSZPAPP_Comb"]) {
        UIView *guideView = [[UIView alloc] initWithFrame:kScreen_Bounds];
        guideView.backgroundColor = [UIColor blackColor];
        guideView.alpha = 0.5;
        [kAppWindow addSubview:guideView];
        UIImageView *guideImageView = [[UIImageView alloc] initWithFrame:kScreen_Bounds];
        [guideImageView setImage:[UIImage imageNamed:@"Home_combGuide"]];
        guideImageView.contentMode = UIViewContentModeCenter;
        [guideView addSubview:guideImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ] initWithActionBlock:^(id  _Nonnull sender) {
            [guideView removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"JSZPAPP_Comb"];
        }];
        [guideView addGestureRecognizer:tap];
    }
}

- (void)registUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([ShoppingCartManager sharedManager].carttips != nil &&[ShoppingCartManager sharedManager].carttips.count > 0) {
        self.scrollLabel.text = @"                             ";
        for (NSString *tip in [ShoppingCartManager sharedManager].carttips) {
            self.scrollLabel.text = [NSString stringWithFormat:@"%@%@",self.scrollLabel.text,tip];
        }
    }
    self.scrollLabel.font = [UIFont fontWithName:App_FamilyFontName size:11];
    self.scrollLabel.textColor = UIColorFromRGB(0xFE4337);
    self.scrollLabel.backgroundColor = UIColorFromRGB(0xFDDEAA);
    self.scrollLabel.pauseInterval = 0;
    [self.scrollLabel scrollLabelIfNeeded];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingChartTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShoppingChartTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHShoppingCartCombTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHShoppingCartCombTableViewCell"];
    [[ShoppingCartManager sharedManager] clearUpDataArrayWithShop];
    for (JSYHShopModel *model in [ShoppingCartManager sharedManager].shoppingCartDataShopArray) {
        [model updateHeightWithDish];
    }
    self.shopsArray = [ShoppingCartManager sharedManager].shoppingCartDataShopArray;
    self.combsArray = [ShoppingCartManager sharedManager].shoppingCartComboArray;
    [self.tableView reloadData];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)payAction:(id)sender {
    if ([ShoppingCartManager sharedManager].shoppingCartDataArray.count + [ShoppingCartManager sharedManager].shoppingCartComboArray.count == 0) {
        return;
    }
    
    CGFloat lng = [[JSYHLocationManager sharedManager].lng doubleValue];
    CGFloat lat = [[JSYHLocationManager sharedManager].lat doubleValue] ;
    CLLocationCoordinate2D coordinates[10];
    coordinates[0].latitude = 29.892687604627884;
    coordinates[0].longitude = 121.64122581481936;
    
    coordinates[1].latitude = 29.89461996744898;
    coordinates[1].longitude = 121.63515731692317;
    
    coordinates[2].latitude = 29.892229505902367;
    coordinates[2].longitude = 121.61540284752844;
    
    coordinates[3].latitude = 29.88975410859651;
    coordinates[3].longitude = 121.60212859511373;
    
    coordinates[4].latitude = 29.87753086069385;
    coordinates[4].longitude = 121.60263687372206;
    
    coordinates[5].latitude = 29.863624396931943;
    coordinates[5].longitude = 121.60008206963538;
    
    coordinates[6].latitude = 29.858138265080306;
    coordinates[6].longitude = 121.62779867649081;
    
    coordinates[7].latitude = 29.874822520147042;
    coordinates[7].longitude = 121.63169592618944;
    
    coordinates[8].latitude = 29.88004377212325;
    coordinates[8].longitude = 121.6467873752117;
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:9];
    
    CLLocationCoordinate2D loc1 = CLLocationCoordinate2DMake(lat, lng);
    MAMapPoint p1 = MAMapPointForCoordinate(loc1);
    [MBProgressHUD showMessage:@"预订单中"];
    if ([JSRequestManager sharedManager].token == nil || [JSRequestManager sharedManager].token.length == 0) {
        [MBProgressHUD hideHUD];
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
            
        }];
        return;
    }
//    if(MAPolygonContainsPoint(p1, polygon.points, 10)) {
        [[JSRequestManager sharedManager] getMemberAddressSuccess:^(id responseObject) {
            [MBProgressHUD hideHUD];
            NSArray *addressDicArray = responseObject[@"data"][@"addresses"];
            if (addressDicArray.count > 0) {
                IndentConfirmViewController *confirmVC = [[IndentConfirmViewController alloc]init];
                [self.navigationController pushViewController:confirmVC animated:YES];
            } else {
                [AppManager showToastWithMsg:@"请先添加配送地址"];
            }
        } Failed:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [AppManager showToastWithMsg:@"请先添加配送地址"];
        }];
        
//    } else {
//        [MBProgressHUD hideHUD];
//        [AppManager showToastWithMsg:@"抱歉,你不在配送范围内"];
//    }
//    IndentConfirmViewController *confirmVC = [[IndentConfirmViewController alloc]init];
//    [self.navigationController pushViewController:confirmVC animated:YES];
}

- (IBAction)clearShopcartAction:(id)sender {
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"是否要清空购物车?" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[ShoppingCartManager sharedManager] cleanShoppingcart];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alerVC addAction:action];
    [alerVC addAction:cancelAction];
    [self.navigationController presentViewController:alerVC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JSYHShopModel *model = self.shopsArray[indexPath.row];
        return model.shopCartHeight;
    } else {
        return 50;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.shopsArray.count;
    } else {
        return self.combsArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ShoppingChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingChartTableViewCell" forIndexPath:indexPath];
        cell.isShoppingCart = YES;
        JSYHShopModel *shopmodel = self.shopsArray[indexPath.row];
        cell.shopModel = shopmodel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        JSYHShoppingCartCombTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHShoppingCartCombTableViewCell" forIndexPath:indexPath];
        JSYHComboModel *model = self.combsArray[indexPath.row];
        cell.combModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma makr - 懒加载
- (NSMutableArray *)shopsArray {
    if (_shopsArray == nil) {
        _shopsArray = [NSMutableArray array];
    }
    return _shopsArray;
}

- (NSMutableArray *)combsArray {
    if (_combsArray == nil) {
        _combsArray = [NSMutableArray array];
    }
    return _combsArray;
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
