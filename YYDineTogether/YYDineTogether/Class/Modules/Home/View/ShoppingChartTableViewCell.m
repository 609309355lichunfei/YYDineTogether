//
//  ShoppingChartTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "ShoppingChartTableViewCell.h"
#import "ShoppingCartSmallTableViewCell.h"
#import "JSYHShopModel.h"
#import "JSYHDishModel.h"

@interface ShoppingChartTableViewCell ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation ShoppingChartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registUI];
}

- (void)registUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingCartSmallTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShoppingCartCellTableViewCell"];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartSmallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCartCellTableViewCell" forIndexPath:indexPath];
    JSYHDishModel *dishModel = self.dataArray[indexPath.row];
    cell.dishModel = dishModel;
    cell.isShoppingCart = _isShoppingCart;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)setShopModel:(JSYHShopModel *)shopModel {
    _shopModel = shopModel;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_shopModel.logo] placeholder:nil];
    self.shopNameLabel.text = _shopModel.name;
    self.dataArray = _shopModel.dishs;
    [self.tableView reloadData];
}

#pragma mark - 懒加载
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
