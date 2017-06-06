//
//  LCPanBackProtocol.h
//  PanBackDemo
//
//  Created by hbwang on 14-9-3.
//  Copyright (c) 2014年 clovelu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LCPanBackDelegate <NSObject>

@optional
- (BOOL)enablePanBack;
- (void)startPanBack;
- (void)finishPanBack;
- (void)resetPanBack;

@end
