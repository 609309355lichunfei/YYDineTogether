//
//  JSYHPreOrderTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/29.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHPreOrderTableViewCell.h"
#import "JSYHPreOrderDishTableViewCell.h"
#import "JSYHShopModel.h"
#import "JSYHDishModel.h"

@interface JSYHPreOrderTableViewCell ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *dishsTableView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end


@implementation JSYHPreOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registUI];
}

- (void)registUI {
    self.dishsTableView.delegate = self;
    self.dishsTableView.dataSource = self;
    [self.dishsTableView registerNib:[UINib nibWithNibName:@"JSYHPreOrderDishTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHPreOrderDishTableViewCell"];
}

- (IBAction)shopDetailTapAction:(id)sender {
    
}

- (IBAction)remarkTapAction:(id)sender {
    
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHDishModel *dishModel = self.dataArray[indexPath.row];
    JSYHPreOrderDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHPreOrderDishTableViewCell" forIndexPath:indexPath];
    cell.dishModel = dishModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setShopModel:(JSYHShopModel *)shopModel {
    _shopModel = shopModel;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_shopModel.logo] placeholder:nil];
    self.shopNameLabel.text = _shopModel.name;
    self.dataArray = _shopModel.dishs;
    [self.dishsTableView reloadData];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
