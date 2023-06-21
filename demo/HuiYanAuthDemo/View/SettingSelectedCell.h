//
//  SettingSelectedCell.h
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/14.
//  Copyright © 2023 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HYButtonType) {
    HYButtonTypeNormal,
    HYButtonTypeSelected,
    HYButtonTypeEnable,
};
@interface HYSettingButton : UIButton

@property (nonatomic, assign) HYButtonType type;

@end

@interface SettingSelectedCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UISwitch *switchBtn;

@property (nonatomic, strong) HYSettingButton *selectedBtn;

@property (nonatomic, strong) UILabel *contentlab;

@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, copy) void(^switchChangedCalledBack)(BOOL isOn);

@property (nonatomic, copy) void(^selectedCalledBack)(BOOL isSelected);

@end

NS_ASSUME_NONNULL_END
