//
//  YtSDKLogger.h
//  yt-ios-verification-sdk
//
//  Created by Marx Wang on 2019/9/25.
//  Copyright © 2019 Tencent.Youtu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YtSDKKitFramework/YtSDKCommonDefines.h>
NS_ASSUME_NONNULL_BEGIN

#define YTLOG_DEBUG(format_string, ...) \
[YtSDKLogger logDebug:[NSString stringWithFormat:format_string,##__VA_ARGS__]]

#define YTLOG_INFO(format_string, ...) \
[YtSDKLogger logInfo:[NSString stringWithFormat:format_string,##__VA_ARGS__]]

#define YTLOG_WARN(format_string, ...) \
[YtSDKLogger logWarnning:[NSString stringWithFormat:format_string,##__VA_ARGS__]]

#define YTLOG_ERROR(format_string, ...) \
[YtSDKLogger logError:[NSString stringWithFormat:format_string,##__VA_ARGS__]]

/// YtSDKLoggerLevel
typedef NS_ENUM(NSInteger, YtSDKLoggerLevel)
{
    /// ERROR 级别
    YT_SDK_ERROR_LEVEL = 0,
    /// WARN 级别
    YT_SDK_WARN_LEVEL,
    /// INFO 级别
    YT_SDK_INFO_LEVEL,
    /// DEBUG 级别
    YT_SDK_DEBUG_LEVEL
};
/// @brief 日志监听回调Block
/// @param loggerLevel 返回当前日志等级
/// @param logInfo 返回当前日志信息
typedef void (^OnLoggerEventBlock)(YtSDKLoggerLevel loggerLevel, NSString * _Nonnull logInfo);
YT_SDK_EXPORT @interface YtSDKLogger : NSObject
/// @brief 注册日志监听器接口
/// @param listener 日志回调
/// @param needNative 是否获取底层sdk日志
+ (void)registerLoggerListener:(OnLoggerEventBlock _Nullable)listener withNativeLog:(BOOL)needNative;
/// @brief 底层日志状态查询接口
/// @return 返回底层日志是否打开
+ (BOOL)needNativeLog;
/// @brief DEBUG级别日志打印
/// @param message 日志信息
+ (void)logDebug:(NSString* _Nonnull)message;
/// @brief INFO级别日志打印
/// @param message 日志信息
+ (void)logInfo:(NSString* _Nonnull)message;
/// @brief WARNING级别日志打印
/// @param message 日志信息
+ (void)logWarnning:(NSString* _Nonnull)message;
/// @brief ERROR级别日志打印
/// @param message 日志信息
+ (void)logError:(NSString* _Nonnull)message;

@end

NS_ASSUME_NONNULL_END
