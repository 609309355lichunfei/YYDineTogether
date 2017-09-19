//
//  JSYHTagModel.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/7.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSYHTagModel : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *tagId;

#pragma mark - 自加属性

@property (assign, nonatomic) NSInteger pageIndex;//页面tableView页数

@property (strong, nonatomic) NSMutableArray *dataArray;//tableViewDataArray

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) NSInteger tagIndex;

@end
