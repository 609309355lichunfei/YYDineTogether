//
//  JSYHEditRemarksViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/11.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHEditRemarksViewController.h"
#import "JSYHShopModel.h"

@interface JSYHEditRemarksViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *remarksTextView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation JSYHEditRemarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    self.remarksTextView.layer.cornerRadius = 4;
    self.remarksTextView.layer.borderWidth = 0.5;
    self.remarksTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.remarksTextView.text = self.shopModel.remarks;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender {
    if (self.remarksTextView.text.length > 50) {
        [AppManager showToastWithMsg:@"超过规定字数了"];
        return;
    }
    self.shopModel.remarks = self.remarksTextView.text;
    [self.shopModel updateHeightWithOrder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.countLabel.text = [NSString stringWithFormat:@"%ld/50",textView.text.length];
    if (textView.text.length > 50) {
        self.countLabel.textColor = [UIColor redColor];
    } else {
        self.countLabel.textColor = UIColorFromRGB(0x6e6d6d);
    }
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
