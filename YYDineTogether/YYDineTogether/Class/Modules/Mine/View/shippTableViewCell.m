//
//  shippTableViewCell.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "shippTableViewCell.h"


@implementation shippTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//编辑
- (IBAction)Compile:(id)sender {
    _editBlock();
}

- (IBAction)removeAction:(id)sender {
    _removeBlock();
}


@end
