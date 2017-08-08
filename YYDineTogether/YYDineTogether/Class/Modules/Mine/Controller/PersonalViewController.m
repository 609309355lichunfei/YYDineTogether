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


@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
 
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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



@end
