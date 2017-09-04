//
//  JSYHPreOrderDishTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/30.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHPreOrderDishTableViewCell.h"
#import "JSYHDishModel.h"

@interface JSYHPreOrderDishTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation JSYHPreOrderDishTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDishModel:(JSYHDishModel *)dishModel {
    _dishModel = dishModel;
    self.nameLabel.text = _dishModel.name;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",_dishModel.count];
    self.priceLabel.text = [_dishModel.price stringValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
