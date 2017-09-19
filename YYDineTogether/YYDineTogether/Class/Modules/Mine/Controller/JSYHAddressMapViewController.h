//
//  JSYHAddressMapViewController.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/4.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSYHAddressMapViewController : UIViewController
@property (copy, nonatomic) void(^chooseAddressBlock)(NSString *address, CGFloat lat, CGFloat lng);
@end
