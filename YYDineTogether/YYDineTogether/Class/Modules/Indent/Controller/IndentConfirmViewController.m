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
#import "JSYHSpecificationViewController.h"

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
@property (weak, nonatomic) IBOutlet UILabel *totalpriceLabel;//小计
@property (weak, nonatomic) IBOutlet UILabel *combcutLabel;

@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) MAPointAnnotation *userAnnotation;
@property (strong, nonatomic) MAPolyline *commonPolyline;
@property (strong, nonatomic) JSYHOrderModel *orderModel;
@property (strong, nonatomic) JSYHAddressModel *addressModel;
@property (strong, nonatomic) JSYHCouponModel *couponModel;
@property (strong, nonatomic) NSString *couponid;
@property (assign, nonatomic) NSInteger is_first;//是否是新人红包

@property (strong, nonatomic) NSString *couponValue;

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
    CGFloat tableViewHeight = 0;
    for (JSYHShopModel *model in self.orderModel.shops) {
        tableViewHeight += model.orderHeight;
    }
    self.tableViewHeight.constant = tableViewHeight;
    [self.tableView reloadData];
}

- (void)getConnectOrder {
    [MBProgressHUD showMessage:@"预制订单中"];
    NSArray *dishs = [ShoppingCartManager sharedManager].shoppingCartDataArray;
    NSArray *combs = [ShoppingCartManager sharedManager].shoppingCartComboArray;
    NSMutableArray *dishsArray = [NSMutableArray array];
    for (JSYHDishModel *model in dishs) {
        NSDictionary *modelDic = @{@"count":[NSString stringWithFormat:@"%ld",model.shopcartCount],@"id":[model.dishid stringValue]} ;
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
        self.resultPriceLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.lastprice];
        self.totalpriceLabel.text = self.resultPriceLabel.text;
//        [NSString stringWithFormat:@"%ld",[self.orderModel.lastprice integerValue] - [self.redLabel.text integerValue] + [self.postcost.text integerValue]];
        self.activityLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.cut];
        self.distanceLabel.text = self.orderModel.distance;
        self.combcutLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.combcut];
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
        CLLocationCoordinate2D *commonPolylineCoords = malloc(sizeof(CLLocationCoordinate2D) * shopCount + 1);
        for (NSInteger i = 0; i < shopCount; i ++) {
            JSYHShopModel *model = self.dataArray[i];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.lat doubleValue], [model.lng doubleValue]);
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = coordinate;
            annotation.title = model.name;
            [self.mapView addAnnotation:annotation];
            commonPolylineCoords[i + 1] = coordinate;
        }
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.orderModel.addressModel.lat doubleValue], [self.orderModel.addressModel.lng doubleValue]);
        self.userAnnotation = [[MAPointAnnotation alloc] init];
        self.userAnnotation.coordinate = coordinate;
        self.userAnnotation.title = @"用户";
        [self.mapView addAnnotation:self.userAnnotation];
        commonPolylineCoords[0] = coordinate;
        
        //构造折线对象
        self.commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:shopCount + 1];
        [self.mapView addOverlay:self.commonPolyline];
        JSYHShopModel *model = [self.dataArray firstObject];
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake([model.lat doubleValue], [model.lng doubleValue]);
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    } Failed:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [AppManager showToastWithMsg:@"预定订单失败"];
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
            self.addressLabel.text = [NSString stringWithFormat:@"%@%@",self.addressModel.address,self.addressModel.addressdet];
            [[JSRequestManager sharedManager] getPostcostWithAddressid:[self.addressModel.addressid stringValue] orderNo:self.orderModel.order_no Success:^(id responseObject) {
                NSNumber *postcost = responseObject[@"data"][@"postcost"];
                float price = postcost.integerValue / 100.0;
                postcost = [NSNumber numberWithFloat:price];
                self.postcost.text = [postcost stringValue];
                NSNumber *lastprice = responseObject[@"data"][@"lastprice"];
                CGFloat lastpriceFloat = lastprice.integerValue / 100.0 - [self.couponValue floatValue];
                if (_is_first == 1) {
                    lastpriceFloat = lastpriceFloat + [self.orderModel.cut floatValue];
                }
                if (lastpriceFloat < 0 || lastpriceFloat == 0) {
                    lastpriceFloat = 0.01;
                }
                lastprice = [NSNumber numberWithFloat:lastpriceFloat];
                self.resultPriceLabel.text = [NSString stringWithFormat:@"%@",lastprice];
                self.totalpriceLabel.text = self.resultPriceLabel.text;
            } Failed:^(NSError *error) {
                
            }];
        } Failed:^(NSError *error) {
        }];
    } else {
        self.addressModel = addressModel;
        self.nameLabel.text = self.addressModel.username;
        self.numberLabel.text = self.addressModel.phone;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@",self.addressModel.address,self.addressModel.addressdet];
        
        CLLocationCoordinate2D coordenate = CLLocationCoordinate2DMake([self.addressModel.lat doubleValue], [self.addressModel.lng doubleValue]);
        self.userAnnotation.coordinate = coordenate;
        [[JSRequestManager sharedManager] getPostcostWithAddressid:[self.addressModel.addressid stringValue] orderNo:self.orderModel.order_no Success:^(id responseObject) {
            NSNumber *postcost = responseObject[@"data"][@"postcost"];
            float price = postcost.integerValue / 100.0;
            postcost = [NSNumber numberWithFloat:price];
            self.postcost.text = [postcost stringValue];
            NSNumber *lastprice = responseObject[@"data"][@"lastprice"];
            CGFloat lastpriceFloat = lastprice.integerValue / 100.0 - [self.couponValue floatValue];
            if (_is_first == 1) {
                lastpriceFloat = lastpriceFloat + [self.orderModel.cut floatValue];
            }
            if (lastpriceFloat < 0 || lastpriceFloat == 0) {
                lastpriceFloat = 0.01;
            }
            lastprice = [NSNumber numberWithFloat:lastpriceFloat];
            self.resultPriceLabel.text = [NSString stringWithFormat:@"%@",lastprice];
            self.totalpriceLabel.text = self.resultPriceLabel.text;
        } Failed:^(NSError *error) {
            
        }];
    }
}

