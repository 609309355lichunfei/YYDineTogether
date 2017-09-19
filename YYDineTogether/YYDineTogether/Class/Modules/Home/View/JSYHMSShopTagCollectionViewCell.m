//
//  JSYHMSShopTagCollectionViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/8.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHMSShopTagCollectionViewCell.h"
#import "JSYHTagModel.h"
@interface JSYHMSShopTagCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewWidth;

@end

@implementation JSYHMSShopTagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTagModel:(JSYHTagModel *)tagModel {
    _tagModel = tagModel;
    self.tagNameLabel.text = _tagModel.name;
    self.bottomViewWidth.constant = [_tagModel.name widthForFont:[UIFont fontWithName:App_FamilyFontName size:16]];
}

@end
