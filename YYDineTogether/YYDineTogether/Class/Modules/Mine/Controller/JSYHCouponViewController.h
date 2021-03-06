//
//  JSYHCouponViewController.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/4.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSYHCouponModel;
@interface JSYHCouponViewController : UIViewController

@property (assign, nonatomic) NSInteger shopcount;

@property (strong, nonatomic) NSNumber *totalPrice;

@property (copy, nonatomic) void (^chooseCoupon)(JSYHCouponModel *model);

@end
