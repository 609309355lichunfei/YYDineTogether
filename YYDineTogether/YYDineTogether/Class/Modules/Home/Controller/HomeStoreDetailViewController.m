//
//  HomeStoreDetailViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeStoreDetailViewController.h"
#import "JSYHShopModel.h"
#import "JSYHActivityModel.h"
#import "JSYHHomeStoreActivityView.h"


@interface HomeStoreDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *shopLogoBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shopLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIView *activitiBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activtiViewHeight;

@end

@implementation HomeStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [MobClick event:@"shop_detail"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registUI];
}

- (void)registUI {
    //  创建需要的毛玻璃特效类型
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    //  毛玻璃view 视图
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    //添加到要有毛玻璃特效的控件中
    
    effectView.frame = [UIScreen mainScreen].bounds;
    
    [self.shopLogoBGImageView addSubview:effectView];
    
    //设置模糊透明度
    
    effectView.alpha = 1;

    [self.shopLogoImageView setImageWithURL:[NSURL URLWithString:_shopModel.logo] placeholder:[UIImage imageNamed:@"default_shop"]];
    [self.shopLogoBGImageView setImageWithURL:[NSURL URLWithString:_shopModel.logo] placeholder:nil];
    self.shopNameLabel.text = _shopModel.name;
    self.startCountLabel.text = _shopModel.star == 0 ? @"" :[NSString stringWithFormat:@"%ld",_shopModel.star];
    self.saleCountLabel.text = _shopModel.salescount == 0 ? @"" : [NSString stringWithFormat:@"%ld",_shopModel.salescount];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",_shopModel.address,_shopModel.addressdet];
    self.noticeInfoLabel.text = _shopModel.notice_info.length > 0 ? _shopModel.notice_info : @" ";
    self.introduceLabel.text = _shopModel.intr_info.length > 0 ? _shopModel.intr_info : @" ";
    self.activtiViewHeight.constant = _shopModel.activites.count * 25;
    for (NSInteger i = 0; i < _shopModel.activites.count; i ++){
        JSYHActivityModel *model = _shopModel.activites[i];
        JSYHHomeStoreActivityView *view = [[[NSBundle mainBundle] loadNibNamed:@"JSYHHomeStoreActivityView" owner:self options:nil] lastObject];
        view.frame = CGRectMake(12, 4 + i * 20,200, 20);
        view.autoresizingMask = UIViewAutoresizingNone;
        [self.activitiBGView addSubview:view];
        [view setActivityModel:model];
        }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addressAction:(id)sender {
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
