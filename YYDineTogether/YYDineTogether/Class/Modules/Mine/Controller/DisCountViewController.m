//
//  DisCountViewController.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "DisCountViewController.h"
#import "TNCustomSegment.h"
@interface DisCountViewController ()<UITableViewDelegate,UITableViewDataSource,TNCustomSegmentDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation DisCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = @"我的优惠券";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem
                                             itemWithImageName:@"Navigation_left" highImageName:@"Navigation_left" target:self action:(@selector(back))];
    NSArray *items = @[@"未使用",@"已使用",@"已过期"];
    
    TNCustomSegment *segment = [[TNCustomSegment alloc] initWithItems:items withFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 30) withSelectedColor:nil withNormolColor:nil withFont:nil];
    segment.delegate = self;
    segment.selectedIndex = 1;
    [self.view addSubview:segment];
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(segment.frame)-44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(segment.frame) + 5);
 
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self.view addSubview:_tableView];
        UIView * view = [UIView new];
        _tableView.tableFooterView = view;
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.selectIndex == 0) {
        return 1;
    }else if (self.selectIndex == 1){
        return 1;
    }else{
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    
    
    return cell;
}

#pragma mark - TNCustomsegmentDelegate
- (void)segment:(TNCustomSegment *)segment didSelectedIndex:(NSInteger)selectIndex{
    
    self.selectIndex = selectIndex;
    
    [self.tableView reloadData];
    
}

@end
