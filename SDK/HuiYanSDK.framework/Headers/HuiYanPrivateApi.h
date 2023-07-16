//
//  HuiYanOsApi.h
//  HuiYanSDK
//
//  Created by v_clvchen on 2021/3/15.
//  Copyright © 2021 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HuiYanSDK/HuiYanPrivateConfig.h>
#import <HuiYanSDK/PrivateGetConfigResult.h>
#import <HuiYanSDK/PrivateCompareResult.h>
#import <HuiYanSDK/PrivateLiveDataEntity.h>

NS_ASSUME_NONNULL_BEGIN

#define TXY_HUIYAN_SDK_FRAMEWORK_VERSION @"v1.1.1.18"
//HuiYanPrivateApi @interface
@interface HuiYanPrivateApi : NSObject
/**
 * 初始化成功回调
 *
 * @param getConfigResult 初始化回调数据
 */
typedef void (^HuiYanConfigSuccCallback)(PrivateGetConfigResult * _Nonnull getConfigResult);
/**
 * 初始化失败回调
 *
 * @param errCode 错误码
 * @param errMsg 错误信息
 */
typedef void (^HuiYanConfigFailCallback)(int errCode, NSString * _Nonnull errMsg);

/**
 * 活体核身成功回调
 *
 * @param compareResult 活体比对数据
 * @param videoPath 活体视频路径
 */
typedef void (^HuiYanResultSuccCallback)(PrivateCompareResult * _Nonnull compareResult, NSString * _Nonnull videoPath);
/**
 * 活体核身失败回调
 *
 * @param errCode 错误码
 * @param errMsg 错误信息
 */
typedef void (^HuiYanResultFailCallback)(int errCode, NSString * _Nonnull errMsg);

+ (void)initWithViewController:(UIViewController *)viewController;
/**
 * 初始化获取设备信息
 *
 * @param privateConfig  sdk配置类
 * @param huiYanConfigSuccCallback 配置成功，数据回调
 * @param huiYanConfigFailCallback 配置失败回调
 */
+ (void)startGetAuthConfigData:(HuiYanPrivateConfig *)privateConfig
              withSuccCallback:(HuiYanConfigSuccCallback)huiYanConfigSuccCallback
              withFailCallback:(HuiYanConfigFailCallback)huiYanConfigFailCallback;

/**
 * 开始活体验证
 *
 * @param liveDataEntity  光线数据类
 * @param huiYanResultSuccCallback 验证成功，数据回调
 * @param huiYanResultFailCallback 验证失败回调
 */
+ (void)startAuthByLiveData:(PrivateLiveDataEntity *)liveDataEntity
         withSuccCallback:(HuiYanResultSuccCallback)huiYanResultSuccCallback
         withFailCallback:(HuiYanResultFailCallback)huiYanResultFailCallback;

/**
 * 当获取后端光线序列数据发生错误时(网络或接口错误时)
 *
 * @param errCode  传入错误码
 * @param errMsg 传入失败原因
 */
+ (void)stopAuthActionErr:(int)errCode errMsg:(NSString *_Nonnull) errMsg;

/// 获取SDK版本号
+ (NSString *_Nonnull)sdkVersion;

/// 清理SDK资源
+ (void)release;
@end

NS_ASSUME_NONNULL_END
