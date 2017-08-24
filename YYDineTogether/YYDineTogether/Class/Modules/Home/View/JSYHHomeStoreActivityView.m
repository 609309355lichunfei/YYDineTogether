//
//  JSYHHomeStoreActivityView.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/11.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHHomeStoreActivityView.h"
#import "JSYHActivityModel.h"

@implementation JSYHHomeStoreActivityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setActivityModel:(JSYHActivityModel *)activityModel {
    _activityModel = activityModel;
    self.titleLabel.text = _activityModel.content;
    if (_activityModel.type == 1) {
        self.activityImageView.image = [UIImage imageNamed:@"home_xin"];
    } else if (_activityModel.type == 2) {
        self.activityImageView.image = [UIImage imageNamed:@"home_te"];
    }else if (_activityModel.type == 3) {
        self.activityImageView.image = [UIImage imageNamed:@"home_te"];
    }
}

@end
