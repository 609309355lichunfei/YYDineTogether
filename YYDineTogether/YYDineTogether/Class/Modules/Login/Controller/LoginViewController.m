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

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)backAction:(id)sender {
    [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)getVerificationCodeAction:(id)sender {
    
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
            [JPUSHService setAlias:_numberTF.text completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:1];
            [self dismissViewControllerAnimated:YES completion:^{
                [[JSRequestManager sharedManager] getMemberInfoSuccess:^(id responseObject) {
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
- (IBAction)hidenKeyboardAction:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

@end
