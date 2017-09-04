//
//  JSYHLocationManager.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/25.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JSYHLocationManager : NSObject <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *lat;

@property (assign, nonatomic) double lngdouble;
@property (assign, nonatomic) double latdouble;
+ (JSYHLocationManager *)sharedManager;

@end
