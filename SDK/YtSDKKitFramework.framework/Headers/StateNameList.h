//
//  StateNameList.h
//  yt-ios-face-recognition-demo
//
//  Created by Marx Wang on 2019/9/6.
//  Copyright © 2019 Tencent.Youtu. All rights reserved.
//

#pragma once
#import <Foundation/Foundation.h>
#include <YtSDKKitFramework/YtSDKCommonDefines.h>

/// YtSDKKitFramework支持的状态
typedef enum  : int
{
    /// 未定义状态
    YT_UNKNOWN_STATE = 0,
    /// 空闲状态
    YT_IDLE_STATE = 1,
    /// 检测状态
    YT_SILENT_STATE,
    /// 动作状态
    YT_ACTION_STATE,
    /// 光线状态
    YT_REFLECT_STATE,
    /// 卡片预检自动捕获状态
    YT_OCR_AUTO_STATE,
    /// 卡片预检手动捕获状态
    YT_OCR_MANUAL_STATE,
    /// 网络配置获取状态
    YT_NET_FETCH_STATE,
    /// 非光线活体请求状态
    YT_NET_REQ_RESULT_STATE,
    /// 光线活体相关请求状态
    YT_NET_REQ_REFLECT_RESULT_STATE,
    /// 卡片预检请求状态
    YT_NET_OCR_REQ_RESULT_STATE,
    /// 人脸检测状态
    YT_DETECT_ONLY_STATE,
    YT_OCR_VIDEO_IDENT_STATE,
    YT_NET_OCR_VI_RESULT_STATE,
    /// 人脸质量状态
    YT_FACE_QUALITY_SATE,
    YT_STATE_COUNT,

}StateName;
/// @brief 状态信息获取接口
YT_SDK_EXPORT @interface StateNameHelper : NSObject
/// @brief 获取所有状态名称
/// @return 返回所有状态名称
+ (NSArray *)names;
/// @brief 类型到名称转换接口
/// @param type 传入类型
/// @return 返回类型对应的名称
+ (NSString *)nameForType:(StateName)type;
/// @brief 名称到类型转换接口
/// @param name 类型名称
/// @return 返回名称对应的类型
+ (StateName)typeFromName:(NSString*)name;
@end

