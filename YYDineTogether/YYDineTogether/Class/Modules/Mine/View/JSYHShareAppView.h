//
//  JSYHShareAppView.h
//  YYDineTogether
//
//  Created by 吴頔 on 2017/11/23.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSYHShareAppView : UIView
@property (copy, nonatomic) void(^friendsBlock)();
@property (copy, nonatomic) void(^wxBlock)();
@end
