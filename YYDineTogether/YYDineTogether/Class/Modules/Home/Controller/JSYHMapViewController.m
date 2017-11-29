//
//  JSYHMapViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 2017/10/25.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface JSYHMapViewController ()<MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) MAMapView *mapView;
@end

@implementation JSYHMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.mapView) {
        self.mapView = [[MAMapView alloc] initWithFrame:self.mainView.bounds];
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.mapView.delegate = self;
        self.mapView.showsScale = NO;
        self.mapView.showsCompass = NO;
        self.mapView.zoomLevel = 12.5;
        [self.mainView addSubview:self.mapView];
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([[JSYHLocationManager sharedManager].lat doubleValue], [[JSYHLocationManager sharedManager].lng doubleValue])];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
