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
@interface PersonalViewController ()

@property (strong, nonatomic) UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
 
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
    self.myDatePicker.center = self.view.center;
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
        formatter.dateFormat = @"MM-dd";
        NSString *dateStr = [formatter stringFromDate:date];
        self.dateTF.text = dateStr;
        [backGroundView removeFromSuperview];
    }];
    [okBT setTitle:@"确定" forState:(UIControlStateNormal)];
    okBT.frame = CGRectMake(self.myDatePicker.mj_x, CGRectGetMaxY(self.myDatePicker.frame), self.myDatePicker.width, 40);
    [backGroundView addSubview:okBT];
    
    [cancelBT addBlockForControlEvents:(UIControlEventTouchUpInside) block:^(id  _Nonnull sender) {
        [backGroundView removeFromSuperview];
    }];
    [cancelBT setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBT setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    cancelBT.frame = CGRectMake(self.myDatePicker.mj_x, CGRectGetMaxY(okBT.frame), self.myDatePicker.width, 40);
    [backGroundView addSubview:cancelBT];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setAJImageheadData {
    
    [[AJImageheadData  shareInstance] showActionSheetInView:self.view fromController:self completion:^(UIImage *image, NSData *iamgeData) {
        
        
    } cancelBlock:^{
        
    }];
}

- (void )setActionSheetStringPicker {
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithObjects:@"男",@"女", nil];

    ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:@"性别" rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        //*********一组点击确认按钮做处理************
        

        NSLog(@"生日---------%@",selectedValue);
        
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
    [actionPicker customizeInterface];
    [actionPicker showActionSheetPicker];
}

- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker {
    
}





@end
