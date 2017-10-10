//
//  JSYHAboutUsViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 2017/10/10.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHAboutUsViewController.h"

@interface JSYHAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutusLabel;

@end

@implementation JSYHAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.aboutusLabel.text = @"\t“聚膳宅配”是一款提供“跨店下单，统一配送”的新型O2O餐饮平台（计划2017年7月上线），由宁波聚善网络科技有限公司开发运营。公司创立于2017年4月，起源于宁波国家高新区核心区域研发园。\n\t公司充分体现宁波全市自主创新的总体要求，积极响应研发园“研发、创新、集聚、转化、辐射、示范”的六大功能点，以宁波国家高新区和东部新城为试点，集聚线下商家，整合即时配送运力，丰富客户用餐体验，并积极研发配送算法，拓展配送辐射圈，致力于为商务区白领用户群体提供餐饮痛点的解决方案。\n\tAdd：宁波市高新区研发园A区5幢宁波科技大市场12B-02\n\tTel： 0574-87566681";
}

- (IBAction)backAction:(id)sender {
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
