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

@interface LoginViewController ()<UITextFieldDelegate>{
    NSInteger _time;
}
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;
@property (weak, nonatomic) IBOutlet UIImageView *agreeImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginBT;
@property (weak, nonatomic) IBOutlet UIButton *verificationBT;
@property (weak, nonatomic) IBOutlet UILabel *verificationLabel;

@property (strong, nonatomic) NSTimer *timer;

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
    [[JSRequestManager sharedManager] postSmsPhoneNumber:_numberTF.text Success:^(id responseObject) {
        [AppManager showToastWithMsg:@"验证短信已发送"];
        self.verificationBT.enabled = NO;
        [self.verificationBT setBackgroundColor:[UIColor lightGrayColor]];
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        _time = 60;
        self.verificationLabel.text = [NSString stringWithFormat:@"%lds",_time];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            _time --;
            self.verificationLabel.text = [NSString stringWithFormat:@"%lds",_time];
            if (_time == 0) {
                self.verificationBT.enabled = YES;
                [self.verificationBT setBackgroundColor:UIColorFromRGB(0xfd5353)];
                self.verificationLabel.text = @"获取验证码";
                [_timer invalidate];
                _timer = nil;
            }
            
        } repeats:YES];
    } Failed:^(NSError *error) {
        [AppManager showToastWithMsg:@"验证码获取失败"];
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
        [AppManager showToastWithMsg:@"账号密码错误"];
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
