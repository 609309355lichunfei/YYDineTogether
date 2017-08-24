//
//  JSYHUserNickNameEditViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/24.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHUserNickNameEditViewController.h"
#import "JSYHUserModel.h"

@interface JSYHUserNickNameEditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;

@end

@implementation JSYHUserNickNameEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveAction:(id)sender {
    NSString *nickNameStr = [_nickNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nickNameStr.length == 0 || nickNameStr == nil) {
        [AppManager showToastWithMsg:@"请填写昵称"];
        return;
    }
    [JSYHUserModel defaultModel].changeNickName = nickNameStr;
    [self.navigationController popViewControllerAnimated:YES];
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
