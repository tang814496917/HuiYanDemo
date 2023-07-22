//
//  SettingHeaderView.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/14.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "SettingHeaderView.h"
#import "Masonry.h"

@interface SettingHeaderView()<UITextFieldDelegate>

@end

@implementation SettingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self;
}
- (void)setupView{
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.switchBtn];
    [self.contentView addSubview:self.contentlab];
    [self.contentView addSubview:self.increaseBtn];
    [self.contentView addSubview:self.reduceBtn];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.circleBtn];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(14);
        make.left.mas_offset(20);
        make.height.mas_offset(22);
    }];
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(14);
        make.right.mas_offset(-20);
    }];
    [self.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.right.mas_offset(-20);
    }];
    [self.increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_offset(0);
        make.right.mas_offset(-24);
    }];
    [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_offset(0);
        make.right.mas_equalTo(self.increaseBtn.mas_left).offset(-43);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.bottom.mas_offset(-0.5);
        make.height.mas_offset(0.5);
    }];
    [self.circleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.left.mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}
- (void)setType:(SettingHeaderViewType)type
{
    self.titleLab.textColor = [UIColor colorWithRed:38/255.f green:40/255.f blue:46/255.f alpha:1];
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
    }];
    self.circleBtn.hidden = YES;
    self.contentlab.textAlignment = NSTextAlignmentRight;
    self.contentlab.userInteractionEnabled = NO;
    self.contentlab.placeholder = @"";
    switch (type) {
        case SettingHeaderViewTypeNone:
            {
                self.contentlab.hidden = YES;
                self.switchBtn.hidden = YES;
                self.increaseBtn.hidden = YES;
                self.reduceBtn.hidden = YES;
            }
            break;
        case SettingHeaderViewTypeSwitch:
            {
                self.contentlab.hidden = YES;
                self.switchBtn.hidden = NO;
                self.increaseBtn.hidden = YES;
                self.reduceBtn.hidden = YES;
            }
            break;
        case SettingHeaderViewTypeIncreaseAndReduce:
            {
                self.contentlab.hidden = NO;
                self.switchBtn.hidden = YES;
                self.increaseBtn.hidden = NO;
                self.reduceBtn.hidden = NO;
                self.titleLab.textColor = [UIColor colorWithRed:90/255.f green:113/255.f blue:107/255.f alpha:1];
                self.contentlab.textAlignment = NSTextAlignmentCenter;
                [self.contentlab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_offset(0);
                    make.right.mas_equalTo(self.increaseBtn.mas_left).offset(0);
                    make.left.mas_equalTo(self.reduceBtn.mas_right).offset(0);
                }];
            }
            break;
        case SettingHeaderViewTypeText:
            {
                self.contentlab.hidden = NO;
                self.switchBtn.hidden = YES;
                self.increaseBtn.hidden = YES;
                self.reduceBtn.hidden = YES;
                [self.contentlab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_offset(0);
                    make.right.mas_offset(-20);
                }];
            }
            break;
        case SettingHeaderViewTypeSwitchAndText:
            {
                self.contentlab.userInteractionEnabled = YES;
                self.contentlab.hidden = NO;
                self.switchBtn.hidden = NO;
                self.increaseBtn.hidden = YES;
                self.reduceBtn.hidden = YES;
                self.contentlab.placeholder = @"输入网址";
                [self.contentlab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.switchBtn.mas_bottom).offset(12);
                    make.right.mas_offset(-20);
                    make.left.mas_offset(20);
                }];
            }
            break;
        case SettingHeaderViewTypeCircleSelected:
            {
                self.contentlab.hidden = YES;
                self.switchBtn.hidden = YES;
                self.increaseBtn.hidden = YES;
                self.reduceBtn.hidden = YES;
                self.circleBtn.hidden = NO;
                self.titleLab.textColor = [UIColor colorWithRed:90/255.f green:113/255.f blue:107/255.f alpha:1];
                [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_offset(50);
                }];
            }
            break;
        case SettingHeaderViewTypeCircleSelectedIncreaseAndReduce:
            {
                self.contentlab.hidden = NO;
                self.switchBtn.hidden = YES;
                self.increaseBtn.hidden = NO;
                self.reduceBtn.hidden = NO;
                self.circleBtn.hidden = NO;
                self.titleLab.textColor = [UIColor colorWithRed:90/255.f green:113/255.f blue:107/255.f alpha:1];
                [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_offset(50);
                }];
                self.contentlab.textAlignment = NSTextAlignmentCenter;
                [self.contentlab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_offset(0);
                    make.right.mas_equalTo(self.increaseBtn.mas_left).offset(0);
                    make.left.mas_equalTo(self.reduceBtn.mas_right).offset(0);
                }];
            }
            break;
            
        default:
            break;
    }
}
- (void)switchChanged:(UISwitch *)sw{
    
    if (self.switchChangedCalledBack){
        self.switchChangedCalledBack(sw.on);
    }
}
- (void)increaseBtn:(UIButton *)button{
    if (self.increaseBtnCalledBack){
        self.increaseBtnCalledBack();
    }
}
- (void)reduceBtn:(UIButton *)button{
    if(self.reduceBtnCalledBack){
        self.reduceBtnCalledBack();
    }
}
- (void)circleSelected:(UIButton *)button{
    if (self.circleSelectedCalledBack){
        self.circleSelectedCalledBack(button.selected);
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
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

- (UISwitch *)switchBtn
{
    if (!_switchBtn){
        _switchBtn = [[UISwitch alloc]init];
        _switchBtn.onTintColor = [UIColor colorWithRed:207/255.f green:50/255.f blue:57/255.f alpha:1];
        _switchBtn.transform = CGAffineTransformMakeScale(0.67, 0.64);
        [_switchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

- (UITextField *)contentlab
{
    if(!_contentlab){
        _contentlab = [UITextField new];
        _contentlab.textColor = [UIColor colorWithRed:38/255.f green:40/255.f blue:46/255.f alpha:1];
        _contentlab.font = [UIFont systemFontOfSize:16];
        _contentlab.textAlignment = NSTextAlignmentCenter;
        _contentlab.delegate = self;
    }
    return _contentlab;
}
- (UIButton *)increaseBtn{
    if (!_increaseBtn){
        _increaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_increaseBtn setImage:[UIImage imageNamed:@"increase"]  forState:UIControlStateNormal];
        [_increaseBtn addTarget:self action:@selector(increaseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _increaseBtn;
}
- (UIButton *)reduceBtn
{
    if(!_reduceBtn){
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceBtn setImage:[UIImage imageNamed:@"reduce"]  forState:UIControlStateNormal];
        [_reduceBtn addTarget:self action:@selector(reduceBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBtn;
}

- (UIButton *)circleBtn
{
    if(!_circleBtn){
        _circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_circleBtn setImage:[UIImage imageNamed:@"circle_unselected"]  forState:UIControlStateNormal];
        [_circleBtn setImage:[UIImage imageNamed:@"circle_selected"]  forState:UIControlStateSelected];
        [_circleBtn addTarget:self action:@selector(circleSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _circleBtn;
}

- (UIView *)bottomLineView
{
    if(!_bottomLineView){
        _bottomLineView = [UIView new];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:233/255.f green:233/255.f blue:233/255.f alpha:1];
    }
    return _bottomLineView;
}
@end
