//
//  JSYHOrderModel.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/29.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSYHAddressModel;
@interface JSYHOrderModel : NSObject
@property (strong, nonatomic) NSNumber *postcost;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSNumber *cut;
@property (assign, nonatomic) NSInteger paystatus;
@property (strong, nonatomic) NSString *distance;
@property (assign, nonatomic) NSInteger ordertime;
@property (assign, nonatomic) NSInteger nowtime;
@property (assign, nonatomic) NSInteger paytime;
@property (assign, nonatomic) NSInteger full;
@property (strong, nonatomic) NSString *order_no;
@property (strong, nonatomic) NSNumber *lastprice;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *discountprice;
@property (strong, nonatomic) NSMutableArray *shops;
@property (strong, nonatomic) NSArray *sortedshops;
@property (strong, nonatomic) NSNumber *combcut;
@property (strong, nonatomic) JSYHAddressModel *addressModel;


@property (strong, nonatomic) NSNumber *riderlng;
@property (strong, nonatomic) NSNumber *riderlat;

@property (strong, nonatomic) NSNumber *lng;
@property (strong, nonatomic) NSNumber *lat;

@property (strong, nonatomic) NSString *ridername;
@property (strong, nonatomic) NSNumber *cancel;
@property (strong, nonatomic) NSString *riderphone;
@property (assign, nonatomic) NSInteger refund;
@property (strong, nonatomic) NSNumber *couponvalue;
@property (assign, nonatomic) NSInteger riderid;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *riderdistance;
@property (strong, nonatomic) NSString *addressdet;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *address;





#pragma mark - 自加属性

@property (assign, nonatomic) CGFloat height;

- (void)updateOrderHeight;


@end
