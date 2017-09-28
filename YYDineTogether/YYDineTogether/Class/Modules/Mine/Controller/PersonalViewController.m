//
//  PersonalViewController.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "PersonalViewController.h"
#import "AJImageheadData.h"
#import "ActionSheetPicker.h"
#import "AbstractActionSheetPicker+Interface.h"
#import "JSYHUserModel.h"
#import "JSYHUserNickNameEditViewController.h"
@interface PersonalViewController ()

@property (strong, nonatomic) UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;

@property (strong, nonatomic) NSData *imageData;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self registUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([JSYHUserModel defaultModel].changeNickName != nil || [JSYHUserModel defaultModel].changeNickName.length > 0) {
        self.nickNameTF.text = [JSYHUserModel defaultModel].changeNickName;
    }
    
}

- (void)registUI {
    [self getConnect];
}

- (void)getConnect {
    [[JSRequestManager sharedManager] getMemberInfoSuccess:^(id responseObject) {
        NSDictionary *dataDic = responseObject[@"data"];
        [[JSYHUserModel defaultModel] setValuesForKeysWithDictionary:dataDic];
        [self fillData];
    } Failed:^(NSError *error) {
        
    }];
}

- (void)fillData {
    self.nickNameTF.text = [JSYHUserModel defaultModel].nickname;
    self.sexTF.text = [JSYHUserModel defaultModel].sex == 0 ? @"男" : @"女";
    self.dateTF.text = [AppManager birthTimestanpSwitchTime:[JSYHUserModel defaultModel].birthday];
    [self.logoImageView setImageWithURL:[NSURL URLWithString:[JSYHUserModel defaultModel].logo] placeholder:nil];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)imageAction:(id)sender {
    [self setAJImageheadData];
}

- (IBAction)sexAction:(id)sender {
    [self setActionSheetStringPicker];
}

- (IBAction)dateAction:(id)sender {
    UIView *backGroundView = [[UIView alloc] initWithFrame:kScreen_Bounds];
    backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [backGroundView removeFromSuperview];
    }];
    [backGroundView addGestureRecognizer:tap];
    [self.view addSubview:backGroundView];
    self.myDatePicker = [[UIDatePicker alloc] init];
    self.myDatePicker.backgroundColor = [UIColor whiteColor];
    self.myDatePicker.frame = CGRectMake(0, KScreenHeight - 185, KScreenWidth, 185);
    self.myDatePicker.datePickerMode = UIDatePickerModeDate;
    [backGroundView addSubview:self.myDatePicker];
    NSDate *todayDate = [NSDate date];
    self.myDatePicker.date = todayDate;
    UIButton *okBT = [UIButton buttonWithType:(UIButtonTypeSystem)];
    UIButton *cancelBT = [UIButton buttonWithType:(UIButtonTypeSystem)];
    okBT.backgroundColor = [UIColor whiteColor];
    cancelBT.backgroundColor = [UIColor whiteColor];
    [okBT addBlockForControlEvents:(UIControlEventTouchUpInside) block:^(id  _Nonnull sender) {
        NSDate *date = _myDatePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd";
        NSString *dateStr = [formatter stringFromDate:date];
        self.dateTF.text = dateStr;
        [JSYHUserModel defaultModel].changeBirthday = self.dateTF.text;
        [backGroundView removeFromSuperview];
    }];
    [okBT setTitle:@"确定" forState:(UIControlStateNormal)];
    okBT.titleLabel.textAlignment = NSTextAlignmentRight;
    okBT.frame = CGRectMake(KScreenWidth / 2, self.myDatePicker.mj_y - 45,KScreenWidth / 2, 45);
    [backGroundView addSubview:okBT];
    
    [cancelBT addBlockForControlEvents:(UIControlEventTouchUpInside) block:^(id  _Nonnull sender) {
        [backGroundView removeFromSuperview];
    }];
    [cancelBT setTitle:@"取消" forState:(UIControlStateNormal)];
    okBT.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelBT setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    cancelBT.frame = CGRectMake(0, self.myDatePicker.mj_y - 45, KScreenWidth / 2, 45);
    [backGroundView addSubview:cancelBT];
}
- (IBAction)nickNameTapAction:(id)sender {
    JSYHUserNickNameEditViewController *editNickNameVC = [[JSYHUserNickNameEditViewController alloc] init];
    [self.navigationController pushViewController:editNickNameVC animated:YES];
}
- (IBAction)saveInfo:(id)sender {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if ([JSYHUserModel defaultModel].changeNickName != nil) {
        [dataDic setValue:[JSYHUserModel defaultModel].changeNickName forKey:@"nickname"];
    } else {
        [dataDic setValue:[JSYHUserModel defaultModel].nickname forKey:@"nickname"];
    }
    if ([JSYHUserModel defaultModel].changeSex != nil) {
        [dataDic setValue:[JSYHUserModel defaultModel].changeSex forKey:@"sex"];
    } else {
        [dataDic setValue:[NSString stringWithFormat:@"%ld",[JSYHUserModel defaultModel].sex] forKey:@"sex"];
    }
    if ([JSYHUserModel defaultModel].changeBirthday != nil) {
        [dataDic setValue:[NSString stringWithFormat:@"%ld", [AppManager birthTimeSwitchTimestamp:[JSYHUserModel defaultModel].changeBirthday]] forKey:@"birthday"];
        
    } else {
        [dataDic setValue:[NSString stringWithFormat:@"%ld",[JSYHUserModel defaultModel].birthday] forKey:@"birthday"];
    }
    [dataDic setValue:[JSYHUserModel defaultModel].ischangelogo forKey:@"is_changelogo"];
    
    [[JSRequestManager sharedManager] putMemberInfoWithDic:dataDic data:self.imageData Success:^(id responseObject) {
        [JSYHUserModel defaultModel].changeBirthday = nil;
        [JSYHUserModel defaultModel].changeSex = nil;
        [JSYHUserModel defaultModel].changeNickName = nil;
        [JSYHUserModel defaultModel].ischangelogo = @"0";
        [self.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [AppManager showToastWithMsg:@"保存失败"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setAJImageheadData {
    
    [[AJImageheadData  shareInstance] showActionSheetInView:self.view fromController:self completion:^(UIImage *image, NSData *iamgeData) {
        [JSYHUserModel defaultModel].ischangelogo = @"1";
        self.logoImageView.image = image;
        self.imageData = iamgeData;
        if (@available(iOS 11.0, *)) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    } cancelBlock:^{
        if (@available(iOS 11.0, *)) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }];
}

- (void )setActionSheetStringPicker {
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithObjects:@"男",@"女", nil];

    ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:@"性别" rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        //*********一组点击确认按钮做处理************
        switch (selectedIndex) {
            case 0:
                [JSYHUserModel defaultModel].changeSex = @"0";
                self.sexTF.text = @"男";
                break;
            case 1:
                [JSYHUserModel defaultModel].changeSex = @"1";
                self.sexTF.text= @"女";
                break;
                
            default:
                break;
        }

        
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
    [actionPicker customizeInterface];
    [actionPicker showActionSheetPicker];
}

- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker {
    
}





@end
