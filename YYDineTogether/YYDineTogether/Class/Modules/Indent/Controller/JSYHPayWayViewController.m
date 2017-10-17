//
//  JSYHPayWayViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/1.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHPayWayViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "IndentDetailViewController.h"

@interface JSYHPayWayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end

@implementation JSYHPayWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.priceLabel.text = self.price;
}
- (IBAction)backAction:(id)sender {
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"是否要退出支付?" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:1];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        IndentDetailViewController *indentDetialVC = [[IndentDetailViewController alloc] init];
        indentDetialVC.order_no = self.order_no;
        [[AppDelegate shareAppDelegate].mainTabBar.navigationController pushViewController:indentDetialVC animated:YES];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alerVC addAction:action];
    [alerVC addAction:cancelAction];
    [self.navigationController presentViewController:alerVC animated:YES completion:nil];
    
}


- (IBAction)payAction:(id)sender {
    [MBProgressHUD showMessage:@"提交订单中"];
    [[JSRequestManager sharedManager] payWithPaytype:@"2" Orderno:self.order_no Success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *schemes = @"JSZPeiApp";
        [AppDelegate shareAppDelegate].order_no = self.order_no;
        [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"prepayparam"] fromScheme:schemes callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"JSZPpayResult" object:@"6001"];
                [AppManager showToastWithMsg:@"支付失败"];
                [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:1];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                IndentDetailViewController *indentDetialVC = [[IndentDetailViewController alloc] init];
                indentDetialVC.order_no = self.order_no;
                [[AppDelegate shareAppDelegate].mainTabBar.navigationController pushViewController:indentDetialVC animated:YES];
            } else {
                [AppManager showToastWithMsg:@"支付成功"];
                [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:1];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                IndentDetailViewController *indentDetialVC = [[IndentDetailViewController alloc] init];
                indentDetialVC.order_no = self.order_no;
                [[AppDelegate shareAppDelegate].mainTabBar.navigationController pushViewController:indentDetialVC animated:YES];
            }
        }];
        
    } Failed:^(NSError *error) {
        
    }];
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
