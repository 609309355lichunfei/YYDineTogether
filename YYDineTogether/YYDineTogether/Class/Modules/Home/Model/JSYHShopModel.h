//
//  JSYHShopModel.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/22.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSYHShopModel : NSObject
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger star;
@property (assign, nonatomic) NSInteger salescount;
@property (strong, nonatomic) NSArray *activites;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSNumber *shopid;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *notice_info;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *remark;

@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lng;

@property (strong, nonatomic) NSMutableArray *cates;

#pragma mark 自加属性

@property (assign, nonatomic) BOOL optinal;

@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) CGFloat shopCartHeight;

@property (assign, nonatomic) CGFloat orderHeight;

@property (assign, nonatomic) CGFloat searchHeigh;

@property (strong, nonatomic) NSMutableArray *dishs;


//首页根据活动获得高度
- (void)updateHeightWithActivity;

//购物车界面根据食品数量获得高度
- (void)updateHeightWithDish;

//订单界面获得高度
- (void)updateHeightWithOrder;

//搜索界面获得高度
- (void)updateHeightWithSearchView;

@end
