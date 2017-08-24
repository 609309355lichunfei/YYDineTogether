//
//  JSYHAddressModel.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/24.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSYHAddressModel : NSObject
@property (strong, nonatomic) NSNumber *addressid;
@property (strong, nonatomic) NSNumber *lng;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *phone;

@end
