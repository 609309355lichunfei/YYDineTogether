//
//  IndentDetailViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentDetailViewController.h"
#import "ShoppingChartTableViewCell.h"
#import "JSYHPreOrderTableViewCell.h"
#import "JSYHShopModel.h"
#import "JSYHOrderModel.h"
#import "JSYHAddressModel.h"
#import "JSYHPayWayViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface IndentDetailViewController ()<UITableViewDelegate, UITableViewDataSource,MAMapViewDelegate> {
    NSInteger _time;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIView *completeBGView;
@property (weak, nonatomic) IBOutlet UIView *uncompleteBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeight;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timerImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerBGHeight;

@property (weak, nonatomic) IBOutlet UIButton *secondBT;

@property (weak, nonatomic) IBOutlet UIButton *firstAffirmBT;
@property (weak, nonatomic) IBOutlet UIButton *secondAffirmBT;
@property (weak, nonatomic) IBOutlet UIButton *reminderBT;


@property (weak, nonatomic) IBOutlet UILabel *activityLabel;//优惠
@property (weak, nonatomic) IBOutlet UILabel *redLabel;//红包
@property (weak, nonatomic) IBOutlet UILabel *postcost;//配送费
@property (weak, nonatomic) IBOutlet UILabel *resultPriceLabel;//实付

@property (weak, nonatomic) IBOutlet UILabel *order_noLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (strong, nonatomic) JSYHOrderModel *orderModel;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) MAMapView *mapView;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) MAPointAnnotation *userAnnotation;

@property (strong, nonatomic) MAPointAnnotation *riderAnnotation;

@property (strong, nonatomic) MAPolyline *commonPolyline;

@end

@implementation IndentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}



