//
//  IndentChooseAddressTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentChooseAddressTableViewCell.h"
#import "JSYHAddressModel.h"

@interface IndentChooseAddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation IndentChooseAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)editAction:(id)sender {
    self.editBlock();
}

- (void)setAddressModel:(JSYHAddressModel *)addressModel {
    _addressModel = addressModel;
    self.nameLabel.text = _addressModel.username;
    self.phoneLabel.text = _addressModel.phone;
    self.addressLabel.text = _addressModel.address;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
