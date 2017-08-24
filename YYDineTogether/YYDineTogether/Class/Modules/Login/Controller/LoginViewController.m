//
//  LoginViewController.m
//  EWDicom
//
//  Created by 李春菲 on 17/6/2.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)getVerificationCodeAction:(id)sender {
    
}

- (IBAction)loginAction:(id)sender {
    [[JSRequestManager sharedManager] loginWithUserName:_numberTF.text Passord:_verificationTF.text Success:^(id responseObject) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    } Failed:^(NSError *error) {
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

@end
