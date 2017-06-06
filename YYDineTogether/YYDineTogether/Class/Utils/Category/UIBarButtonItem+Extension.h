//
//  UIBarButtonItem+Extension.h
//  ManyMouseMall
//
//  Created by 韩珍珍 on 15/10/20.
//  Copyright © 2015年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;

@end
