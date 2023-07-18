//
//  HYResultVC.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/21.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HYResultVC.h"
#import "Masonry.h"
#import "HYConfigManager.h"
#import <WebKit/WebKit.h>
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
@interface HYResultVC ()


@end

@implementation HYResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人脸识别";
    self.view.backgroundColor = UIColor.whiteColor;
    
        if(!self.isSuccess){
            if ([HYConfigManager shareInstance].failurePage){
                [self createWebView:[HYConfigManager shareInstance].failurePageStr];
            }else{
                self.actionArray = @[@"遮挡人脸",@"手机晃动",@"光照不匀"];
                [self setupView];
            }
        }else{
            if ([HYConfigManager shareInstance].successPage){
                [self createWebView:[HYConfigManager shareInstance].successPageStr];
            }else{
                [self setupView];
            }
        }

    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"hyclose.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}
- (void)backItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createWebView:(NSString *)url{
       WKWebView * webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
       NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
       [self.view addSubview: webView];
       [webView loadRequest:request];
}
- (void)setupView{
    UILabel *titleLab = [UILabel new];
    titleLab.font = [UIFont boldSystemFontOfSize:24];
    titleLab.textColor = [UIColor colorWithRed:38/255.f green:40/255.f blue:46/255.f alpha:1];
    titleLab.text = self.isSuccess?@"检测成功":@"检测失败";
    [self.view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(83);
    }];
    
    UILabel *contentLab = [UILabel new];
    contentLab.font = [UIFont systemFontOfSize:14];
    contentLab.textColor = [UIColor colorWithRed:90/255.f green:103/255.f blue:117/255.f alpha:1];
    contentLab.text = self.isSuccess?@"您已检测成功，结果如下":@"请确保本人操作，并尝试避免以下问题";
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.numberOfLines = 0;
    [self.view addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(15);
        make.left.offset(50);
    }];
    NSInteger count = self.isSuccess?self.actionArray.count:3;
    if (count == 0){
        count = 1;
        self.actionArray = @[@"正脸"];
    }
    CGFloat leftSpaceing = (SCREEN_WIDTH - count*54 -(count-1)*40)/2;
    for (int i = 0; i<count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(leftSpaceing+i*(54+40), 204, 54, 54);
        imageView.image = [UIImage imageNamed:self.actionArray[i]];
        [self.view addSubview:imageView];
        
        UILabel *nameLab = [UILabel new];
        nameLab.font = [UIFont systemFontOfSize:13];
        nameLab.text = self.actionArray[i];
        nameLab.textColor = [UIColor colorWithRed:38/255.f green:40/255.f blue:46/255.f alpha:1];
        [self.view addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView);
            make.top.mas_equalTo(imageView.mas_bottom).offset(15);
        }];
        
    }
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithRed:247/255.f green:247/255.f blue:247/255.f alpha:1];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-113);
        make.left.right.mas_offset(0);
        make.height.mas_offset(0.8);
    }];
    
    UIButton *reStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reStartBtn setTitle:self.isSuccess?@"返回首页":@"重新检测" forState:UIControlStateNormal];
    reStartBtn.clipsToBounds = YES;
    reStartBtn.layer.cornerRadius = 4;
    [reStartBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    reStartBtn.backgroundColor = [UIColor colorWithRed:91/255.f green:123/255.f blue:233/255.f alpha:1];
    reStartBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [reStartBtn addTarget:self action:@selector(reStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reStartBtn];
    [reStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.bottom.offset(-45);
        make.centerX.offset(0);
        make.height.offset(48);
    }];
}
- (void)reStart{
    [self.navigationController popViewControllerAnimated:YES];
    if(!self.isSuccess){
        if (self.reStartCalledBack){
            self.reStartCalledBack();
        }
    }
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
