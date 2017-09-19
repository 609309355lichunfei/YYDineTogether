//
//  HomSearchTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomSearchTableViewCell.h"
#import "JSYHShopModel.h"
#import "JSYHActivityModel.h"
#import "JSYHHomeStoreActivityView.h"
#import "HomeSearchDishTableViewCell.h"
#import "HomeFoodDetailViewController.h"

@interface HomSearchTableViewCell ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *shopStarLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopSalesCountLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityViewHeight;
@property (weak, nonatomic) IBOutlet UIView *storeView;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation HomSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registUI];
}

- (void)registUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeSearchDishTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeSearchDishTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setShopModel:(JSYHShopModel *)shopModel {
    _shopModel = shopModel;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_shopModel.logo] placeholder:nil];
    self.nameLabel.text = _shopModel.name;
    self.shopStarLabel.text = [NSString stringWithFormat:@"%ld单",(long)_shopModel.star];
    self.shopSalesCountLabel.text = [NSString stringWithFormat:@"%ld单",(long)_shopModel.salescount];
    self.distanceLabel.text = _shopModel.distance;
    [self.storeView removeAllSubviews];
    self.activityViewHeight.constant = _shopModel.activites.count * 22;
    for (NSInteger i = 0; i < _shopModel.activites.count; i ++){
        JSYHActivityModel *model = _shopModel.activites[i];
        JSYHHomeStoreActivityView *view = [[[NSBundle mainBundle] loadNibNamed:@"JSYHHomeStoreActivityView" owner:self options:nil] lastObject];
        view.frame = CGRectMake(8, 4 + i * 20, 100, 20);
        [self.storeView addSubview:view];
        [view setActivityModel:model];
    }
    self.dataArray = _shopModel.dishs;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeSearchDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeSearchDishTableViewCell" forIndexPath:indexPath];
    JSYHDishModel *model = self.dataArray[indexPath.row];
    cell.dishModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeFoodDetailViewController *controller = [[HomeFoodDetailViewController alloc]init];
    JSYHDishModel *model = self.dataArray[indexPath.row];
    controller.dishModel = model;
    [self.viewController.navigationController pushViewController:controller animated:YES];
}
#pragma mark - 懒加载
-(NSMutableArray *)dataArray {
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
