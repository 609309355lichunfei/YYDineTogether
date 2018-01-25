//
//  JSYHShoppingCartCombTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/29.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHShoppingCartCombTableViewCell.h"
#import "JSYHComboModel.h"

@interface JSYHShoppingCartCombTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *combNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *subtractButton;

@end

@implementation JSYHShoppingCartCombTableViewCell

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
    _combModel.count = [_numberLabel.text integerValue];
    [[ShoppingCartManager sharedManager] addToShoppingCartWitComb:_combModel];
}


- (IBAction)subtractAction:(id)sender {
    if ([_numberLabel.text isEqualToString:@"1"]) {
        _numberLabel.text = @"0";
        _subtractButton.hidden = YES;
        _numberLabel.hidden = YES;
    } else {
        _numberLabel.text =  [NSString stringWithFormat:@"%ld",[_numberLabel.text integerValue] - 1];
    }
    [[ShoppingCartManager sharedManager] removeFromeShoppingCartWithComb:_combModel];
}

- (void)setCombModel:(JSYHComboModel *)combModel {
    _combModel = combModel;
    self.combNameLabel.text = _combModel.name;
    NSNumber *price = [NSNumber numberWithFloat:(_combModel.price.doubleValue * 1)];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",price];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",_combModel.count];
    if (_combModel.count > 0) {
        _numberLabel.hidden = NO;
        _subtractButton.hidden = NO;
        _numberLabel.text = [NSString stringWithFormat:@"%ld",_combModel.count];
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
