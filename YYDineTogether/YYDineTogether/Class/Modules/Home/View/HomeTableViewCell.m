//
//  HomeTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "JSYHShopModel.h"
#import "JSYHActivityModel.h"
#import "JSYHHomeStoreActivityView.h"

@interface HomeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *shopStarLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopSalesCountLabel;



@property (weak, nonatomic) IBOutlet UIView *storeView;

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShopModel:(JSYHShopModel *)shopModel {
    _shopModel = shopModel;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_shopModel.logo] placeholder:nil];
    self.nameLabel.text = _shopModel.name;
    self.shopStarLabel.text = [NSString stringWithFormat:@"%ld单",(long)_shopModel.star];
    self.shopSalesCountLabel.text = [NSString stringWithFormat:@"%ld单",(long)_shopModel.salescount];
    self.distanceLabel.text = _shopModel.distance;
    [self.storeView removeAllSubviews];
    for (NSInteger i = 0; i < _shopModel.activites.count; i ++){
        JSYHActivityModel *model = _shopModel.activites[i];
        JSYHHomeStoreActivityView *view = [[[NSBundle mainBundle] loadNibNamed:@"JSYHHomeStoreActivityView" owner:self options:nil] lastObject];
        view.frame = CGRectMake(8, 4 + i * 20, 100, 20);
        [self.storeView addSubview:view];
        [view setActivityModel:model];
    }
    
}

@end
