//
//  JSYHCombListTableViewCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/14.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSYHComboModel;
@interface JSYHCombListTableViewCell : UITableViewCell
@property (strong, nonatomic) JSYHComboModel *combModel;
@property (weak, nonatomic) IBOutlet UIButton *addBT;

@property (copy, nonatomic) void (^addBlock)();
@end
