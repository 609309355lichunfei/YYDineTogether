//
//  ShoppingCartSmallTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "ShoppingCartSmallTableViewCell.h"

@interface ShoppingCartSmallTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *changeCountView;

@end

@implementation ShoppingCartSmallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsShoppingCart:(BOOL)isShoppingCart {
    _isShoppingCart = isShoppingCart;
    self.changeCountView.hidden = !_isShoppingCart;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
