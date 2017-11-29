//
//  HomeTableViewFunctionCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/26.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeTableViewFunctionCell.h"

@interface HomeTableViewFunctionCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineTolead;

@property (strong, nonatomic) UIButton *currentBT;


@end

@implementation HomeTableViewFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registUI];
}

- (void)registUI {
}

- (IBAction)cateAction:(id)sender {
    _cateBlock();
}
- (IBAction)drinkAction:(id)sender {
    _drinkBlock();
}
- (IBAction)comboAction:(id)sender {
    [MobClick event:@"home_meal_button"];
    _comboBlock();
}
- (IBAction)fruitAction:(id)sender {
    _fruitBlock();
}
- (IBAction)superMarketAction:(id)sender {
    _supermarketBlock();
}
- (IBAction)merchantAction:(id)sender {
    _underlineTolead.constant = 0;
    _merchantBlock();
    
}
- (IBAction)dishesAction:(id)sender {
    _underlineTolead.constant = KScreenWidth / 2;
    _dishesBlock();
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
