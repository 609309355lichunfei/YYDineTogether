//
//  JSYHPreOrderTableViewCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/29.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSYHShopModel;
@interface JSYHPreOrderTableViewCell : UITableViewCell
@property (strong, nonatomic) JSYHShopModel *shopModel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@end
