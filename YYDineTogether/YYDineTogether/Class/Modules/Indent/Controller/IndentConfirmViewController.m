//
//  IndentConfirmViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentConfirmViewController.h"
#import "ShoppingChartTableViewCell.h"
#import "IndentChooseAddressViewController.h"
#import "JSYHDishModel.h"
#import "JSYHComboModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "JSYHOrderModel.h"
#import "JSYHShopModel.h"
#import "DB_Helper.h"
#import "JSYHAddressModel.h"
#import "JSYHPreOrderTableViewCell.h"
#import "JSYHPayWayViewController.h"
#import "JSYHCouponViewController.h"
#import "JSYHCouponModel.h"

@interface IndentConfirmViewController ()<UITableViewDelegate, UITableViewDataSource, MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *mapBackGroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *postcost;
@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) JSYHOrderModel *orderModel;
@property (strong, nonatomic) JSYHAddressModel *addressModel;
@property (strong, nonatomic) NSString *couponid;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation IndentConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getAddress];
}

- (void)getConnectOrder {
    NSArray *dishs = [ShoppingCartManager sharedManager].shoppingCartDataArray;
    NSArray *combs = [ShoppingCartManager sharedManager].shoppingCartComboArray;
    NSMutableArray *dishsArray = [NSMutableArray array];
    for (JSYHDishModel *model in dishs) {
        NSDictionary *modelDic = @{@"count":[NSString stringWithFormat:@"%ld",model.count],@"id":[model.dishid stringValue]} ;
        [dishsArray addObject:modelDic];
    }
    NSMutableArray *combsArray = [NSMutableArray array];
    for (JSYHComboModel *model in combs) {
        NSDictionary *modelDic = @{@"id":[model.combid stringValue], @"count":[NSString stringWithFormat:@"%ld",model.count]};
        [combsArray addObject:modelDic];
    }
    NSDictionary *dic = @{@"dishs":dishsArray,@"combs":combsArray};

    [[JSRequestManager sharedManager] postOrderWithDic:dic Success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        NSDictionary *order = data[@"order"];
        self.orderModel = [[JSYHOrderModel alloc] init];
        [self.orderModel setValuesForKeysWithDictionary:order];

        NSDictionary *address = order[@"address"];
        JSYHAddressModel *addressModel = [[JSYHAddressModel alloc] init];
        [addressModel setValuesForKeysWithDictionary:address];
        [[DB_Helper defaultHelper] updateAddress:addressModel];
        [self getAddress];
        self.resultPriceLabel.text = [NSString stringWithFormat:@"%ld",[self.orderModel.lastprice integerValue] - [self.redLabel.text integerValue] + [self.postcost.text integerValue]];
        self.activityLabel.text = [NSString stringWithFormat:@"%ld",self.orderModel.cut];
        self.distanceLabel.text = self.orderModel.distance;
        CGFloat tableViewHeight = 0;
        for (JSYHShopModel *model in self.orderModel.shops) {
            tableViewHeight += model.orderHeight;
        }
        self.tableViewHeight.constant = tableViewHeight;
        self.dataArray = [NSMutableArray array];
        for (NSInteger i = 0; i < self.orderModel.sortedshops.count; i ++) {
            NSNumber *shopid = self.orderModel.sortedshops[i];
            for (JSYHShopModel *model in self.orderModel.shops) {
                if (model.shopid == shopid) {
                    [self.dataArray addObject:model];
                }
            }
        }
        NSInteger shopCount = self.orderModel.sortedshops.count;
        CLLocationCoordinate2D *commonPolylineCoords = malloc(sizeof(CLLocationCoordinate2D) * shopCount);
        for (NSInteger i = 0; i < shopCount; i ++) {
            JSYHShopModel *model = self.dataArray[i];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.lat doubleValue], [model.lng doubleValue]);
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = coordinate;
            annotation.title = model.name;
            [self.mapView addAnnotation:annotation];
            commonPolylineCoords[i] = coordinate;
        }
        
        //构造折线对象
        MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:shopCount];
        [self.mapView addOverlay:commonPolyline];
        JSYHShopModel *model = [self.dataArray firstObject];
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake([model.lat doubleValue], [model.lng doubleValue]);
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        
    }];
}

