//
//  HomeCityViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/19.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeCityViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface HomeCityViewController ()<MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapBackGroundView;
@property (strong, nonatomic) MAMapView *mapView;
@end

@implementation HomeCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    self.mapView = [[MAMapView alloc] initWithFrame:self.mapBackGroundView.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mapView.delegate = self;
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    self.mapView.showsUserLocation = NO;
    self.mapView.zoomLevel = 12.5;
    [self.mapBackGroundView addSubview:self.mapView];
    
    
    CLLocationCoordinate2D coordinates[6];
    coordinates[0].latitude = 29.892817;
    coordinates[0].longitude = 121.641438;
    
    coordinates[1].latitude = 29.902415;
    coordinates[1].longitude = 121.625817;
    
    coordinates[2].latitude = 29.893896;
    coordinates[2].longitude = 121.597707;
    
    coordinates[3].latitude = 29.8586;
    coordinates[3].longitude = 121.604509;
    
    coordinates[4].latitude = 29.851472;
    coordinates[4].longitude = 121.624186;
    
    coordinates[5].latitude = 29.877896;
    coordinates[5].longitude = 121.646115;
//
//    coordinates[6].latitude = 29.858138265080306;
//    coordinates[6].longitude = 121.62779867649081;
//
//    coordinates[7].latitude = 29.874822520147042;
//    coordinates[7].longitude = 121.63169592618944;
//
//    coordinates[8].latitude = 29.88004377212325;
//    coordinates[8].longitude = 121.6467873752117;
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:6];
    [self.mapView addOverlay:polygon];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(29.868607, 121.619789)];
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polygonRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polygonRenderer.lineWidth   = 4.f;
        polygonRenderer.strokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
//        polygonRenderer.fillColor   = [UIColor redColor];
        
        return polygonRenderer;
    }
    
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    NSLog(@"%f   %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
