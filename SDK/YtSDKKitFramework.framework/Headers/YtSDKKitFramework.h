//
//  YtSDKKitFramework.h
//  yt-ios-verification-sdk
//
//  Created by Marx Wang on 2019/9/5.
//  Copyright © 2019 Tencent.Youtu. All rights reserved.
//
#pragma once
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <YtSDKKitFramework/YtSDKCommonDefines.h>
#import <YtSDKKitFramework/YtSDKKitConfig.h>
#import <YtSDKKitFramework/StateNameList.h>
/// 反光模块依赖的硬件信息回调接口，需要返回当前摄像机设备信息
@protocol YtDeviceDelegate <NSObject>
/// 获取当前摄像机设备信息，反光相关活体必须实现
- (AVCaptureDevice * _Nullable)getCaptureDevice;
/// 获取当前设备session信息，反光相关活体必须实现
- (AVCaptureSession * _Nullable)getCaptureSession;
/// 设置反光屏幕变色消息通知，反光相关活体必须实现
/// @param argb 色彩变化
/// @param light 光线变化
- (void)onReflectEventWithArgb:(uint)argb withLight:(CGFloat)light;
/// 设置反光时长
/// @param durationMS 反光时长，单位MS
@optional
- (void)onReflectStart:(long)durationMS;
/// @brief 获取音频数据，选填（不实现则读取document路径下的tmpaudio.spx）
/// @return 返回音频数据
@optional
- (NSData * _Nullable)getVoiceData;
/// @brief 获取base64编码, 选填（不实现则默认走系统base64）
/// @param 原始数据
/// @return 返回base64编码后的数据
@optional
- (NSString * _Nullable)encodeBase64:(NSData * _Nonnull)rawData;
/// @brief 获取当前帧检测判断结果
/// @param faceStatus 帧检测结果，人脸结果具体数据接口请查看<SilentLivenessState/SilentLivenessState.h>中的YtFaceStatus
/// @return 返回人脸的检测结果，int值请根据<SilentLivenessState/SilentLivenessState.h>中YtFacePreviewingAdvis以及YtShelterJudge
/**
 | 返回结果 | 说明  |
 | ----: | :---- |
 | nil   | 走默认内部检测 |
 | 同时有“Advise=xxx，Shelter=xxx”检测和遮挡结果 |根据返回值判断后续流程 |
 | 只有“Advise=xxx”检测结果 | 检测使用返回结果，遮挡使用内部结果 |
 | 只有“Shelter=xxx”遮挡结果 | 遮挡使用返回结果，检测使用内部结果 |
**/
@optional
- (NSDictionary * _Nullable)getFrameDetectResult:(void * _Nullable)faceStatus;
/// @brief 检测动作完成回调
/// @param 动作id
@optional
- (void)detectActionDone:(int)actionId;
@end

/// SDKKit触发类型
typedef enum:NSUInteger {
    /// 触发活体开启事件
    YTTriggerBeginLiveness = 0,
    /// 触发活体结束事件
    YTTriggerCancelLiveness
}YtFrameworkFireEventType;
/// DataType类型
typedef enum:NSUInteger {
    /// CMSampleBufferRef 视频帧数据
    YTVideoType = 0,
    /// CGImageRef Image数据
    YTImageType,
}YtFrameworkDataType;
/// SDKKit底层基础框架类
/// 提供各个模块的状态管理，以及整个SDKKit的生命周期管理
YT_SDK_EXPORT @interface YtSDKKitFramework : NSObject
{
}

/// 配置待比对的Image图片
@property (nonatomic, strong) UIImage * _Nullable compareImage;
/// 配置待比对的Image图片类型（0普通，1网纹，默认0）
@property (nonatomic, assign) int compareImageType;
/// 反光颜色变化UI界面(需要设置才会生效）
@property (nonatomic, strong) UIView * _Nullable shapeView;
/// 设置预览视频大小区域
@property (nonatomic, assign) CGRect previewRect;
/// 设置检测人脸区域
@property (nonatomic, assign) CGRect detectRect;
/// 设置模型根目录，如果不设置自动读取app根路径下模型
@property (nonatomic, strong) NSString * _Nullable modelRootPath;
/// 设置网络请求超时，默认60000ms
@property (nonatomic, assign) int networkTimeoutMs;
/// SDKKIt框架单例获取接口
+ (instancetype _Nonnull)sharedInstance;
/// SDKKit框架单例释放接口
+ (void)clearInstance;
/// SDKKit框架版本获取接口
/// @return 当前版本信息
- (NSString *_Nonnull)getVersion;

/// SDKKit 框架初始化函数 一般对于一种场景都需要调用此函数做为开始
/// @param jsonData SDK配置参数，具体格式参考YtSDKSettings.json
/// @param workMode 场景需要工作的模式
/// @param stateNameArray 该场景所依赖的状态机列表（一般可以通过YtSDKKItConfig getStateNameArrayBy来获取已有的状态机列表
/// @param camera 如果使用反光模块，请传入带有YtDeviceDelegate协议的j对象，否则可以传传入nil
/// @param onEventHandleBlock SDKKit框架跑出来的事件（UI事件，状态事件等），用来处理UI变化以及识别事件
/// @param onRequestBlock SDKKit需要请求网络的调用接口（这里实现网络通信），如果传入为nil，则内部会调用网络请求接口
/// @return 返回错误信息
/**
 | 错误码 | 说明  |
 | ----: | :---- |
 | 0   | 成功 |
 | -1 | stateNameArray 大小不能为0  |
 | -2 | EventBlock 不能为nil |
 | -3 | camera对象不能为nil |
 | -4 | 无法正常调用优图提供的afnetwork库符号 |
**/
- (int)initWithSDKSetting: (NSDictionary * _Nonnull)jsonData
     withPipelineWorkMode:(YtSDKKitMode)workMode
withPipelineStateNameArray:(NSArray * _Nonnull)stateNameArray
               withCamera:(id<YtDeviceDelegate> _Nullable)camera
     withEventHandleBlock: (OnYtFrameworkEventBlock _Nonnull)onEventHandleBlock
  withNetworkRequestBlock: (OnYtNetworkRequestBlock _Nullable)onRequestBlock;

/// SDKKit框架资源释放接口
/// @return 0 成功
- (int)deInit;

/// SDKKit框架重置接口
/// 可以不用释放模型或者重新加载库，直接重置pipeline流程，一般用于多次执行pipeline获取最优结果
- (void)reset;

/// 每帧调用接口，针对不同场景用来处理帧数据
/// @param imageData 帧数据信息，VideoType一般可以通过CameraDevice回调获取CMSampleBufferRef，ImageType请传入CGImageRef
/// @param imageDataType 帧数据格式
- (int)updateWithFrameData:(void* _Nonnull)imageData withDataType:(YtFrameworkDataType)imageDataType;
/// @brief 更新配置信息，最好只包含新增的数据信息
/// 目前只针对检测部分相关参数生效，比如距离，角度等
/// @param jsonData SDK配置参数，具体格式参考YtSDKSettings.json
- (void)updateSDKSetting:(NSDictionary * _Nonnull)jsonData;
/// 在手动活体触发模式下，可以调用该接口，手动启动活体检测和退出活体检测功能
/// @param eventType 事件类型
/// @param content 事件内容（一般为nil）
- (void)fireEvent:(YtFrameworkFireEventType)eventType withContent:(id _Nullable)content;

/// 进入暂停生命周期时调用
- (void)doPause;

/// 进入恢复生命周期时调用
- (void)doResume;

@end

