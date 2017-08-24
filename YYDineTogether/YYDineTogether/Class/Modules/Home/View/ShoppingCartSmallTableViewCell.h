//
//  ShoppingCartSmallTableViewCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSYHDishModel;
@interface ShoppingCartSmallTableViewCell : UITableViewCell
@property (assign, nonatomic) BOOL isShoppingCart;
@property (strong, nonatomic) JSYHDishModel *dishModel;
@end
