//
//  MineViewController.m
//  EWDicom
//
//  Created by 李春菲 on 17/6/2.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "MineViewController.h"
#import "inforViewController.h"
#import "PersonalViewController.h"
#import "shippingViewController.h"
#import "SettingUpController.h"
#import "DisCountViewController.h"
#import "MineTableViewCell.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconimage;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
     //设计头像图片圆形
    [self.view addSubview:self.tableview];
    
    
    
}

- (IBAction)userTapAction:(id)sender {
    PersonalViewController * persona = [PersonalViewController new];
    [self.tabBarController.navigationController pushViewController:persona animated:YES];
}

- (UITableView *)tableview {
    
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource= self;
        [_tableview registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell"];
      //  _tableview.backgroundColor = [UIColor whiteColor];
    }
    return _tableview;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 4;
    if (section == 1) return 2;

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.myLabel.text = @"我的优惠券";
            cell.myImageView.image = [UIImage imageNamed:@"mine_我的优惠券"];
        }else if (indexPath.row == 1){
            cell.myLabel.text = @"收货地址";
            cell.myImageView.image = [UIImage imageNamed:@"mine_收货地址"];
        }else if (indexPath.row == 2){
            cell.myLabel.text = @"我的收藏";
            cell.myImageView.image = [UIImage imageNamed:@"mine_我的收藏"];
        }else{
            cell.myLabel.text = @"浏览记录";
            cell.myImageView.image = [UIImage imageNamed:@"mine_浏览记录"];
        }
        
      
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            cell.myLabel.text = @"客服中心";
            cell.myImageView.image = [UIImage imageNamed:@"mine_客服中心"];
        }else{
            
            cell.myLabel.text = @"意见反馈";
            cell.myImageView.image = [UIImage imageNamed:@"mine_意见反馈"];
        }
    }else if (indexPath.section == 2){
        
        cell.myLabel.text = @"关于我们";
        cell.myImageView.image = [UIImage imageNamed:@"mine_关于我们"];
    }
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
          DisCountViewController * disCount = [DisCountViewController new];
          [self.tabBarController.navigationController pushViewController:disCount animated:YES];
        }else if (indexPath.row == 1){
            shippingViewController * ship = [shippingViewController new];
            [self.tabBarController.navigationController pushViewController:ship animated:YES];

        }else if (indexPath.row == 2){
            
        }else{
            
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
          
        }else{
            
        }
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            
                   }else{
          
        }
    }
    
    
   
}

//消息通知
- (IBAction)inform:(id)sender {
inforViewController * infor = [inforViewController new];
[self.tabBarController.navigationController pushViewController:infor animated:YES];

}
//设置
- (IBAction)settingUp:(id)sender {
SettingUpController * setting = [SettingUpController new];
[self.navigationController pushViewController:setting animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
