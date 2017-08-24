//
//  ShoppingCartSmallTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "ShoppingCartSmallTableViewCell.h"
#import "JSYHDishModel.h"

@interface ShoppingCartSmallTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *changeCountView;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *subtractButton;

@end

@implementation ShoppingCartSmallTableViewCell

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
    _dishModel.count = [_numberLabel.text integerValue];
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
    [[ShoppingCartManager sharedManager] removeFromeShoppingCartWithDish:_dishModel];
}

- (void)setIsShoppingCart:(BOOL)isShoppingCart {
    _isShoppingCart = isShoppingCart;
    self.changeCountView.hidden = !_isShoppingCart;
}

- (void)setDishModel:(JSYHDishModel *)dishModel {
    _dishModel = dishModel;
    self.dishNameLabel.text = _dishModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", _dishModel.price];
    if (_dishModel.count > 0) {
        _numberLabel.hidden = NO;
        _subtractButton.hidden = NO;
        _numberLabel.text = [NSString stringWithFormat:@"%ld",_dishModel.count];
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
