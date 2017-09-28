//
//  JSYHLocationManager.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/25.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHLocationManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

static JSYHLocationManager *manager;

static const double a = 6378245.0;
static const double ee = 0.00669342162296594323;
static const double pi = 3.14159265358979324;

@implementation JSYHLocationManager

+ (JSYHLocationManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JSYHLocationManager alloc] init];
        NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:@"JSYHLng"];
        if (lng != nil && lng.length > 0) {
            manager.lng = lng;
        } else {
            manager.lng = @"122.34321";
        }
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"JSYHLat"];
        if (lat != nil && lat.length > 0) {
            manager.lat = lat;
        } else {
            manager.lat = @"32.2222";
        }
        [manager resetLocationManager];
    });
    return manager;
}

- (void)resetLocationManager{
    if (self.locationManager) {
        [self.locationManager startUpdatingLocation];
        return;
    }
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [_locationManager requestWhenInUseAuthorization];//?在后台也可定位
    }
    // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
//        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
    
    self.locationManager.distanceFilter = 5;
    self.locationManager.desiredAccuracy = 18 ;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D mylocation;
    //判断是不是属于国内范围
//    if (![self isLocationOutOfChina:[newLocation coordinate]]) {
//        //转换后的coord
//        mylocation = [self transformFromWGSToGCJ:[newLocation coordinate]];
//    } else {
//        mylocation = newLocation.coordinate;
//    }
    mylocation = AMapCoordinateConvert(CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude), AMapCoordinateTypeGPS);
    self.lngdouble = mylocation.longitude;
    self.latdouble = mylocation.latitude;
    NSNumber *lngNumber = [NSNumber numberWithDouble:self.lngdouble];
    self.lng = [lngNumber stringValue];
    [[NSUserDefaults standardUserDefaults] setValue:self.lng forKey:@"JSYHLng"];
    NSNumber *latNumber = [NSNumber numberWithDouble:self.latdouble];
    self.lat = [latNumber stringValue];
    [[NSUserDefaults standardUserDefaults] setValue:self.lat forKey:@"JSYHLat"];
}

//判断是不是在中国
- (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location
{
    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)
        return YES;
    return NO;
}

#pragma mark - 坐标
//坐标转化
- (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc
{
    CLLocationCoordinate2D adjustLoc;
    if([self isLocationOutOfChina:wgsLoc]){
        adjustLoc = wgsLoc;
    }else{
        double adjustLat = [self transformLatWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
        double adjustLon = [self transformLonWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
        double radLat = wgsLoc.latitude / 180.0 * pi;
        double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = sqrt(magic);
        adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
        adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
        adjustLoc.latitude = wgsLoc.latitude + adjustLat;
        adjustLoc.longitude = wgsLoc.longitude + adjustLon;
    }
    return adjustLoc;
}

- (double)transformLatWithX:(double)x withY:(double)y
{
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

- (double)transformLonWithX:(double)x withY:(double)y
{
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}
@end
