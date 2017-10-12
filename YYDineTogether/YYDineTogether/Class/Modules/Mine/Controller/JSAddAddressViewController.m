//
//  JSAddAddressViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/24.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSAddAddressViewController.h"
#import "JSYHAddressMapViewController.h"

@interface JSAddAddressViewController ()
@property (weak, nonatomic) IBOutlet UIButton *doneBT;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstAddressTF;

@property (assign, nonatomic) CGFloat lat;
@property (assign, nonatomic) CGFloat lng;

@end

@implementation JSAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.doneBT.layer.cornerRadius = 2;
    _lng = 0.0;
    _lat = 0.0;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender {
    NSString *nameStr = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nameStr.length == 0 || nameStr == nil) {
        [AppManager showToastWithMsg:@"请填写姓名"];
        return;
    }
    NSString *phoneStr = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (phoneStr == 0 || phoneStr == nil) {
        [AppManager showToastWithMsg:@"请填写电话号码"];
        return;
    }
    NSString *addressStr = [_addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (addressStr.length == 0 || addressStr == nil) {
        [AppManager showToastWithMsg:@"请填写地址"];
        return;
    }
    NSString *firstAddressStr = [_firstAddressTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (firstAddressStr.length == 0 || firstAddressStr == nil) {
        [AppManager showToastWithMsg:@"请填写地址"];
        return;
    }
    NSMutableDictionary *addressDic = [@{@"address":[NSString stringWithFormat:@"%@%@",self.firstAddressTF.text, self.addressTextField.text],@"username":self.nameTextField.text,@"phone":self.phoneTextField.text,@"addressid":@"0"} mutableCopy];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0.00000"];
    NSNumber *lngNumber = [NSNumber numberWithFloat:_lng];
    NSNumber *latNumber = [NSNumber numberWithFloat:_lat];
    [addressDic setValue:[formatter stringFromNumber:lngNumber] forKey:@"lng"];
    [addressDic setValue:[formatter stringFromNumber:latNumber] forKey:@"lat"];
    [[JSRequestManager sharedManager] postMemberAddressWithDic:addressDic Success:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [AppManager showToastWithMsg:@"添加地址失败"];
    }];
}

- (IBAction)addressTapAction:(id)sender {
    JSYHAddressMapViewController *mapVC = [[JSYHAddressMapViewController alloc] init];
    mapVC.chooseAddressBlock = ^(NSString *address , CGFloat lat, CGFloat lng){
        self.firstAddressTF.text = address;
        _lat = lat;
        _lng = lng;
    };
    [self.navigationController pushViewController:mapVC animated:YES];
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
