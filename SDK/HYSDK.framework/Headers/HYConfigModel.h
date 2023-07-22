//
//  HYConfigModel.h
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/7/12.
//  Copyright © 2023 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYConfigModel : NSObject

//重试次数  默认5次
@property (nonatomic, assign) NSInteger restartCount;

//准备阶段 永不超时   默认NO
@property (nonatomic, assign) BOOL isNeverTimeOut;

//准备阶段 超时时间  毫秒   默认 15000
@property (nonatomic, assign) NSInteger prepareTimeOut;

//控制一闪交互流程; 0-动作+反光；1-反光；2-动作.
@property (nonatomic, assign) NSInteger actref_ux_mode;

// 动作阶段 超时时间  毫秒   默认 15000
@property (nonatomic, assign) NSInteger actionTimeoutMs;

// 是否使用默认动作    默认YES
@property (nonatomic, assign) BOOL isDefaultAction;

//  指定需要下发的动作; 1 blink，2 mouth，3 node，4 shake，5 silence; 若需要连续多个动作则使用逗号隔开.
//默认 @[@1,@2,@3,@4];
@property (nonatomic, strong) NSArray * action_data;

//是否使用随机动作 默认NO
@property (nonatomic, assign) BOOL action_random;

//是否静音 默认NO
@property (nonatomic, assign) BOOL mute;

//是否最佳人脸压缩  默认YES
@property (nonatomic, assign) BOOL isUseBestFaceImage;

// 接口地址
@property (nonatomic, strong) NSString * hostUrl;

// License文件路径
@property (strong, nonatomic) NSString *authLicense;

// 图灵顿授权文件路径
@property (nonatomic, strong) NSString *riskLicense;

@end

NS_ASSUME_NONNULL_END