- (void)registUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressChange) name:@"JSYHAddressChange" object:nil];
    
    self.couponid = @"0";
    self.couponValue = @"0";
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.mapBackGroundView.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mapView.delegate = self;
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    self.mapView.showsUserLocation = NO;
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
    NSMutableArray *remarksArray = [NSMutableArray array];
    for (JSYHShopModel *shopModel in self.orderModel.shops) {
        if (shopModel.remarks.length > 0) {
            NSDictionary *dic = @{@"shopid":[shopModel.shopid stringValue], @"remark":shopModel.remarks};
            [remarksArray addObject:dic];
        }
    }
    JSYHAddressModel *model = [[DB_Helper defaultHelper] getAddressModel];
    [[JSRequestManager sharedManager] takeorderWithOrderno:self.orderModel.order_no couponid:self.couponid remarks:remarksArray addressid:[model.addressid stringValue]  Success:^(id responseObject) {
        
        
        [[ShoppingCartManager sharedManager] cleanShoppingcart];
        JSYHPayWayViewController *payVC = [[JSYHPayWayViewController alloc] init];
        payVC.order_no = responseObject[@"data"][@"order_no"];
        payVC.price = self.resultPriceLabel.text;
        [self.navigationController pushViewController:payVC animated:YES];
    } Failed:^(NSError *error) {
        
    }];
}
- (IBAction)couponTapAction:(id)sender {
    JSYHCouponViewController *couponVC = [[JSYHCouponViewController alloc] init];
    
    couponVC.shopcount = self.dataArray.count;
    couponVC.chooseCoupon = ^(JSYHCouponModel *model) {
        self.redLabel.text = [NSString stringWithFormat:@"- ¥%@",model.value];
        self.couponValue = [NSString stringWithFormat:@"%@",model.value];
        _is_first = model.is_first;
        self.couponid = [model.coupon_id stringValue];
        CGFloat priceFloat = [self.orderModel.lastprice floatValue] - [self.couponValue integerValue];
        if (_is_first == 1) {
            priceFloat = priceFloat + [self.orderModel.cut floatValue];
            
        }
        if (priceFloat < 0 || priceFloat == 0) {
            priceFloat = 0.01;
        }
        NSNumber *price = [NSNumber numberWithFloat:priceFloat];
        self.resultPriceLabel.text = [NSString stringWithFormat:@"%@",price];
        self.totalpriceLabel.text = self.resultPriceLabel.text;
    };
    [self.navigationController pushViewController:couponVC animated:YES];
}

- (IBAction)specificationAction:(id)sender {
    JSYHSpecificationViewController *specificationVC = [[JSYHSpecificationViewController alloc] init];
    [self.navigationController pushViewController:specificationVC animated:YES];
}


- (void)addressChange {
    [self.mapView removeOverlay:self.commonPolyline];
    NSInteger shopCount = self.orderModel.sortedshops.count;
    CLLocationCoordinate2D *commonPolylineCoords = malloc(sizeof(CLLocationCoordinate2D) * shopCount + 1);
    for (NSInteger i = 0; i < shopCount; i ++) {
        JSYHShopModel *model = self.dataArray[i];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.lat doubleValue], [model.lng doubleValue]);
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = model.name;
        [self.mapView addAnnotation:annotation];
        commonPolylineCoords[i] = coordinate;
    }
    JSYHAddressModel *addressModel = [[DB_Helper defaultHelper] getAddressModel];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([addressModel.lat doubleValue], [addressModel.lng doubleValue]);
    [self.mapView removeAnnotation:self.userAnnotation];
    self.userAnnotation = [[MAPointAnnotation alloc] init];
    self.userAnnotation.coordinate = coordinate;
    self.userAnnotation.title = @"用户";
    [self.mapView addAnnotation:self.userAnnotation];
    commonPolylineCoords[shopCount] = coordinate;
    
    //构造折线对象
    self.commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:shopCount + 1];
    [self.mapView addOverlay:self.commonPolyline];
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
    cell.phoneBT.hidden = YES;
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
        
        polylineRenderer.lineWidth    = 6.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        polylineRenderer.lineDash = YES;
        
        return polylineRenderer;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        if ([[annotation title] isEqualToString:@"用户"]) {
            annotationView.image = [UIImage imageNamed:@"indent_userLocation"];
        } else {
            annotationView.image = [UIImage imageNamed:@"indent_shop1"];
        }
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
