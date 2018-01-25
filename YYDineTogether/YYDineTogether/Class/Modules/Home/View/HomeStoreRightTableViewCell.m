//
//  HomeStoreRightTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/11.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeStoreRightTableViewCell.h"
#import "HomeStandardChooseView.h"
#import "JSYHDishModel.h"

@interface HomeStoreRightTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *subtractButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *discountDiscoverView;

@end

@implementation HomeStoreRightTableViewCell

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
//    HomeStandardChooseView *view = [[[NSBundle mainBundle] loadNibNamed:@"HomeStandardChooseView" owner:self options:nil] firstObject];
//    [view showView];
    _dishModel.shopcartCount = [_numberLabel.text integerValue];
    _dishModel.shopname = _shopname;
    _dishModel.shoplogo = _shoplogo;
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
    self.nameLabel.text = _dishModel.name;
    self.salesCountLabel.text = [NSString stringWithFormat:@"%d",_dishModel.salescount];
    self.starLabel.text = [NSString stringWithFormat:@"%ld",_dishModel.star];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",_dishModel.discountprice];
    self.discountPriceLabel.hidden = [_dishModel.discountprice isEqualToNumber:_dishModel.price] ? YES : NO;
    self.discountDiscoverView.hidden = self.discountPriceLabel.isHidden;
    self.discountPriceLabel.text = [NSString stringWithFormat:@"%@",_dishModel.price];
    self.infoLabel.text = _dishModel.info;
    if (_dishModel.shopcartCount > 0) {
        _numberLabel.hidden = NO;
        _subtractButton.hidden = NO;
        _numberLabel.text = [NSString stringWithFormat:@"%ld",_dishModel.shopcartCount];
    } else {
        _numberLabel.hidden = YES;
        _subtractButton.hidden = YES;
    }
}

- (void)twinkBGView {
    [UIView animateWithDuration:0.7 animations:^{
        self.contentView.backgroundColor = [UIColor colorWithRGB:0x0795e7 alpha:0.1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 animations:^{
            self.contentView.backgroundColor = [UIColor whiteColor];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
