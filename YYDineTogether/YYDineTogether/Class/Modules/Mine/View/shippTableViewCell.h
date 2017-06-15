//
//  shippTableViewCell.h
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol shippTableViewCellDelegate <NSObject>
- (void)CompileWithBt;
@end

@interface shippTableViewCell : UITableViewCell
+ (instancetype) InstallTableViewCellWith:(UITableView *)tableview indexPath:(NSIndexPath *)indexPath;
- (void)configInstallTableCellWith:(NSIndexPath *)indexPath;

@property (weak,nonatomic)id <shippTableViewCellDelegate>delegate;
@end
