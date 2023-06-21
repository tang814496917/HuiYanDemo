//
//  AlgorithmHeaderView.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/14.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "AlgorithmHeaderView.h"
#import "Masonry.h"
@interface AlgorithmHeaderView()

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation AlgorithmHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self setupView];
    }
    return self;
}
- (void)setupView{
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.titleLab];
    [self.containerView addSubview:self.textView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12, 4, 12, 4));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(20);
        make.height.mas_offset(23);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(8);
        make.centerX.offset(0);
        make.left.mas_offset(16);
        make.height.offset(150);
    }];
    
}
- (UIView *)containerView
{
    if (!_containerView){
        _containerView = [UIView new];
        _containerView.backgroundColor = UIColor.whiteColor;
        _containerView.clipsToBounds = YES;
        _containerView.layer.cornerRadius = 4;
    }
    return _containerView;
}
- (UILabel *)titleLab
{
    if (!_titleLab){
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor colorWithRed:38/255.f green:40/255.f blue:46/255.f alpha:1];
        _titleLab.font = [UIFont systemFontOfSize:16];
    }
    return _titleLab;
}
- (UITextView *)textView
{
    if (!_textView){
        _textView = [UITextView new];
        _textView.clipsToBounds = YES;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [UIColor colorWithRed:233/255.f green:233/255.f blue:233/255.f alpha:1].CGColor;
        _textView.layer.cornerRadius = 4;
        _textView.text = @"CWS-SD-liveness-Andriod-M1.7.3.20230114";
        _textView.textColor = [UIColor colorWithRed:38/255.f green:40/255.f blue:46/255.f alpha:1];
        _textView.font = [UIFont systemFontOfSize:14];
    }
    return _textView;
}
@end
