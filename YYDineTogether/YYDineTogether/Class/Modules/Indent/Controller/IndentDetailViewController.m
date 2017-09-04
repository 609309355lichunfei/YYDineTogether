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
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface IndentDetailViewController ()<UITableViewDelegate, UITableViewDataSource,MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIView *completeBGView;
@property (weak, nonatomic) IBOutlet UIView *uncompleteBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeight;
@property (weak, nonatomic) IBOutlet UIView *titleView;



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

@end

@implementation IndentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}



- (void)registUI {
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
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.zoomLevel = 12.5;
    [self.titleView addSubview:self.mapView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHPreOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentDetailTableViewCell"];
    [self getConnect];
}

- (void)getConnect {
    [[JSRequestManager sharedManager] getorderWithOrderNo:self.order_no Success:^(id responseObject) {
        NSDictionary *orderDic = responseObject[@"data"][@"order"];
        JSYHOrderModel *model = [[JSYHOrderModel alloc] init];
        [model setValuesForKeysWithDictionary:orderDic];
        self.orderModel = model;
        
        self.resultPriceLabel.text = [self.orderModel.lastprice stringValue];
        self.activityLabel.text = [NSString stringWithFormat:@"%ld",self.orderModel.cut];
        self.postcost.text = [self.orderModel.postcost stringValue];
        self.redLabel.text = [self.orderModel.couponvalue stringValue];
        self.order_noLabel.text = self.orderModel.order_no;
        self.timeLabel.text = [AppManager timestampSwitchTime:self.orderModel.ordertime];
        self.addressLabel.text = self.orderModel.address;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.orderModel.riderlat doubleValue], [self.orderModel.riderlng doubleValue]);
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        [self.mapView addAnnotation:annotation];
        [self.mapView setCenterCoordinate:coordinate];
        
        CGFloat tableViewHeight = 0;
        for (JSYHShopModel *model in self.orderModel.shops) {
            tableViewHeight += model.orderHeight;
        }
        self.tableViewHeight.constant = tableViewHeight;
        self.dataArray = self.orderModel.shops;
        [self.tableView reloadData];
        
    } Failed:^(NSError *error) {
        
    }];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)againAction:(id)sender {
    
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
    JSYHShopModel *model = self.dataArray[indexPath.row];
    cell.shopModel = model;
    return cell;
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
        annotationView.image = [UIImage imageNamed:@"indent_rider"];
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
