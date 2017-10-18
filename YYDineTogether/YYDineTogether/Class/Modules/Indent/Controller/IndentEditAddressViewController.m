//
//  IndentEditAddressViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentEditAddressViewController.h"
#import "JSYHAddressModel.h"
#import "JSYHAddressMapViewController.h"

@interface IndentEditAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;
@property (weak, nonatomic) IBOutlet UILabel *firstAddressLB;

@property (assign, nonatomic) CGFloat lng;
@property (assign, nonatomic) CGFloat lat;

@end

@implementation IndentEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    self.lng = _addressModel.lng.floatValue;
    self.lat = _addressModel.lat.floatValue;
    self.doneBT.layer.cornerRadius = 2;
    self.nameTF.text = _addressModel.username;
    self.phoneTF.text = _addressModel.phone;
    self.firstAddressLB.text = _addressModel.address;
    self.addressTF.text = _addressModel.addressdet;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender {
    NSString *nameStr = [_nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nameStr.length == 0 || nameStr == nil) {
        [AppManager showToastWithMsg:@"请填写姓名"];
        return;
    }
    NSString *phoneStr = [_phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (phoneStr == 0 || phoneStr == nil) {
        [AppManager showToastWithMsg:@"请填写电话号码"];
        return;
    }
    NSString *addressStr = [_addressTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (addressStr.length == 0 || addressStr == nil) {
        [AppManager showToastWithMsg:@"请填写地址"];
        return;
    }
    NSMutableDictionary *addressDic = [@{@"address":self.firstAddressLB.text,@"addressdet":self.addressTF.text,@"username":self.nameTF.text,@"phone":self.phoneTF.text,@"addressid":_addressModel.addressid} mutableCopy];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0.00000"];
    NSNumber *lngNumber = [NSNumber numberWithFloat:_lng];
    NSNumber *latNumber = [NSNumber numberWithFloat:_lat];
    [addressDic setValue:[formatter stringFromNumber:lngNumber] forKey:@"lng"];
    [addressDic setValue:[formatter stringFromNumber:latNumber] forKey:@"lat"];
    [MBProgressHUD showMessage:@"修改中"];
    [[JSRequestManager sharedManager] putMemberAddressWithDic:addressDic Success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [AppManager showToastWithMsg:@"加载失败"];
    }];
}

- (IBAction)EditTapAction:(id)sender {
    JSYHAddressMapViewController *mapVC = [[JSYHAddressMapViewController alloc] init];
    mapVC.chooseAddressBlock = ^(NSString *address , CGFloat lat, CGFloat lng){
        self.firstAddressLB.text = address;
        _lat = lat;
        _lng = lng;
    };
    [self.navigationController pushViewController:mapVC animated:YES];
}



- (IBAction)locationAction:(id)sender {
}

- (void)setAddressModel:(JSYHAddressModel *)addressModel {
    _addressModel = addressModel;
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
