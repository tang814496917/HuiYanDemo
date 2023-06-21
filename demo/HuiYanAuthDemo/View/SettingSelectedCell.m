//
//  SettingSelectedCell.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/14.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "SettingSelectedCell.h"
#import "Masonry.h"

@implementation HYSettingButton

- (void)setType:(HYButtonType)type
{
    _type = type;
    if(type == HYButtonTypeNormal){
        self.tintColor = [UIColor colorWithRed:154/255.f green:156/255.f blue:160/255.f alpha:1];
    }else if (type == HYButtonTypeSelected){
        self.tintColor = [UIColor colorWithRed:206/255.f green:51/255.f blue:65/255.f alpha:1];
    }else if (type == HYButtonTypeEnable){
        self.tintColor = [UIColor colorWithRed:206/255.f green:51/255.f blue:65/255.f alpha:0.5];
    }else{
        self.tintColor = [UIColor colorWithRed:154/255.f green:156/255.f blue:160/255.f alpha:1];
    }
}

@end
@interface SettingSelectedCell()

@end

@implementation SettingSelectedCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupView];
    }
    return self;
}
- (void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.switchBtn];
    [self.contentView addSubview:self.selectedBtn];
    [self.contentView addSubview:self.contentlab];
    [self.contentView addSubview:self.bottomLineView];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.left.mas_offset(20);
        make.height.mas_offset(23);
    }];
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.right.mas_offset(-20);
    }];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19, 19));
        make.right.offset(-20);
        make.centerY.mas_offset(0);
    }];
    [self.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.right.mas_offset(-20);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.bottom.mas_offset(-0.5);
        make.height.mas_offset(0.5);
    }];
}

- (void)switchChanged:(UISwitch *)sw{
    if (self.switchChangedCalledBack){
        self.switchChangedCalledBack(sw.on);
    }
    
}
- (void)selectedBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (self.selectedCalledBack){
        self.selectedCalledBack(button.selected);
    }
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
- (HYSettingButton *)selectedBtn
{
    if (!_selectedBtn){
        _selectedBtn = [HYSettingButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateNormal];
        [_selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedBtn;
}
- (UILabel *)contentlab
{
    if(!_contentlab){
        _contentlab = [UILabel new];
        _titleLab.textColor = [UIColor colorWithRed:38/255.f green:40/255.f blue:46/255.f alpha:1];
        _titleLab.font = [UIFont systemFontOfSize:16];
    }
    return _contentlab;
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
