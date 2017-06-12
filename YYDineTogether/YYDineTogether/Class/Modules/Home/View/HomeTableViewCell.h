//
//  HomeTableViewCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HomeTableViewCellType) {
    HomeTableViewCellTypeStore,
    HomeTableViewCellTypeFood
};

@interface HomeTableViewCell : UITableViewCell
@property (assign, nonatomic) HomeTableViewCellType type;
@end
