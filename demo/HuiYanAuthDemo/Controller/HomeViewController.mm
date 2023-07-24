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
            [HYAuthApi startAuth:[HYConfigModel new] withSuccCallback:^(NSDictionary * _Nonnull reportData) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reportData
                                                                   options:0
                                                                     error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                             encoding:NSUTF8StringEncoding];
                NSLog(@"report:%@",jsonString);
                //成功页面
                [self.navigationController pushViewController:[HYResultVC new] animated:YES];

            } withFailCallback:^(int errCode, NSString * _Nonnull errMsg) {
                //失败页面
                [self.navigationController pushViewController:[HYResultVC new] animated:YES];
            }];
            break;
        case 101:
            [self.navigationController pushViewController:[ParamSettingViewController new] animated:YES];
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
