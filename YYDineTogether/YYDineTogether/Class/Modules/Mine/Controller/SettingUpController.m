//
//  SettingUpController.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/6.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "SettingUpController.h"
#import "PassWordViewController.h"
@interface SettingUpController ()<UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic)  UITableView *tableview;
@end

@implementation SettingUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
     [self.view addSubview:self.tableview];
}

- (UITableView *)tableview {
    
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMakeAdapt(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource= self;
        //  _tableview.backgroundColor = [UIColor whiteColor];
    }
    return _tableview;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 3;
   
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"密码修改";
            cell.textLabel.font = [UIFont systemFontOfSize:12 weight:10];
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"换绑手机";
            cell.textLabel.font = [UIFont systemFontOfSize:12 weight:10];
        }else{
            cell.textLabel.text = @"第三方账号绑定";
            cell.textLabel.font = [UIFont systemFontOfSize:12 weight:10];
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"清楚缓存";
            cell.textLabel.font = [UIFont systemFontOfSize:12 weight:10];
        }
    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
           PassWordViewController * password = [PassWordViewController new];
           [self.navigationController pushViewController:password animated:YES];
        }else {
          
            
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
        }else{
            
        }
    }
    
    
}


@end
