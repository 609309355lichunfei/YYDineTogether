//
//  HomeCityViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/19.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeCityViewController.h"

@interface HomeCityViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *cityArray;
@end

@implementation HomeCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeCityTableViewCell"];
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *provinceDic = self.cityArray[section];
    return provinceDic[@"provinceName"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *provinceDic = self.cityArray[section];
    NSArray *cityList = provinceDic[@"citylist"];
    return cityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCityTableViewCell" forIndexPath:indexPath];
    NSDictionary *provinceDic = self.cityArray[indexPath.section];
    NSArray *cityList = provinceDic[@"citylist"];
    NSDictionary *cityDic = cityList[indexPath.row];
    cell.textLabel.text = cityDic[@"cityName"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *provinceDic = _cityArray[indexPath.section];
    NSArray *cityList = provinceDic[@"citylist"];
    NSDictionary *cityDic = cityList[indexPath.row];
    _cityLabel.text = cityDic[@"cityName"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (NSArray *)cityArray {
    if (_cityArray == nil) {
        _cityArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"citydata" ofType:@"plist"]];
    }
    return _cityArray;
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
