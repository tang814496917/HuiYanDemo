//
//  SettingHeaderView.h
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/14.
//  Copyright © 2023 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SettingHeaderViewType) {
    SettingHeaderViewTypeNone,
    SettingHeaderViewTypeSwitch,
    SettingHeaderViewTypeIncreaseAndReduce,
    SettingHeaderViewTypeText,
    SettingHeaderViewTypeSwitchAndText,
    SettingHeaderViewTypeCircleSelected,
    SettingHeaderViewTypeCircleSelectedIncreaseAndReduce,
};
@interface SettingHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UISwitch *switchBtn;

@property (nonatomic, strong) UITextField *contentlab;

@property (nonatomic, strong) UIButton *increaseBtn;

@property (nonatomic, strong) UIButton *reduceBtn;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UIButton *circleBtn;

@property (nonatomic, assign) SettingHeaderViewType type;

@property (nonatomic, copy) void(^switchChangedCalledBack)(BOOL isOn);

@property (nonatomic, copy) void(^increaseBtnCalledBack)(void);

@property (nonatomic, copy) void(^reduceBtnCalledBack)(void);

@property (nonatomic, copy) void(^circleSelectedCalledBack)(BOOL isSelected);


@end


NS_ASSUME_NONNULL_END
