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
    self.priceLabe.text = [NSString stringWithFormat:@"%@",_couponModel.value];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[AppManager couponTimestampSwitchTime:_couponModel.starttime], [AppManager couponTimestampSwitchTime:_couponModel.endtime]];
    if (_couponModel.is_first == 1) {
        self.valueLabel.text = @"首单跨店红包";
//        self.valueLabel.text = @"首单跨店优惠,店铺数>1";
    } else {
        if ([_couponModel.full isEqualToNumber:@0]) {
            self.valueLabel.text = @"通用红包";
//            self.valueLabel.text = @"无门槛";
        } else {
            self.valueLabel.text = [NSString stringWithFormat:@"满%@元使用",_couponModel.full];
//            self.valueLabel.text = @"满减";
        }
        
    }
    self.dueImageView.hidden = !_couponModel.overdue;
    if (_couponModel.overdue != 0) {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"indent_coupon_new3"]];//已过期
    } else if (!_couponModel.canUse) {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"indent_coupon_new2"]];
    } else {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"indent_coupon_new1"]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
