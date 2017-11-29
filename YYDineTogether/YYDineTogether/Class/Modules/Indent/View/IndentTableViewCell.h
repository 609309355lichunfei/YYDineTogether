//
//  IndentTableViewCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSYHOrderModel;
@interface IndentTableViewCell : UITableViewCell
@property (strong, nonatomic) JSYHOrderModel *orderModel;

@property (copy, nonatomic) void (^firstBlock)(JSYHOrderModel *model);
@property (copy, nonatomic) void (^secondBlock)(JSYHOrderModel *model);
@property (copy, nonatomic) void(^seletedBlock)();
@end
