//
//  HuiYanOsStartConfig.h
//  HuiYanSDK
//
//  Created by v_clvchen on 2021/3/15.
//  Copyright © 2021 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HuiYanSDK/TXYHuiYanSDKCommDef.h>

NS_ASSUME_NONNULL_BEGIN


@protocol HuiYanPrivateDelegate <NSObject>
@required
//核身Event事件
- (void)onAuthEvent:(HYAuthEvent)actionEvent;
//核身时tips发生改变的事件通知回调
- (void)actionCallbackType:(HYAuthTipsEvent)actionType;
//当认证的主View被创建的回调
- (void)onMainViewCreate:(UIView *)authView;
//界面被回收的回调
- (void)onMainViewDestroy;
@end


/**
 HuiYanPrivateConfig
 */
@interface HuiYanPrivateConfig : NSObject

// 是否录制验证视频
@property (nonatomic, assign) BOOL isRecordVideo;

// 是否录裁剪视频
@property (nonatomic, assign) BOOL isCutVideo;

// 是否删除本地的视频缓存信息
@property (nonatomic, assign) BOOL isDeleteVideoCache;
// 活体检测超时时间
@property (nonatomic, assign) long authTimeOutMs;
// License文件路径
@property (strong, nonatomic) NSString *authLicense;

// 是否加密活体数据
@property (nonatomic, assign) BOOL isEncrypt;

// 加密方式  默认AES
@property (nonatomic, assign) HYEncryptModel encryptModel;

//相机预览尺寸类型
@property (nonatomic, assign) HY_CameraPreset cameraPreset;

// SDK国际化字体
@property (nonatomic, assign) HY_LanguageType languageType;
//动作回调代理
@property (readwrite, nonatomic, weak)id<HuiYanPrivateDelegate> delegate;

//准备阶段倒计时
@property (nonatomic, assign) long prepareTimeoutMs;

//动作倒计时
@property (nonatomic, assign) long actionTimeoutMs;

/**
 这个设置了会使用自定义打包的UI bundle 文件，会加载里面这个名称的TXYOsAuthingViewController布局文件
 若是未找到TXYOsAuthingViewController 名称的布局文件，将会加载默认布局
 */
@property (strong, nonatomic) NSString * _Nullable userUIBundleName;

@property (strong, nonatomic) NSString * _Nullable userLanguageBundleName;

@property (strong, nonatomic) NSString * _Nullable userLanguageFileName;

//反馈异常Tips的颜色
@property (nonatomic, assign) NSUInteger feedBackErrorColor;
//反馈正常Tips的颜色
@property (nonatomic, assign) NSUInteger feedBackTxtColor;
//动作错背景圆框的颜色
@property (nonatomic, assign) NSUInteger authCircleErrorColor;
//动作正确时背景圆框的颜色
@property (nonatomic, assign) NSUInteger authCircleCorrectColor;
//核身界面背景颜色
@property (nonatomic, assign) NSUInteger authLayoutBgColor;
//提示文字大小
@property (nonatomic, assign) CGFloat feedBackTxtSize DEPRECATED_MSG_ATTRIBUTE("Please use feedBackTxtFont");
//核身提示文字字体及大小
@property (nonatomic, strong) UIFont *feedBackTxtFont;
//额外提示文字大小
@property (nonatomic, strong) UIFont *feedbackExtraTxtFont;
//内部Dialog是否显示
@property (nonatomic, assign) BOOL isShowDialog;
//是否禁止转场动画
@property (nonatomic, assign) BOOL isForbidAnima;

//是否使用后置摄像头
@property (nonatomic, assign) BOOL isUseBackCamera;

@property (nonatomic, assign) BOOL isNeedAngleDetect;

@property (nonatomic, assign) int bestImgPitch;
@property (nonatomic, assign) int bestImgRoll;
@property (nonatomic, assign) int bestImgYaw;
@property (nonatomic, assign) int continuousNum;

//设置传输包体最大值
@property (nonatomic, assign) int limitPkgSize;

//测试包体Type(仅测试配置)
@property (nonatomic, assign) PackageTest packageType;

//活体检测模式
@property (nonatomic, assign) HYSDKKitMode sdkKitModel;

// 动作活体 动作数组
@property (nonatomic, strong) NSArray *actionArr;

@property (nonatomic, assign) CameraZoom zoomType;

// 是否全程高亮
@property (nonatomic, assign) BOOL isEntireHighlight;

// 自动调节亮度
@property (nonatomic, assign) BOOL isAutoScreenBrightness;
// 是否使用人脸最佳帧，默认NO
@property (nonatomic, assign) BOOL isUseBestFaceImage;
// 是否开启耗时检测，默认NO
@property (nonatomic, assign) BOOL isNeedLongCheck;
// 设置耗时检测阶段的超时时间
@property (nonatomic, assign) long longCheckTimeOutMs;
// 是否设置耗时检测使用原始尺寸
@property (nonatomic, assign) int isLongCheckNeedBestOriginalSize;
// 最大人脸 0-1 默认0.8
@property (nonatomic, assign) CGFloat longCheckMaxHeightThreshold;
// 最小人脸 0-1 默认0.6
@property (nonatomic, assign) CGFloat longCheckMinHeightThreshold;
// 张嘴检测阈值 0-1 默认0.30f 值越小越严谨
@property (nonatomic, assign) CGFloat longCheckCloseMouthThreshold;
// 左眼闭眼阈值 0-1 默认0.20f 值越大越严谨
@property (nonatomic, assign) CGFloat longCheckCloseEyeRightThreshold;
// 右眼闭眼阈值 0-1 默认0.20f 值越大越严谨
@property (nonatomic, assign) CGFloat longCheckCloseEyeLeftThreshold;
// longCheck模式活体最大人脸阈值 0-1 默认0.9
@property (nonatomic, assign) CGFloat longCheckBigLiveRatioThreshold;
// longCheck模式活体最小人脸阈值 0-1 默认0.5
@property (nonatomic, assign) CGFloat longCheckSmallLiveRatioThreshold;
// 使用本地配置嘴部阈值，为YES会忽略后台配置，默认NO
@property (nonatomic, assign) BOOL longCheckUseLocalCloseMouthThreshold;
// 使用耗时检测模糊模式
@property (nonatomic, assign) BOOL longCheckUseBlurMode;
// 图灵顿授权文件路径
@property (nonatomic, strong) NSString *riskLicense;

@property (nonatomic, assign) HYShowTimeOutMode showTimeOutMode;
// 禁用黑夜模式
@property (nonatomic, assign) BOOL disableDarkMode;
// 开启核身时禁止系统录屏操作
@property (nonatomic, assign) BOOL disableSystemRecordScreen;
// longCheck模式图像质量压缩率 0.0-1.0 默认1
@property (nonatomic, assign) CGFloat longCheckBestImageQuality;
// 是否打开反光动画
@property (nonatomic, assign) BOOL isOpenLightReflectAnim;

- (BOOL)checkParamIsValidParam;
@end

NS_ASSUME_NONNULL_END
