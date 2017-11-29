//
//  LoginViewController.m
//  EWDicom
//
//  Created by 李春菲 on 17/6/2.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "LoginViewController.h"
#import <JPUSHService.h>
#import "JSYHFirstCouponView.h"
#import "JSYHUserNoteBookViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;
@property (weak, nonatomic) IBOutlet UIImageView *agreeImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginBT;
@property (weak, nonatomic) IBOutlet UIButton *verificationBT;
@property (weak, nonatomic) IBOutlet UILabel *verificationLabel;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSInteger newSecond;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBT.layer.cornerRadius = 23;
    self.verificationBT.layer.cornerRadius = 10;
    self.agreeImageView.highlighted = YES;
}

- (IBAction)backAction:(id)sender {
    [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (IBAction)getVerificationCodeAction:(id)sender {
    NSString *phoneStr = [_numberTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (phoneStr == nil || phoneStr.length == 0) {
        [AppManager showToastWithMsg:@"请输入账号"];
        return;
    }
    [MBProgressHUD showMessage:@"请求验证码中..."];
    [[JSRequestManager sharedManager] postSmsPhoneNumber:_numberTF.text Success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        [AppManager showToastWithMsg:@"验证短信已发送"];
        self.verificationBT.enabled = NO;
        [self.verificationBT setBackgroundColor:[UIColor lightGrayColor]];
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.newSecond = [AppManager getNowTimestamp];
        __block NSInteger time = 60;
        self.verificationLabel.text = [NSString stringWithFormat:@"%lds",time];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            time = 60 - ([AppManager getNowTimestamp] - self.newSecond);
            self.verificationLabel.text = [NSString stringWithFormat:@"%lds",time];
            if (time == 0) {
                self.verificationBT.enabled = YES;
                [self.verificationBT setBackgroundColor:UIColorFromRGB(0xfd5353)];
                self.verificationLabel.text = @"获取验证码";
                [_timer invalidate];
                _timer = nil;
            }
            
        } repeats:YES];
    } Failed:^(NSError *error) {
        [MBProgressHUD hideHUD];
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"请检查网络连接" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"去设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alerVC addAction:action];
        [alerVC addAction:cancelAction];
        [self.navigationController presentViewController:alerVC animated:YES completion:nil];
    }];
}

- (IBAction)loginAction:(id)sender {
    NSString *phoneStr = [_numberTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (phoneStr == nil || phoneStr.length == 0) {
        [AppManager showToastWithMsg:@"请输入账号"];
        return;
    }
    NSString *passwordStr = [_verificationTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (passwordStr == nil || passwordStr.length == 0) {
        [AppManager showToastWithMsg:@"请输入密码"];
        return;
    }
    [MBProgressHUD showMessage:@"登录中"];
    [[JSRequestManager sharedManager] loginWithUserName:_numberTF.text Passord:_verificationTF.text Success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSNumber *errorCode = responseObject[@"errorCode"];
        if ([errorCode isEqualToNumber:@0]) {
            [[ShoppingCartManager sharedManager] shoppingCartReloadData];
            [[ShoppingCartManager sharedManager] addWithAdmin];
            [[JSRequestManager sharedManager] getMemberInfoSuccess:^(id responseObject) {
                NSNumber *memberid = responseObject[@"data"][@"memberid"];
                [JPUSHService setAlias:[NSString stringWithFormat:@"%@",memberid] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    
                } seq:1];
                NSNumber *is_first = responseObject[@"data"][@"is_first"];
                if ([is_first isEqualToNumber:@1]) {
                    JSYHFirstCouponView *firstView = [[NSBundle mainBundle] loadNibNamed:@"JSYHFirstCouponView" owner:nil options:nil].lastObject;
                    firstView.frame = kScreen_Bounds;
                    [[AppDelegate shareAppDelegate].window addSubview:firstView];
                }
            } Failed:^(NSError *error) {
            }];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            [AppManager showToastWithMsg:responseObject[@"message"]];
        }
        
    } Failed:^(NSError *error) {
        [MBProgressHUD hideHUD];
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"请检查网络连接" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"去设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alerVC addAction:action];
        [alerVC addAction:cancelAction];
        [self.navigationController presentViewController:alerVC animated:YES completion:nil];
    }];
    
}

- (IBAction)agreeAction:(id)sender {
    self.agreeImageView.highlighted = !self.agreeImageView.isHighlighted;
    self.loginBT.enabled = self.agreeImageView.highlighted;
}

- (IBAction)readAction:(id)sender {
    JSYHUserNoteBookViewController *notebookVC = [[JSYHUserNoteBookViewController alloc] init];
    [self presentViewController:notebookVC animated:YES completion:nil];
}

- (IBAction)hidenKeyboardAction:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

@end
