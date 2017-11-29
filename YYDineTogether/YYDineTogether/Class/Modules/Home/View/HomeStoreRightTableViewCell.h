//
//  HomeStoreRightTableViewCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/11.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSYHDishModel;
@interface HomeStoreRightTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *shopname;
@property (strong, nonatomic) NSString *shoplogo;

@property (strong, nonatomic) JSYHDishModel *dishModel;

- (void)twinkBGView;

@end
