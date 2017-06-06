//
//  LCPanNavigationController.h
//  PanBackDemo
//
//  Created by clovelu on 5/30/14.
//
//

#import <UIKit/UIKit.h>

@interface LCPanNavigationController : UINavigationController

@property (readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end