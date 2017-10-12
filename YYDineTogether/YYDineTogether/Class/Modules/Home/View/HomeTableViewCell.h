//
//  HomeTableViewCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JSYHShopModel;
@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) JSYHShopModel *shopModel;

@property (copy, nonatomic) void(^activityBlock)();
@end
