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

@interface ShoppingChartViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *shoppingCartCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation ShoppingChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    self.shoppingCartCountLabel.layer.cornerRadius = 9;
    if ([ShoppingCartManager sharedManager].shoppingCartDataArray.count == 0) {
        self.shoppingCartCountLabel.hidden = YES;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
    } else {
        self.shoppingCartCountLabel.hidden = NO;
        self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].shoppingCartDataArray.count];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
    }
    [[NSNotificationCenter defaultCenter] addObserverForName:@"JSYHShoppingCartCountChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if ([ShoppingCartManager sharedManager].shoppingCartDataArray.count == 0) {
            self.shoppingCartCountLabel.hidden = YES;
            self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
        } else {
            self.shoppingCartCountLabel.hidden = NO;
            self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].shoppingCartDataArray.count];
            self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
        }
        
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingChartTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShoppingChartTableViewCell"];
    [[ShoppingCartManager sharedManager] clearUpDataArrayWithShop];
    for (JSYHShopModel *model in [ShoppingCartManager sharedManager].shoppingCartDataShopArray) {
        [model updateHeightWithDish];
    }
    self.dataArray = [ShoppingCartManager sharedManager].shoppingCartDataShopArray;
    [self.tableView reloadData];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)payAction:(id)sender {
    IndentConfirmViewController *confirmVC = [[IndentConfirmViewController alloc]init];
    [self.navigationController pushViewController:confirmVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHShopModel *model = self.dataArray[indexPath.row];
    return model.shopCartHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingChartTableViewCell" forIndexPath:indexPath];
    cell.isShoppingCart = YES;
    JSYHShopModel *shopmodel = self.dataArray[indexPath.row];
    cell.shopModel = shopmodel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma makr - 懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
