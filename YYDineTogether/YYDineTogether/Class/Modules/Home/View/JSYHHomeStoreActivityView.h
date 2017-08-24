//
//  JSYHHomeStoreActivityView.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/11.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSYHActivityModel;
@interface JSYHHomeStoreActivityView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;

@property (strong, nonatomic) JSYHActivityModel *activityModel;

@end
