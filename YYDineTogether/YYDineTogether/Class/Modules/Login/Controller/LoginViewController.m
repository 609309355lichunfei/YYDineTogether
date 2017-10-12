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

- (IBAction)getVerificationCodeAction:(id)sender {
    [[JSRequestManager sharedManager] postSmsPhoneNumber:_numberTF.text Success:^(id responseObject) {
        [AppManager showToastWithMsg:@"验证短信已发送"];
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
    [[JSRequestManager sharedManager] loginWithUserName:_numberTF.text Passord:_verificationTF.text Success:^(id responseObject) {
        NSNumber *errorCode = responseObject[@"errorCode"];
        if ([errorCode isEqualToNumber:@0]) {
            [[ShoppingCartManager sharedManager] shoppingCartReloadData];
            [[ShoppingCartManager sharedManager] addWithAdmin];
            [self dismissViewControllerAnimated:YES completion:^{
                [[JSRequestManager sharedManager] getMemberInfoSuccess:^(id responseObject) {
                    NSNumber *memberid = responseObject[@"data"][@"memberid"];
                    [JPUSHService setAlias:[NSString stringWithFormat:@"%@",memberid] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        
                    } seq:1];
                    NSNumber *is_first = responseObject[@"data"][@"is_first"];
                    if ([is_first isEqualToNumber:@1]) {
                        JSYHFirstCouponView *firstView = [[NSBundle mainBundle] loadNibNamed:@"JSYHFirstCouponView" owner:nil options:nil].lastObject;
                        firstView.bounds = kScreen_Bounds;
                        [[AppDelegate shareAppDelegate].mainNavi.view addSubview:firstView];
                    }
                } Failed:^(NSError *error) {
                    
                }];
            }];
        } else {
            [AppManager showToastWithMsg:responseObject[@"message"]];
        }
        
    } Failed:^(NSError *error) {
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
