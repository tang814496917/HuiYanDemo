//
//  HuiYanScreenBrightnssApi.h
//  HuiYanSDK
//
//  Created by webertzhang on 2022/11/8.
//  Copyright © 2022 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HuiYanScreenBrightnessApi : NSObject

@property(nonatomic, assign) CGFloat recordBrightness;


+ (nonnull instancetype) sharedInstance;

+ (void)clearInstance;

// 开始调节屏幕亮度
- (void)beginAdjustScreenBrightness;
// 结束调节屏幕亮度
- (void)endAdjustScreenBrightness;
// 暂停调节屏幕亮度
- (void)pauseAdjustScreenBrightness;
// 继续调节屏幕亮度
- (void)resumeAdjustScreenBrightness;

@end

NS_ASSUME_NONNULL_END
