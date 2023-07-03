//
//  HYToastAlertView.h
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/21.
//  Copyright © 2023 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYToastAlertView : UIView
typedef void(^HandlerButtonClickBlock)(NSInteger index);

+ (void)showAlertViewWithbuttonClickedBlock:(nullable HandlerButtonClickBlock)buttonClickedBlock;

+ (BOOL)isShowing;

+ (void)createImg:(UIView *)bgView;

@end

NS_ASSUME_NONNULL_END
