//
//  HomeTableViewFunctionCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/26.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewFunctionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UIButton *merchantBt;

@property (weak, nonatomic) IBOutlet UIButton *dishesBt;

@property (copy, nonatomic) void(^cateBlock)();
@property (copy, nonatomic) void(^drinkBlock)();
@property (copy, nonatomic) void(^fruitBlock)();
@property (copy, nonatomic) void(^supermarketBlock)();
@property (copy, nonatomic) void(^merchantBlock)();
@property (copy, nonatomic) void(^dishesBlock)();

@end
