//
//  IndentChooseAddressTableViewCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EDITBLOCK)();

@interface IndentChooseAddressTableViewCell : UITableViewCell
@property (copy, nonatomic) EDITBLOCK editBlock;
@end
