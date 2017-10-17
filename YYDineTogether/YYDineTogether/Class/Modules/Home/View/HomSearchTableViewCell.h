//
//  HomSearchTableViewCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSYHShopModel;
@interface HomSearchTableViewCell : UITableViewCell

@property (strong, nonatomic) JSYHShopModel *shopModel;

@property (copy, nonatomic) void(^activityBlock)();

@end
