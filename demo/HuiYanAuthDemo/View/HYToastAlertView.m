//
//  HYToastAlertView.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/21.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HYToastAlertView.h"
#import "Masonry.h"
@interface HYToastAlertView ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *restartBtn;

@property (nonatomic, copy) HandlerButtonClickBlock clickBlock;

@end

@implementation HYToastAlertView

+(instancetype)shareInstance{
    static HYToastAlertView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HYToastAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return instance;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupView];
    }
    return self;
}

+ (void)showAlertViewWithbuttonClickedBlock:(HandlerButtonClickBlock)buttonClickedBlock
{
    HYToastAlertView *alert = [HYToastAlertView shareInstance];
    [alert show];
    alert.clickBlock = buttonClickedBlock;
}
+ (BOOL)isShowing
{
    HYToastAlertView *alert = [HYToastAlertView shareInstance];
    return alert.superview?YES:NO;
}
- (void)setupView{
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.titleLab];
    [self.containerView addSubview:self.contentLab];
    [self.containerView addSubview:self.cancelBtn];
    [self.containerView addSubview:self.restartBtn];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(280, 165));
        make.center.mas_equalTo(self);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_offset(24);
        make.height.mas_offset(25);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(11);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(8);
        make.centerX.mas_offset(0);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(140, 50));
    }];
    [self.restartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(140, 50));
    }];
}
- (void)show{
    if (self.superview) return;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}
- (void)hide {
    
    self.backgroundColor = [UIColor clearColor];
    [self removeFromSuperview];
    
}
- (void)buttonClick:(UIButton *)button{
    NSInteger index = button.tag - 200;
    if (self.clickBlock){
        self.clickBlock(index);
    }
    [self hide];
}
- (UIView *)containerView
{
    if (!_containerView){
        _containerView = [UIView new];
        _containerView.clipsToBounds = YES;
        _containerView.layer.cornerRadius = 4;
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}

- (UILabel *)titleLab
{
    if (!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor colorWithRed:38/255.f green:40/255.f blue:46/255.f alpha:1];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"人脸识别超时";
    }
    return _titleLab;;
}
- (UILabel *)contentLab
{
    if (!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.textColor = [UIColor colorWithRed:97/255.f green:103/255.f blue:117/255.f alpha:1];
        _contentLab.font = [UIFont systemFontOfSize:16];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.text = @"请您正对屏幕、保持脸部光源充足、根据提示完成相应动作";
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"退出" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithRed:38/255.f green:40/255.f blue:46/255.f alpha:1] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelBtn.tag = 200;
        [_cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.clipsToBounds = YES;
        _cancelBtn.layer.borderWidth = 0.5;
        _cancelBtn.layer.borderColor = [UIColor colorWithRed:39/255.f green:40/255.f blue:46/255.f alpha:0.1].CGColor;
    }
    return _cancelBtn;
}
- (UIButton *)restartBtn
{
    if (!_restartBtn){
        _restartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_restartBtn setTitle:@"重新检测" forState:UIControlStateNormal];
        [_restartBtn setTitleColor:[UIColor colorWithRed:244/255.f green:78/255.f blue:88/255.f alpha:1] forState:UIControlStateNormal];
        _restartBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _restartBtn.tag = 201;
        [_restartBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _restartBtn.clipsToBounds = YES;
        _restartBtn.layer.borderWidth = 0.5;
        _restartBtn.layer.borderColor = [UIColor colorWithRed:39/255.f green:40/255.f blue:46/255.f alpha:0.1].CGColor;
    }
    return _restartBtn;
}
@end
