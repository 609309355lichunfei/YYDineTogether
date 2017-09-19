//
//  IndentTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentTableViewCell.h"
#import "IndentCellTableViewCell.h"
#import "JSYHOrderModel.h"
#import "JSYHShopModel.h"
#import "JSYHPreOrderTableViewCell.h"
#import "JSYHPayWayViewController.h"

@interface IndentTableViewCell ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *secondBT;
@property (weak, nonatomic) IBOutlet UIButton *firstBT;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation IndentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registUI];
}

- (void)registUI {
    self.secondBT.layer.cornerRadius = 2;
    self.firstBT.layer.cornerRadius = 2;
    self.firstBT.layer.borderWidth = 0.5;
    self.firstBT.layer.borderColor = [UIColorFromRGB(0xfd5353) CGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHPreOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentCellTableViewCell"];
}

- (void)setOrderModel:(JSYHOrderModel *)orderModel {
    _orderModel = orderModel;
    self.timeLabel.text = [AppManager timestampSwitchTime:_orderModel.ordertime];
    if (_orderModel.paystatus == 0) {
        self.statusLabel.text = @"待支付";
        self.firstBT.hidden = NO;
        self.secondBT.hidden = NO;
    } else {
        self.firstBT.hidden = YES;
        self.secondBT.hidden = YES;
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%@",_orderModel.lastprice];
    self.dataArray = _orderModel.shops;
    [self.tableView reloadData];
}

- (IBAction)firstBTAction:(id)sender {
//    self.firstBlock(self.orderModel);
}


- (IBAction)secondBTAction:(id)sender {
//    self.secondBlock(self.orderModel);
    JSYHPayWayViewController *paywayVC = [[JSYHPayWayViewController alloc] init];
    paywayVC.order_no = self.orderModel.order_no;
    paywayVC.price = [NSString stringWithFormat:@"%@",self.orderModel.lastprice];
    [self.viewController.tabBarController.navigationController pushViewController:paywayVC animated:YES];
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHShopModel *model = self.dataArray[indexPath.row];
    return model.orderHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHPreOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndentCellTableViewCell" forIndexPath:indexPath];
    JSYHShopModel *model = self.dataArray[indexPath.row];
    cell.shopModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
