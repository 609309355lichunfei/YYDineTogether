//
//  JSYHUserModel.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/24.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSYHUserModel : NSObject

+ (JSYHUserModel *)defaultModel;

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSString *nickname;
@property (assign, nonatomic) NSInteger memberid;
@property (assign, nonatomic) NSInteger sex;
@property (assign, nonatomic) NSInteger birthday;

@property (strong, nonatomic) NSString *ischangelogo;
@property (strong, nonatomic) NSString *changeNickName;
@property (strong, nonatomic) NSString *changeSex;
@property (strong, nonatomic) NSString *changeBirthday;
@end
