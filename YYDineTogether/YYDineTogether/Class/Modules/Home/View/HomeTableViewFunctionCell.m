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

@property (weak, nonatomic) IBOutlet UIButton *tuijianBT;
@property (weak, nonatomic) IBOutlet UIButton *zuijinBT;
@property (weak, nonatomic) IBOutlet UIButton *starsBT;
@property (strong, nonatomic) UIButton *currentBT;

@end

@implementation HomeTableViewFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registUI];
}

- (void)registUI {
    self.currentBT = self.tuijianBT;
}

- (IBAction)cateAction:(id)sender {
    _cateBlock();
}
- (IBAction)drinkAction:(id)sender {
    _drinkBlock();
}
- (IBAction)comboAction:(id)sender {
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
- (IBAction)tuijianAction:(id)sender {
    if (self.currentBT == self.tuijianBT) {
        return;
    }
    [self.currentBT setTitleColor:RGB(100, 100, 100) forState:(UIControlStateNormal)];
    self.currentBT = self.tuijianBT;
    [self.currentBT setTitleColor:RGB(253, 89, 95) forState:(UIControlStateNormal)];
}

- (IBAction)zuijinAction:(id)sender {
    if (self.currentBT == self.zuijinBT) {
        return;
    }
    [self.currentBT setTitleColor:RGB(100, 100, 100) forState:(UIControlStateNormal)];
    self.currentBT = self.zuijinBT;
    [self.currentBT setTitleColor:RGB(253, 89, 95) forState:(UIControlStateNormal)];
}

- (IBAction)starAction:(id)sender {
    if (self.currentBT == self.starsBT) {
        return;
    }
    [self.currentBT setTitleColor:RGB(100, 100, 100) forState:(UIControlStateNormal)];
    self.currentBT = self.starsBT;
    [self.currentBT setTitleColor:RGB(253, 89, 95) forState:(UIControlStateNormal)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
