//
//  JSYHCouponTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/4.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHCouponTableViewCell.h"
#import "JSYHCouponModel.h"

@interface JSYHCouponTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *dueImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabe;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation JSYHCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCouponModel:(JSYHCouponModel *)couponModel {
    _couponModel = couponModel;
    self.priceLabe.text = [NSString stringWithFormat:@"¥ %ld",_couponModel.value];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[AppManager couponTimestampSwitchTime:_couponModel.starttime], [AppManager couponTimestampSwitchTime:_couponModel.endtime]];
    self.dueImageView.hidden = !_couponModel.overdue;
    if (_couponModel.overdue == 0) {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"indent_coupon1"]];
        self.priceLabe.textColor = UIColorFromRGB(0xffffff);
    } else {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"indent_coupon2"]];
        self.priceLabe.textColor = UIColorFromRGB(0xcccccc);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