- (void)getAddress{
    if (self.orderModel == nil) {
        return;
    }
    
    JSYHAddressModel *addressModel = [[DB_Helper defaultHelper] getAddressModel];
    if (addressModel == nil) {
        [[JSRequestManager sharedManager] getMemberAddressSuccess:^(id responseObject) {
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *addressDicArray = dataDic[@"addresses"];
            NSDictionary *addressDic = [addressDicArray firstObject];
            JSYHAddressModel *model = [[JSYHAddressModel alloc] init];
            [model setValuesForKeysWithDictionary:addressDic];
            [[DB_Helper defaultHelper] updateAddress:model];
            self.addressModel = model;
            self.nameLabel.text = self.addressModel.username;
            self.numberLabel.text = self.addressModel.phone;
            self.addressLabel.text = self.addressModel.address;
            [[JSRequestManager sharedManager] getPostcostWithAddressid:[self.addressModel.addressid stringValue] orderNo:self.orderModel.order_no Success:^(id responseObject) {
                NSNumber *postcost = responseObject[@"data"][@"postcost"];
                self.postcost.text = [postcost stringValue];
                self.resultPriceLabel.text = [NSString stringWithFormat:@"%ld",[self.orderModel.lastprice integerValue] - [self.redLabel.text integerValue] + [self.postcost.text integerValue]];
            } Failed:^(NSError *error) {
                
            }];
        } Failed:^(NSError *error) {
        }];
    } else {
        self.addressModel = addressModel;
        self.nameLabel.text = self.addressModel.username;
        self.numberLabel.text = self.addressModel.phone;
        self.addressLabel.text = self.addressModel.address;
        [[JSRequestManager sharedManager] getPostcostWithAddressid:[self.addressModel.addressid stringValue] orderNo:self.orderModel.order_no Success:^(id responseObject) {
            NSNumber *postcost = responseObject[@"data"][@"postcost"];
            self.postcost.text = [postcost stringValue];
            self.resultPriceLabel.text = [NSString stringWithFormat:@"%ld",[self.orderModel.lastprice integerValue] - [self.redLabel.text integerValue] + [self.postcost.text integerValue]];
        } Failed:^(NSError *error) {
            
        }];
    }
}

- (void)registUI {
    self.couponid = @"0";
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.mapBackGroundView.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mapView.delegate = self;
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.zoomLevel = 12.5;
    [self.mapBackGroundView addSubview:self.mapView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHPreOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentConfirmTableViewCell"];
    [self getConnectOrder];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addressAction:(id)sender {
    IndentChooseAddressViewController *chooseAddressVC = [[IndentChooseAddressViewController alloc]init];
    [self.navigationController pushViewController:chooseAddressVC animated:YES];
}
- (IBAction)payAction:(id)sender {
    JSYHAddressModel *model = [[DB_Helper defaultHelper] getAddressModel];
    [[JSRequestManager sharedManager] takeorderWithOrderno:self.orderModel.order_no couponid:self.couponid remarks:@[@{@"shopid":@"1", @"remark":@"remarks"}] addressid:[model.addressid stringValue]  Success:^(id responseObject) {
        
        
        JSYHPayWayViewController *payVC = [[JSYHPayWayViewController alloc] init];
        payVC.order_no = responseObject[@"data"][@"order_no"];
        payVC.price = self.resultPriceLabel.text;
        [self.navigationController pushViewController:payVC animated:YES];
    } Failed:^(NSError *error) {
        
    }];
}
- (IBAction)couponTapAction:(id)sender {
    JSYHCouponViewController *couponVC = [[JSYHCouponViewController alloc] init];
    couponVC.chooseCoupon = ^(JSYHCouponModel *model) {
        self.redLabel.text = [NSString stringWithFormat:@"%ld",model.value];
        self.couponid = [model.coupon_id stringValue];
        self.resultPriceLabel.text = [NSString stringWithFormat:@"%ld",[self.orderModel.lastprice integerValue] - [self.redLabel.text integerValue] + [self.postcost.text integerValue]];
    };
    [self.navigationController pushViewController:couponVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHShopModel *model = self.dataArray[indexPath.row];
    return model.orderHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHPreOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndentConfirmTableViewCell" forIndexPath:indexPath];
    JSYHShopModel *model = self.dataArray[indexPath.row];
    cell.shopModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - MAMapViewDelegate


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation)
    {
        NSLog(@"userlocation :%@", userLocation.location);
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 3.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.image = [UIImage imageNamed:@"indent_shop1"];
        return annotationView;
    }
    return nil;
}

#pragma  mark 懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
