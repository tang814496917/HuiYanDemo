//
//  TXYHuiYanSDKCommDef.h
//  HuiYanSDK
//
//  Created by long Cc on 2020/8/28.
//  Copyright © 2020 tencent. All rights reserved.
//

#ifndef TXYHuiYanSDKCommDef_h
#define TXYHuiYanSDKCommDef_h

typedef NS_ENUM(NSInteger,HYSDKKitError) {
    HY_SUCCESS                              = 0,
    // 初始化参数异常
    HY_INITIALIZATION_PARAMETER_EXCEPTION   = 210,
    // bundle配置异常
    HY_BUNDLE_CONFIGURATION_EXCEPTION       = 211,
    // 优图配置异常
    HY_YTSDK_CONFIGURATION_EXCEPTION        = 212,
    // 先调用初始化接口
    HY_PLEASE_CALL_FIRST_INIT_API           = 213,
    // SDK 授权失败
    HY_SDK_AUTH_FAILED                      = 214,
    // 用户手动取消
    HY_USER_VOLUNTARILY_CANCELED            = 215,
    // SDK 人脸本地检测失败
    HY_YTSDK_LOCAL_AUTH_FAILED              = 216,
    // 相机开启失败
    HY_CAMERA_OPEN_FAIL                     = 217,
    // 请勿在核身过程中切换应用
    HY_DONOT_SWITCH_APPS                    = 218,
    // 摄像头权限异常
    HY_CAMEREA_PERMISSION_EXCEPTION         = 219,
    // 视频裁剪失败
    HY_SDK_VEDIO_CUT_EXCEPTION              = 220,
    // 光线数据格式错误
    HY_LIGHT_DATA_FORMAT_EXCEPTION          = 221,
    // 动作检测超时
    HY_DETECT_TIMEOUT                       = 222,
    // 超过包体设置大小的限制
    HY_LIMIT_SET_PKG_SIZE                   = 223,
    //传入数据包含反光内容请使用前置摄像头
    HY_USE_BACK_CAMERA_WITH_REFLECTIVE_ERROR = 227,
    // 准备阶段超时
    HY_PREPARE_TIMEOUT                       = 300,
    // 耗时检测超时
    HY_LONGCHECK_TIMEOUT                     = 301,
    // 请勿在核身过程中开启视频录制
    HY_DONOT_ALLOW_RECORDING                 = 302,
    // 请勿在核身过程中截屏
    HY_DONOT_ALLOW_SCREENSHOTS               = 303,
};

typedef enum : NSUInteger {
    PREPARE = 0,//准备中
    AUTH_ACTION,// 一闪动作核身部分
    AUTH_GET_DATA,// 数据获取完毕
    AUTH_END,// 一闪本地认证结束，发送后台处理
    AUTH_RESULT // 一闪结果通知
} AuthState;


typedef void (^StateChanageUI)(AuthState state,id extraDate);


typedef enum : NSUInteger {
    //默认事件不回调
    HY_NONE = 0,
    //启动认证
    HY_START_AUTH,
    //张嘴检测
    HY_OPEN_MOUTH_CHECK,
    //静默检测
    HY_SILENCEN_CHECK,
    //眨眼检测
    HY_BLINK_CHECK,
    //点头检测
    HY_NOD_HEAD_CHECK,
    //摇头检测
    HY_SHAKE_HEAD_CHECK,
    //reflect-反光检测
    HY_REFLECT_CHECK,
} HYAuthEvent;

typedef enum : int {
    // 不需要回调
    NONE = 0,
    // act_open_mouth 请张张嘴
    ACT_OPEN_MOUTH,
    // act_blink 请眨眨眼
    ACT_BLINK,
    // act_nod_head 请点头
    ACT_NOD_HEAD,
    // act_shake_head 请摇头
    ACT_SHAKE_HEAD,
    // act_screen_shaking 请不要晃动
    ACT_SCREEN_SHAKING,
    // act_light_not_right 光线不合适
    ACT_LIGHT_NOT_RIGHT,
    // no_face 没有检测到人脸
    NO_FACE,
    // no_left_face 请勿遮挡左脸
    NO_LEFT_FACE,
    // no_right_face 请勿遮挡右脸
    NO_RIGHT_FACE,
    // no_chin 请勿遮挡下巴
    NO_CHINE,
    // no_mouth 请勿遮挡嘴巴
    NO_MOUTH,
    // no_nose 请勿遮挡鼻子
    NO_NOSE,
    // no_left_eye, 请勿遮挡左眼
    NO_LEFT_EYE,
    // no_right_eye 请勿遮挡右眼
    NO_RIGHT_EYE,
    // pose_keep 验证中，请保持姿势不变
    POSE_KEEP,
    // pose_closer 请靠近一点
    POSE_CLOSER,
    // pose_farther 请离远一点
    POSE_FARTHER,
    // pose_open_eye 请睁眼
    POSE_OPEN_EYE,
    // pose_incorrect 请摆正头部姿势
    POSE_INCORRECT,
    // fl_too_many_faces 请确保框内只有一张人脸
    TOO_MANY_FACE,
    // fl_incomplete_face 请将脸移动到框内
    INCOMPLETE_FACE,
    //txy_light_low 光线过低
    LIGHT_TOO_LOW,
    //txy_light_strong 光线过强
    LIGHT_TOO_STRONG,
    //yt_face_ref_angle_detect_error 变光环节人脸角度过大
    ANGLE_DETECT_LARGE
} HYAuthTipsEvent;


typedef enum : NSUInteger {
    HY_DEFAULT = 0,//跟随系统设置
    HY_ZH_HANS,//中文简体
    HY_ZH_HANT,//中文繁体//(中文繁体)
    HY_EN,//英文
    HY_CUSTOMIZE_LANGUAGE //定制语言
} HY_LanguageType;

typedef enum : NSUInteger {
    PRESET_640x480 = 0,
    PRESET_1280x720,
} HY_CameraPreset;

typedef enum : NSUInteger {
    HY_ONLY_TEST = 0,
    HY_SMALL,
    HY_MEDIUM,
    HY_BIG,
} PackageTest;

typedef NS_ENUM(NSInteger, HYSDKKitMode)
{
    /// 静默核身模式
    HY_SDK_SILENT_MODE = 1,
    /// 动作核身模式
    HY_SDK_ACTION_MODE = 2,
    /// 反光核身模式
    HY_SDK_REFLECT_MODE = 3,
    /// 动作反光核身模式
    HY_SDK_ACTREFLECT_MODE = 4,
    /// 其他模式（暂不使用）
    HY_SDK_CUSTOM_MODE = 8,
};

typedef enum : NSUInteger {
    HY_AES = 0,
    HY_SM4,
} HYEncryptModel;

typedef enum : NSUInteger {
    ZOOM_1X = 0,
    ZOOM_1_5X,
    ZOOM_2X,
} CameraZoom;

typedef NS_OPTIONS(int, HYShowTimeOutMode) {
    HYShowTimeOutMode_TIMEOUT_HIDDEN = 1 << 0,// 隐藏所有倒计时
    HYShowTimeOutMode_PREPARE = 1 << 1,// 准备阶段倒计时
    HYShowTimeOutMode_LONGCHECK = 1 << 2,// 耗时检测阶段倒计时
    HYShowTimeOutMode_ACTION = 1 << 3,// 动作阶段倒计时
};

#endif /* TXYHuiYanSDKCommDef_h */
