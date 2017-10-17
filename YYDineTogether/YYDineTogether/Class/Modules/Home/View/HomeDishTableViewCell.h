//
//  HomeDishTableViewCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/22.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSYHDishModel;

@interface HomeDishTableViewCell : UITableViewCell

@property (strong, nonatomic) JSYHDishModel *dishModel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
