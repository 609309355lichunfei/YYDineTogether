//
//  shippTableViewCell.h
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OPERATIONBLOCK)();

@interface shippTableViewCell : UITableViewCell
@property (copy, nonatomic) OPERATIONBLOCK editBlock;
@property (copy, nonatomic) OPERATIONBLOCK removeBlock;
@end
