//
//  JSYHAddressMapViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/4.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHAddressMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface JSYHAddressMapViewController ()<MAMapViewDelegate, AMapSearchDelegate>
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;
@property (weak, nonatomic) IBOutlet UIView *addressBGView;
@property (weak, nonatomic) IBOutlet UIView *mapBGView;

@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) AMapSearchAPI *search;
@property (strong, nonatomic) AMapPOI *poi;

@property (strong, nonatomic) NSArray<AMapPOI *> *poiArray;
@end

@implementation JSYHAddressMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    self.doneBT.layer.cornerRadius = 20;
    self.addressBGView.layer.cornerRadius = 20;
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.mapBGView.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mapView.delegate = self;
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.zoomLevel = 12.5;
    [self.mapBGView addSubview:self.mapView];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([[JSYHLocationManager sharedManager].lat doubleValue], [[JSYHLocationManager sharedManager].lng doubleValue])];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender {
    self.chooseAddressBlock([NSString stringWithFormat:@"%@%@",self.addressDetailLabel.text,self.addressTitleLabel.text], self.poi.location.latitude , self.poi.location.longitude);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeTapAction:(id)sender {
    
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    CLLocationCoordinate2D coordinate = mapView.centerCoordinate;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        //解析response获取地址描述，具体解析见 Demo
        NSLog(@"=========%@",response.regeocode.pois.firstObject);
        self.poiArray = response.regeocode.pois;
        self.poi = response.regeocode.pois.firstObject;
        self.addressTitleLabel.text = _poi.name;
        self.addressDetailLabel.text = _poi.address;
    }
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
