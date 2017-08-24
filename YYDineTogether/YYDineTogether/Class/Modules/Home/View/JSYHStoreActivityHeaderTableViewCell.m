//
//  JSYHStoreActivityHeaderTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/18.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHStoreActivityHeaderTableViewCell.h"

@interface JSYHStoreActivityHeaderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *activityView;

@end

@implementation JSYHStoreActivityHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ] initWithActionBlock:^(id  _Nonnull sender) {
        
    }];
    [self.activityView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
