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

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *optionImageView;


@property (weak, nonatomic) IBOutlet UIView *storeView;
@property (weak, nonatomic) IBOutlet UIButton *activityBT;

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShopModel:(JSYHShopModel *)shopModel {
    _shopModel = shopModel;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_shopModel.logo] placeholder:[UIImage imageNamed:@"default_shop"]];
    self.nameLabel.text = _shopModel.name;
    if (_shopModel.star == 0) {
        self.shopStarLabel.text = @"";
    } else {
        self.shopStarLabel.text = [NSString stringWithFormat:@"%ld",(long)_shopModel.star];
    }
    if (_shopModel.salescount == 0) {
        self.shopSalesCountLabel.text = @"";
    } else {
        self.shopSalesCountLabel.text = [NSString stringWithFormat:@"%ld单",(long)_shopModel.salescount];
    }
    self.distanceLabel.text = _shopModel.distance;
    [self.storeView removeAllSubviews];
    [self.activityBT setTitle:[NSString stringWithFormat:@"%ld个活动",_shopModel.activites.count] forState:(UIControlStateNormal)];
    
    _optionImageView.highlighted = _shopModel.optinal;
    if (_shopModel.activites.count > 2 && _shopModel.optinal) {
        for (NSInteger i = 0; i < _shopModel.activites.count; i ++){
            JSYHActivityModel *model = _shopModel.activites[i];
            JSYHHomeStoreActivityView *view = [[[NSBundle mainBundle] loadNibNamed:@"JSYHHomeStoreActivityView" owner:self options:nil] lastObject];
            view.frame = CGRectMake(8, 4 + i * 20, 100, 20);
            [self.storeView addSubview:view];
            [view setActivityModel:model];
        }
    } else if (_shopModel.activites.count < 3){
        for (NSInteger i = 0; i < _shopModel.activites.count; i ++){
            JSYHActivityModel *model = _shopModel.activites[i];
            JSYHHomeStoreActivityView *view = [[[NSBundle mainBundle] loadNibNamed:@"JSYHHomeStoreActivityView" owner:self options:nil] lastObject];
            view.frame = CGRectMake(8, 4 + i * 20, 100, 20);
            [self.storeView addSubview:view];
            [view setActivityModel:model];
        }
    } else {
        for (NSInteger i = 0; i < 2; i ++){
            JSYHActivityModel *model = _shopModel.activites[i];
            JSYHHomeStoreActivityView *view = [[[NSBundle mainBundle] loadNibNamed:@"JSYHHomeStoreActivityView" owner:self options:nil] lastObject];
            view.frame = CGRectMake(8, 4 + i * 20, 100, 20);
            [self.storeView addSubview:view];
            [view setActivityModel:model];
        }
    }
    
}
- (IBAction)activityAction:(id)sender {
    _shopModel.optinal = !_shopModel.optinal;
    _optionImageView.highlighted = _shopModel.optinal;
    [_shopModel updateHeightWithActivity];
    self.activityBlock();
}

@end
