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
#import "POIAnnotation.h"


@interface JSYHAddressMapViewController ()<MAMapViewDelegate, AMapSearchDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    BOOL _isFirst;
}
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;
@property (weak, nonatomic) IBOutlet UIView *addressBGView;
@property (weak, nonatomic) IBOutlet UIView *mapBGView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;




@property (weak, nonatomic) IBOutlet UIView *poilistView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *poiListSearchBar;

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
    _isFirst = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.doneBT.layer.cornerRadius = 20;
    self.addressBGView.layer.cornerRadius = 20;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.mapView = [[MAMapView alloc] initWithFrame:self.mapBGView.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mapView.delegate = self;
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    self.mapView.zoomLevel = 12.5;
    [self.mapBGView addSubview:self.mapView];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([[JSYHLocationManager sharedManager].lat doubleValue], [[JSYHLocationManager sharedManager].lng doubleValue])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"JSYHAddressMapTableviewCell"];
    
}
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender {
    self.chooseAddressBlock([NSString stringWithFormat:@"%@%@",self.addressDetailLabel.text,self.addressTitleLabel.text], self.poi.location.latitude , self.poi.location.longitude);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)poilistBackAction:(id)sender {
    if (self.poiListSearchBar.isFirstResponder) {
        [self.poiListSearchBar resignFirstResponder];
    }
    self.poilistView.hidden = YES;
}

- (IBAction)searchAction:(id)sender {
    self.poilistView.hidden = NO;
    [self.poiListSearchBar becomeFirstResponder];
    [self.tableView reloadData];
    [self.tableView scrollToTop];
}


- (IBAction)changeTapAction:(id)sender {
    self.poilistView.hidden = NO;
    [self.tableView reloadData];
    [self.tableView scrollToTop];
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction || _isFirst) {
        _isFirst = NO;
        CLLocationCoordinate2D coordinate = mapView.centerCoordinate;
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        
        regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        regeo.requireExtension            = YES;
        [self.search AMapReGoecodeSearch:regeo];
    }
    
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

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
//    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (response.pois.count == 0)
    {
        return;
    }
    self.poiArray = response.pois;
    [self.tableView reloadData];
    [self.tableView scrollToTop];
    
//    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
//
//    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
//
//        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
//
//    }];
    
    /* 将结果以annotation的形式加载到地图上. */
//    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
//    if (poiAnnotations.count > 1)
//    {
//        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
//    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
//    else
//    {
//        [self.mapView showAnnotations:poiAnnotations animated:NO];
//    }
}

#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self searchPoiByKeyword:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchPoiByKeyword:(NSString *)keyword
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = keyword;
    //    request.keywords            = @"北京大学";
    request.city                = @"宁波";
    //    request.types               = @"高等院校";
    //    request.requireExtension    = YES;
    //
    //    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.poiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHAddressMapTableviewCell" forIndexPath:indexPath];
    AMapPOI *poiModel = self.poiArray[indexPath.row];
    cell.textLabel.text = poiModel.name;
    cell.detailTextLabel.text = poiModel.address;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.poiListSearchBar.isFirstResponder) {
        [self.poiListSearchBar resignFirstResponder];
    }
    AMapPOI *poiModel = self.poiArray[indexPath.row];
    self.poi = poiModel;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    self.addressTitleLabel.text = self.poi.name;
    self.addressDetailLabel.text = self.poi.address;
    self.poilistView.hidden = YES;
}


- (NSArray<AMapPOI *> *)poiArray {
    if (_poiArray == nil) {
        _poiArray = [NSArray array];
    }
    return _poiArray;
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
