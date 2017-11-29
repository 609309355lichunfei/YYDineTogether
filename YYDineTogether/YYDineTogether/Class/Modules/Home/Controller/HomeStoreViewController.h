//
//  HomeStoreViewController.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/11.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSYHDishModel;
@interface HomeStoreViewController : UIViewController
@property (strong, nonatomic) NSString *shopid;
@property (strong, nonatomic) JSYHDishModel *dishModel;
@end
