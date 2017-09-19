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
#import "MsgViewController.h"
#import "JSYHUserModel.h"
#import "JSYHFeedbackViewController.h"
#import "JSYHCouponViewController.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconimage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
     //设计头像图片圆形
    [self.view addSubview:self.tableview];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([JSRequestManager sharedManager].userName == nil || [JSRequestManager sharedManager].userName.length == 0) {
        self.userNameLabel.text = @"登录/注册";
        [self.iconimage setImage:[UIImage imageNamed:@"default_user"]];
    }else {
        [[JSRequestManager sharedManager] getMemberInfoSuccess:^(id responseObject) {
            [[JSYHUserModel defaultModel] setValuesForKeysWithDictionary:responseObject[@"data"]];
            [self.iconimage setImageWithURL:[NSURL URLWithString:[JSYHUserModel defaultModel].logo] placeholder:nil];
            self.userNameLabel.text = [JSYHUserModel defaultModel].nickname;
        } Failed:^(NSError *error) {
            
        }];
    }
    
}

- (IBAction)userTapAction:(id)sender {
    if ([self.userNameLabel.text isEqualToString:@"登录/注册"]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.tabBarController presentViewController:loginVC animated:YES completion:^{
        }];
    } else {
        PersonalViewController * persona = [PersonalViewController new];
        [self.tabBarController.navigationController pushViewController:persona animated:YES];

    }
}

- (UITableView *)tableview {
    
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, KScreenWidth, KScreenHeight - 264) style:UITableViewStyleGrouped];
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
            cell.myLabel.text = @"我的吃货";
            cell.myImageView.image = [UIImage imageNamed:@"mine_eat"];
        }else if (indexPath.row == 1){
            cell.myLabel.text = @"收货地址";
            cell.myImageView.image = [UIImage imageNamed:@"mine_address"];
        }else if (indexPath.row == 2){
            cell.myLabel.text = @"我的红包";
            cell.myImageView.image = [UIImage imageNamed:@"mine_redBag"];
        }else{
            cell.myLabel.text = @"我的收藏";
            cell.myImageView.image = [UIImage imageNamed:@"mine_record"];
        }
        
      
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            cell.myLabel.text = @"客服中心";
            cell.myImageView.image = [UIImage imageNamed:@"mine_serviceCenter"];
        }else{
            
            cell.myLabel.text = @"意见反馈";
            cell.myImageView.image = [UIImage imageNamed:@"mine_opinion"];
        }
    }else if (indexPath.section == 2){
        
        cell.myLabel.text = @"关于我们";
        cell.myImageView.image = [UIImage imageNamed:@"mine_aboutUs"];
    }
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            MsgViewController *msgVC = [[MsgViewController alloc] init];
//            msgVC.isMine = YES;
//            [self.tabBarController.navigationController pushViewController:msgVC animated:YES];
            [AppManager showToastWithMsg:@"开发中,敬请期待"];
        }else if (indexPath.row == 1){
            shippingViewController * ship = [shippingViewController new];
            [self.tabBarController.navigationController pushViewController:ship animated:YES];

        }else if (indexPath.row == 2){
            JSYHCouponViewController *couponVC = [[JSYHCouponViewController alloc] init];
            couponVC.chooseCoupon = nil;
            [self.tabBarController.navigationController pushViewController:couponVC animated:YES];
        }else{
            
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"是否要联系客服?" message:@"010-23355623" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                NSString *allString = [NSString stringWithFormat:@"tel:010-23355623"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
            [alerVC addAction:action];
            [alerVC addAction:cancelAction];
            [self.navigationController presentViewController:alerVC animated:YES completion:nil];
        }else{
            JSYHFeedbackViewController *feedbackVC = [[JSYHFeedbackViewController alloc] init];
            [self.tabBarController.navigationController pushViewController:feedbackVC animated:YES];
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
