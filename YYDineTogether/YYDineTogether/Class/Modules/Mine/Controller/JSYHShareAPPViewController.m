//
//  JSYHShareAPPViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 2017/11/22.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHShareAPPViewController.h"
#import <WXApi.h>
#import "JSYHShareAppView.h"

@interface JSYHShareAPPViewController (){
    enum WXScene _scene;
}
@property (strong, nonatomic) NSString *mytitle;
@property (strong, nonatomic) NSString *mydescription;
@property (strong, nonatomic) NSString *myUrl;


@end

@implementation JSYHShareAPPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(id)sender {
    [MBProgressHUD showMessage:@"..."];
    [[JSRequestManager sharedManager] shareSuccess:^(id responseObject) {
        NSDictionary *dataDic = responseObject[@"data"];
        self.mytitle = dataDic[@"title"];
        self.mydescription = dataDic[@"desc"];
        self.myUrl = dataDic[@"url"];
        JSYHShareAppView *shareView = [[JSYHShareAppView alloc] initWithFrame:kScreen_Bounds];
        shareView.friendsBlock = ^{
            _scene = WXSceneTimeline;
            [self sendLinkContent];
        };
        shareView.wxBlock = ^{
            _scene = WXSceneSession;
            [self sendLinkContent];
        };
        [kAppWindow addSubview:shareView];
    } Failed:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void) sendLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.mytitle;
    message.description = self.mydescription;
    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = self.myUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"专访张小龙：产品之上的世界观";
    message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init] ;
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
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
