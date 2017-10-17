//
//  HomeDishTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/22.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeDishTableViewCell.h"
#import "JSYHDishModel.h"

@interface HomeDishTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *dishDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *discountDiscoverView;


@property (weak, nonatomic) IBOutlet UIButton *subtractButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@end

@implementation HomeDishTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)addAction:(id)sender {
    if (_subtractButton.isHidden) {
        _numberLabel.hidden = NO;
        _numberLabel.text = @"1";
        _subtractButton.hidden = NO;
    } else {
        _numberLabel.text =  [NSString stringWithFormat:@"%ld",[_numberLabel.text integerValue] + 1];
    }
    _dishModel.shopcartCount = [_numberLabel.text integerValue];
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
    _dishModel.shopcartCount = [_numberLabel.text integerValue];
    [[ShoppingCartManager sharedManager] removeFromeShoppingCartWithDish:_dishModel];
}

- (void)setDishModel:(JSYHDishModel *)dishModel {
    _dishModel = dishModel;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_dishModel.logo] placeholder:[UIImage imageNamed:@"default_dish"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@-%@",_dishModel.name,_dishModel.shopname];
    self.dishDistanceLabel.text = _dishModel.distance;
    self.discountPriceLabel.hidden = [_dishModel.discountprice isEqualToNumber:_dishModel.price] ? YES : NO;
    self.discountDiscoverView.hidden = self.discountPriceLabel.isHidden;
    self.discountPriceLabel.text = [NSString stringWithFormat:@"%@",_dishModel.discountprice];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",_dishModel.price];
    if (_dishModel.shopcartCount > 0) {
        _numberLabel.hidden = NO;
        _subtractButton.hidden = NO;
        _numberLabel.text = [NSString stringWithFormat:@"%ld",_dishModel.shopcartCount];
    } else {
        _numberLabel.hidden = YES;
        _subtractButton.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
