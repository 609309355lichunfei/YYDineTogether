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
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconimage;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
   // self.isHidenNaviBar = YES;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    
   self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
     //设计头像图片圆形
    self.iconimage.layer.masksToBounds = YES;
    self.iconimage.layer.cornerRadius = 50;
    self.iconimage.userInteractionEnabled = YES;//打开用户交互
    [self.iconimage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory)]];
    [self.view addSubview:self.tableview];
    
    
    
}

- (void)clickCategory {
    
    PersonalViewController * persona = [PersonalViewController new];
    [self.navigationController pushViewController:persona animated:YES];
}
- (UITableView *)tableview {
    
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMakeAdapt(0, 158, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource= self;
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
            cell.textLabel.text = @"我的优惠券";
                         cell.textLabel.font = [UIFont systemFontOfSize:12 weight:10];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"收货地址";
                        cell.textLabel.font = [UIFont systemFontOfSize:12 weight:10];
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"我的收藏";
            cell.textLabel.font = [UIFont systemFontOfSize:12 weight:10];
        }else{
            cell.textLabel.text = @"浏览记录";
            cell.textLabel.font = [UIFont systemFontOfSize:12 weight:10];
        }
        
      
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"客服中心";
                        cell.textLabel.font = [UIFont systemFontOfSize:12 weight:10];
        }else{
            
            cell.textLabel.text = @"意见反馈";
                        cell.textLabel.font = [UIFont systemFontOfSize:12 weight:10];
        }
    }else if (indexPath.section == 2){
        
        cell.textLabel.text = @"关于我们";
        cell.textLabel.font = [UIFont systemFontOfSize:12 weight:10];
    }
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
          DisCountViewController * disCount = [DisCountViewController new];
          [self.navigationController pushViewController:disCount animated:YES];
        }else if (indexPath.row == 1){
            shippingViewController * ship = [shippingViewController new];
            [self.navigationController pushViewController:ship animated:YES];

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
[self.navigationController pushViewController:infor animated:YES];

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