- (void)registUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHPreOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentDetailTableViewCell"];
     [self getConnect];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)getConnect {
    [MBProgressHUD showMessage:@"进入订单详情"];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[JSRequestManager sharedManager] getorderWithOrderNo:self.order_no Success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *orderDic = responseObject[@"data"][@"order"];
        JSYHOrderModel *model = [[JSYHOrderModel alloc] init];
        [model setValuesForKeysWithDictionary:orderDic];
        self.orderModel = model;
        if ((_orderModel.status > 1 && _orderModel.status < 5) || _orderModel.status == 9) {
            self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.titleView.width, self.titleView.height - 100)];
            self.firstAffirmBT.layer.cornerRadius = 4;
            self.firstAffirmBT.layer.borderWidth = 0.5;
            self.firstAffirmBT.layer.borderColor = [UIColorFromRGB(0xfd5353) CGColor];
            self.secondAffirmBT.layer.cornerRadius = 4;
            self.secondAffirmBT.layer.borderWidth = 0.5;
            self.secondAffirmBT.layer.borderColor = [UIColorFromRGB(0xfd5353) CGColor];
            self.reminderBT.layer.cornerRadius = 4;
            self.reminderBT.layer.borderWidth = 0.5;
            self.reminderBT.layer.borderColor = [UIColorFromRGB(0xfd5353) CGColor];
            
            self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            self.mapView.delegate = self;
            self.mapView.showsScale = NO;
            self.mapView.showsCompass = NO;
            self.mapView.zoomLevel = 12.5;
            [self.titleView addSubview:self.mapView];
            switch (_orderModel.status) {
                case 2:{
                    self.statusImageView.image = [UIImage imageNamed:@"indent_status1"];
                    [self.secondBT setTitle:@"取消订单" forState:(UIControlStateNormal)];
                    
                    break;
                }
                case 3:
                    self.statusImageView.image = [UIImage imageNamed:@"indent_status1"];
                    break;
                case 4:
                    self.statusImageView.image = [UIImage imageNamed:@"indent_status2"];
                    break;
                case 9:
                    self.statusImageView.image = [UIImage imageNamed:@"indent_status3"];
                    break;
                default:
                    break;
            }
        } else {
            self.completeBGView.hidden = NO;
            self.titleViewHeight.constant = 250;
            switch (_orderModel.status) {
                case 1:{
                    self.statusLabel.text = @"未支付";
                    self.messageLabel.text = @"逾期未付款,订单将自动取消";
                    [self.secondBT setTitle:@"继续支付" forState:(UIControlStateNormal)];
                    self.secondBT.hidden = NO;
                    self.timerBGHeight.constant = 30;
                    _time = 600 - ([AppManager getNowTimestamp] + [UserManager sharedManager].timerinterval - _orderModel.ordertime) + 10;
                    NSString *minute = [NSString stringWithFormat:@"%ld",_time / 60];
                    if (_time % 60 > 9) {
                        NSString *second = [NSString stringWithFormat:@"%ld",_time % 60];
                        self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                    } else {
                        NSString *second = [NSString stringWithFormat:@"0%ld",_time % 60];
                        self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                    }
                    self.timer = [NSTimer timerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
                        _time --;
                        if (timer == 0) {
                            [AppManager showToastWithMsg:@"支付超时"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        NSString *minute = [NSString stringWithFormat:@"%ld",_time / 60];
                        if (_time % 60 > 9) {
                            NSString *second = [NSString stringWithFormat:@"%ld",_time % 60];
                            self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                        } else {
                            NSString *second = [NSString stringWithFormat:@"0%ld",_time % 60];
                            self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                        }
                        
                        
                    } repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:(NSRunLoopCommonModes)];
                    break;}
                case 10:
                    self.statusLabel.text = @"已完成";
                    self.secondBT.hidden = YES;
                    break;
                case 11:
                    self.statusLabel.text = @"支付超时";
                    self.messageLabel.text = @"未付款,订单已自动取消";
                    self.secondBT.hidden = YES;
                    break;
                case 12:
                    self.statusLabel.text = @"已取消";
                    self.secondBT.hidden = YES;
                    break;
                case 13:
                    self.statusLabel.text = @"已退款";
                    self.secondBT.hidden = YES;
                    break;
                case 14:
                    self.statusLabel.text = @"接单超时";
                    self.messageLabel.text = @"商家未接单,稍后客服将联系您退款";
                    self.secondBT.hidden = YES;
                    break;
                case 15:
                    self.statusLabel.text = @"配送超时";
                    self.secondBT.hidden = YES;
                    break;
                    
                default:
                    break;
            }

        }
        
        self.resultPriceLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.lastprice];
        self.activityLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.cut];
        self.postcost.text = [self.orderModel.postcost stringValue];
        self.redLabel.text = [self.orderModel.couponvalue stringValue];
        self.order_noLabel.text = self.orderModel.order_no;
        self.timeLabel.text = [AppManager timestampSwitchTime:self.orderModel.ordertime];
        self.addressLabel.text = self.orderModel.address;
        
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.orderModel.riderlat doubleValue], [self.orderModel.riderlng doubleValue]);
//        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
//        annotation.coordinate = coordinate;
//        [self.mapView addAnnotation:annotation];
//        [self.mapView setCenterCoordinate:coordinate];
        
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
        
        
        if ((_orderModel.status > 1 && _orderModel.status < 5) || _orderModel.status == 9) {
        NSInteger shopCount = self.orderModel.sortedshops.count;
        CLLocationCoordinate2D *commonPolylineCoords = malloc(sizeof(CLLocationCoordinate2D) * shopCount + 2);
        CLLocationCoordinate2D ridercoordinate = CLLocationCoordinate2DMake([self.orderModel.riderlat doubleValue], [self.orderModel.riderlng doubleValue]);
        self.riderAnnotation = [[MAPointAnnotation alloc] init];
        self.riderAnnotation.coordinate = ridercoordinate;
        self.riderAnnotation.title = @"骑手";
        [self.mapView addAnnotation:self.riderAnnotation];
        commonPolylineCoords[shopCount + 1] = ridercoordinate;
        for (NSInteger i = 0; i < shopCount; i ++) {
            JSYHShopModel *model = self.dataArray[i];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.lat doubleValue], [model.lng doubleValue]);
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = coordinate;
            annotation.title = model.name;
            [self.mapView addAnnotation:annotation];
            commonPolylineCoords[i + 1] = coordinate;
        }
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.orderModel.lat doubleValue], [self.orderModel.lng doubleValue]);
        self.userAnnotation = [[MAPointAnnotation alloc] init];
        self.userAnnotation.coordinate = coordinate;
        self.userAnnotation.title = @"用户";
        [self.mapView addAnnotation:self.userAnnotation];
        commonPolylineCoords[shopCount + 2] = coordinate;
        
       
        
        //构造折线对象
        self.commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:shopCount + 1];
        [self.mapView addOverlay:self.commonPolyline];
            self.mapView.centerCoordinate = CLLocationCoordinate2DMake([self.orderModel.riderlat doubleValue], [self.orderModel.riderlng doubleValue]);
        
        }
        [self.tableView reloadData];
        
    } Failed:^(NSError *error) {
        [AppManager showToastWithMsg:@"查看订单失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)againAction:(id)sender {
    if (self.orderModel.status == 1) {
        JSYHPayWayViewController *payVC = [[JSYHPayWayViewController alloc] init];
        payVC.order_no = self.orderModel.order_no;
        payVC.price = [NSString stringWithFormat:@"%@", self.orderModel.lastprice];
        [self.navigationController pushViewController:payVC animated:YES];
    } else if (self.orderModel.status == 2) {
        [[JSRequestManager sharedManager] cancelorderWithOrderNO:self.orderModel.order_no Success:^(id responseObject) {
            [MBProgressHUD hideHUD];
            [self.navigationController popViewControllerAnimated:YES];
        } Failed:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [AppManager showToastWithMsg:@"取消成功"];
        }];
    }
    
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
    JSYHPreOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndentDetailTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.remarkLabel.userInteractionEnabled = NO;
    JSYHShopModel *model = self.dataArray[indexPath.row];
    cell.shopModel = model;
    return cell;
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
        if ([[annotation title] isEqualToString:@"用户"]) {
            annotationView.image = [UIImage imageNamed:@"indent_map_user"];
        } else if ([[annotation title] isEqualToString:@"骑手"]){
            annotationView.image = [UIImage imageNamed:@"indent_map_rider"];
        } else {
            annotationView.image = [UIImage imageNamed:@"indent_map_shop1"];
        }
        return annotationView;
    }
    return nil;
}

#pragma mark - 懒加载
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
