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
@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic)  UITableView *tableview;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"个人信息";
     [self.view addSubview:self.tableview];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem
                                             itemWithImageName:@"Navigation_left" highImageName:@"Navigation_left" target:self action:(@selector(back))];
 
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableview {
    
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMakeAdapt(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource= self;
        
    }
    return _tableview;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
           cell.detailTextLabel.text = @"头像";
            cell.textLabel.font = [UIFont AmericanTypewriterBoldFontSize:12.];
            cell.imageView.image = [UIImage imageNamed:@"icon"];
            break;
        case 1:
            cell.textLabel.text = @"昵称";
             cell.textLabel.font = [UIFont AmericanTypewriterBoldFontSize:12.];
            
            break;
        case 2:
            cell.textLabel.text = @"性别";
             cell.textLabel.font = [UIFont AmericanTypewriterBoldFontSize:12.];
            break;
        default:
            break;
    }
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.row) {
        case 0:
          [self setAJImageheadData];
            break;
        case 2:
         [self setActionSheetStringPicker];
            break;
        default:
            break;
    }
    
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
