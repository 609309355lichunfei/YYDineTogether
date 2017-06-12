//
//  HomeFilterView.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/11.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeFilterViewDelegate <NSObject>

- (void)homeFilterViewSelectedString:(NSString *)string;

@end

@interface HomeFilterView : UIView
@property (assign, nonatomic) id<HomeFilterViewDelegate> delegate;
@end
