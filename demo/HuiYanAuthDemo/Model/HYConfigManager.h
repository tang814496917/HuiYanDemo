//
//  HYConfigManager.h
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/19.
//  Copyright © 2023 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HuiYanSDK/HuiYanPrivateConfig.h>
NS_ASSUME_NONNULL_BEGIN

@interface HYConfigManager : NSObject

@property (nonatomic, assign) NSInteger restartCount;

@property (nonatomic, assign) BOOL isNeverTimeOut;

@property (nonatomic, assign) NSInteger prepareTimeOut;

@property (nonatomic, assign) NSInteger actref_ux_mode;

@property (nonatomic, assign) NSInteger actionTimeoutMs;

@property (nonatomic, assign) BOOL need_action_video;

@property (nonatomic, strong) NSArray * action_data;

@property (nonatomic, assign) BOOL action_random;

@property (nonatomic, assign) BOOL reflect_images_shorten_strategy;

@property (nonatomic, assign) BOOL action_video_shorten_strategy;

@property (nonatomic, assign) BOOL isNotMute;

@property (nonatomic, assign) BOOL successPage;

@property (nonatomic, strong) NSString * successPageStr;

@property (nonatomic, assign) BOOL failurePage;

@property (nonatomic, strong) NSString * failurePageStr;

@property (nonatomic, assign) BOOL isUseBestFaceImage;

@property (nonatomic, strong) NSString * hostUrl;

@property (nonatomic, strong) HuiYanPrivateConfig *privateConfig;

+(instancetype)shareInstance;

- (NSString *)liveConfig;

- (NSString *)tipsWithEvent:(HYAuthTipsEvent )event;

@end

NS_ASSUME_NONNULL_END
