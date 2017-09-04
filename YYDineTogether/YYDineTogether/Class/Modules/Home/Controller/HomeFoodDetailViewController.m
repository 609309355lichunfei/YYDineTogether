//
//  HomeFoodDetailViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeFoodDetailViewController.h"
#import "JSYHDishModel.h"

@interface HomeFoodDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *subtractButton;
@property (strong, nonatomic) HomeShoppingCartView *shoppingView;

@property (weak, nonatomic) IBOutlet UILabel *shoppingCartCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *salescountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation HomeFoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_dishModel.logo] placeholder:nil];
    self.nameLabel.text = _dishModel.name;
//    self.shopNameLabel.text = [NSString stringWithFormat:@"(%@)",_dishModel.shopname];
//    self.dishDistanceLabel.text = _dishModel.distance;
    self.salescountLabel.text = [NSString stringWithFormat:@"%d",_dishModel.salescount];
    self.starLabel.text = [NSString stringWithFormat:@"%ld",_dishModel.star];
//    self.priceLabel.text = [NSString stringWithFormat:@"%@",_dishModel.discountprice];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",_dishModel.price];
    self.infoLabel.text = _dishModel.info;
    if (_dishModel.count > 0) {
        _numberLabel.hidden = NO;
        _subtractButton.hidden = NO;
        _numberLabel.text = [NSString stringWithFormat:@"%ld",_dishModel.count];
    } else {
        _numberLabel.hidden = YES;
        _subtractButton.hidden = YES;
    }
}

- (void)getConnectDishDetail {
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shoppingCartAction:(id)sender {
//    if (_shoppingView == nil) {
//        self.shoppingView = [[[NSBundle mainBundle] loadNibNamed:@"HomeShoppingCartView" owner:self options:nil] lastObject];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//            [_shoppingView removeShoppingCartView];
//            _shoppingView = nil;
//        }];
//        [_shoppingView addGestureRecognizer:tap];
//        [_shoppingView showShoppingCartView];
//    } else {
//        [_shoppingView removeShoppingCartView];
//        _shoppingView = nil;
//    }
}
- (IBAction)clearShoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

- (IBAction)addAction:(id)sender {
    if (_subtractButton.isHidden) {
        _numberLabel.hidden = NO;
        _numberLabel.text = @"1";
        _subtractButton.hidden = NO;
    } else {
        _numberLabel.text =  [NSString stringWithFormat:@"%ld",[_numberLabel.text integerValue] + 1];
    }
    _dishModel.count = [_numberLabel.text integerValue];
    [[ShoppingCartManager sharedManager] addToShoppingCartWithDish:_dishModel];
}
- (IBAction)subtractAction:(id)sender {
    if ([_numberLabel.text isEqualToString:@"1"]) {
        _numberLabel.text = @"0";
        _subtractButton.hidden = YES;
        _numberLabel.hidden = YES;
    } else {
        _numberLabel.text =  [NSString stringWithFormat:@"%ld",[_numberLabel.text integerValue] - 1];
    }
    _dishModel.count = [_numberLabel.text integerValue];
    [[ShoppingCartManager sharedManager] removeFromeShoppingCartWithDish:_dishModel];
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
