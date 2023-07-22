//
//  HYCommonToast.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/21.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HYCommonToast.h"
#import "HYMBProgressHUD.h"
@implementation HYCommonToast

+ (void)showHudWithText:(NSString *)text
{
    if (!text.length) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        [HYMBProgressHUD hideHUDForView:window animated:NO];
        HYMBProgressHUD *hud = [HYMBProgressHUD showHUDAddedTo:window animated:YES];
        
        hud.bezelView.style = HYMBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        hud.mode = HYMBProgressHUDModeText;
        hud.label.text = text?:@"";
        hud.label.font = [UIFont systemFontOfSize:14];
        hud.label.textColor = [UIColor whiteColor];
        hud.label.numberOfLines = 0;
        hud.bezelView.layer.cornerRadius = 4.f;
        hud.bezelView.layer.masksToBounds = YES;
        hud.margin = 12;
        hud.userInteractionEnabled = NO;
        [hud hideAnimated:YES afterDelay:1.5f];
    });
  
    
}
@end
