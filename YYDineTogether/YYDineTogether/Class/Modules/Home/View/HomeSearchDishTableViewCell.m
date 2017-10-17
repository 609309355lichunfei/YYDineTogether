//
//  HomeSearchDishTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/3.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeSearchDishTableViewCell.h"
#import "JSYHDishModel.h"

@interface HomeSearchDishTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *dishStarLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishSalesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *priceCoverView;
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;


@property (weak, nonatomic) IBOutlet UIButton *subtractButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;




@end

@implementation HomeSearchDishTableViewCell

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
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_dishModel.logo] placeholder:nil];
    self.nameLabel.text = _dishModel.name;
    self.dishSalesCountLabel.text = [NSString stringWithFormat:@"%ld",_dishModel.salescount];
    self.priceLabel.hidden = [_dishModel.price isEqualToNumber:_dishModel.discountprice] ? YES : NO;
    self.priceCoverView.hidden = self.priceLabel.isHidden;
    self.dishStarLabel.text = [NSString stringWithFormat:@"%ld",_dishModel.star];
    self.discountPriceLabel.text = [NSString stringWithFormat:@"¥ %@",_dishModel.discountprice];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",_dishModel.price];
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
