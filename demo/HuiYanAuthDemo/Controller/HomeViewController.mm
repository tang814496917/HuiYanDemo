//
//  HomeViewController.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/13.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HomeViewController.h"
#import "ParamSettingViewController.h"
#import "Masonry.h"
#import "HYResultVC.h"
#import <HYSDK/HYAuthApi.h>
#import "HYConfigManager.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface HomeViewController ()


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupView
{
    self.title = @"首页";
    self.view.backgroundColor = UIColor.whiteColor;
    NSArray *titleArray = @[@"活体检测",@"参数设置",@"1:1人脸",@"1:N检索"];
    for (int i = 0; i<4; i++) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(16+((SCREEN_WIDTH-44)/2.f+12)*(i%2), 64+90*(i/2), (SCREEN_WIDTH-44)/2.f, 78);
        view.layer.shadowColor = [UIColor colorWithRed:7/255.f green:40/255.f blue:85/255.f alpha:0.06].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,6);
        view.layer.shadowOpacity = 0.6;
        view.clipsToBounds = NO;
        view.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:view];
        view.tag = 100+i;
        [view addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"编组%d",i+1]]];
        imageView.frame = CGRectMake(view.bounds.size.width/2-55, 19, 40, 40);
        imageView.userInteractionEnabled = YES;
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(view.bounds.size.width/2, 28, view.bounds.size.width/2, 22)];
        label.textColor = [UIColor colorWithRed:29/255.0 green:31/255.0 blue:36/255.0 alpha:1/1.0];
        label.font = [UIFont fontWithName:@"PingFangSC" size:16];
        label.text = titleArray[i];
        [view addSubview:label];
    }
    
    UIImageView *bottomLogo = [[UIImageView alloc]init];
    bottomLogo.image = [UIImage imageNamed:@"home_logo"];
    [self.view addSubview:bottomLogo];
    
    [bottomLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 35));
        make.bottom.offset(-65);
    }];
        
    UILabel *bottomTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 17)];
    bottomTitleLab.text = @"腾讯优图，你身边的视觉AI专家";
    bottomTitleLab.textColor = [UIColor colorWithRed:93/255.f green:103/255.f blue:117/255.f alpha:1];
    bottomTitleLab.font = [UIFont systemFontOfSize:16];
    bottomTitleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomTitleLab];
    [bottomTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.height.offset(17);
        make.bottom.offset(-40);
    }];
}

- (void)push:(UIButton *)button{
    switch (button.tag) {
        case 100:
        {
            
            //            //重试次数  默认5次
            //            @property (nonatomic, assign) NSInteger restartCount;
            //
            //            //准备阶段 永不超时   默认NO
            //            @property (nonatomic, assign) BOOL isNeverTimeOut;
            //
            //            //准备阶段 超时时间  毫秒   默认 15000
            //            @property (nonatomic, assign) NSInteger prepareTimeOut;
            //
            //            //控制一闪交互流程; 0-动作+反光；1-反光；2-动作.
            //            @property (nonatomic, assign) NSInteger actref_ux_mode;
            //
            //            // 动作阶段 超时时间  毫秒   默认 15000
            //            @property (nonatomic, assign) NSInteger actionTimeoutMs;
            //
            //            // 是否使用默认动作    默认YES
            //            @property (nonatomic, assign) BOOL isDefaultAction;
            //
            //            //  指定需要下发的动作; 1 blink，2 mouth，3 node，4 shake，5 silence; 若需要连续多个动作则使用逗号隔开.
            //            //默认 @[@1,@2,@3,@4];
            //            @property (nonatomic, strong) NSArray * action_data;
            //
            //            //是否使用随机动作 默认NO
            //            @property (nonatomic, assign) BOOL action_random;
            //
            //            //是否静音 默认NO
            //            @property (nonatomic, assign) BOOL mute;
            //
            //            //是否最佳人脸压缩  默认YES
            //            @property (nonatomic, assign) BOOL isUseBestFaceImage;
            //
            //            // 接口地址
            //            @property (nonatomic, strong) NSString * hostUrl;
            //
            //            // License文件路径
            //            @property (strong, nonatomic) NSString *authLicense;
            //
            //            // 图灵顿授权文件路径
            //            @property (nonatomic, strong) NSString *riskLicense;
            
            HYConfigModel *model = [HYConfigModel new];
            model.actref_ux_mode = [HYConfigManager shareInstance].actref_ux_mode;
            model.action_data = [HYConfigManager shareInstance].action_data;
            model.action_random = [HYConfigManager shareInstance].action_random;
            model.mute = ![HYConfigManager shareInstance].isNotMute;
            model.isUseBestFaceImage = [HYConfigManager shareInstance].isUseBestFaceImage;
            model.actionTimeoutMs = [HYConfigManager shareInstance].actionTimeoutMs;
            model.prepareTimeOut = [HYConfigManager shareInstance].prepareTimeOut;
            model.restartCount = [HYConfigManager shareInstance].restartCount;
            model.isNeverTimeOut = [HYConfigManager shareInstance].isNeverTimeOut;
            model.hostUrl = @"https://biology-port.yz-intelligence.com:9978/";
            model.isDefaultAction = [HYConfigManager shareInstance].isDefaultAction;
            model.authLicense = [[NSBundle mainBundle] pathForResource:@"licsence.lic" ofType:@""];
            model.riskLicense = [[NSBundle mainBundle] pathForResource:@"sdcs_test_androids.lic" ofType:@""];
            [HYAuthApi startAuth:model withSuccCallback:^(NSDictionary * _Nonnull reportData) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reportData
                                                                   options:0
                                                                     error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                             encoding:NSUTF8StringEncoding];
                NSLog(@"report:%@",jsonString);
                //成功页面
                HYResultVC *vc = [HYResultVC new];
                vc.isSuccess = YES;
                [self.navigationController pushViewController:vc animated:YES];

            } withFailCallback:^(int errCode, NSString * _Nonnull errMsg) {
                //失败页面
                HYResultVC *vc = [HYResultVC new];
                vc.isSuccess = NO;
                [self.navigationController pushViewController:vc animated:YES];            }];
        }
            break;
        case 101:
        {
            [self.navigationController pushViewController:[ParamSettingViewController new] animated:YES];
        }
            break;
        case 102:
    
            break;
        case 103:
            
            break;
            
        default:
            break;
    }
}

@end
