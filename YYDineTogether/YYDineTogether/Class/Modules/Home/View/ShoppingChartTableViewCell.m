//
//  ShoppingChartTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "ShoppingChartTableViewCell.h"
#import "ShoppingCartSmallTableViewCell.h"

@interface ShoppingChartTableViewCell ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartSmallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCartCellTableViewCell" forIndexPath:indexPath];
    cell.isShoppingCart = _isShoppingCart;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
