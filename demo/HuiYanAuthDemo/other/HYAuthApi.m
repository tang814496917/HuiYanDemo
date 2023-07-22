//
//  HYAuthApi.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/7/12.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HYAuthApi.h"
#import <UIKit/UIKit.h>
#import <HuiYanSDK/HuiYanPrivateApi.h>
#import <HuiYanSDK/PrivateLiveDataEntity.h>
#import <HuiYanSDK/PrivateCompareResult.h>
#import <HuiYanSDK/PrivateGetConfigResult.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "HYToastAlertView.h"
#import "HYCircleProgressView.h"
#import "HYAudioPlayManager.h"
#import "HYConfigModel.h"
#import "HYNetWorkService.h"
#import "HYCommonToast.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface HYAuthApi()<UITextViewDelegate,UITextFieldDelegate,HuiYanPrivateDelegate>
{
   BOOL isHasCameraPermissions;
}

@property (nonatomic, assign) NSInteger actionType;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *muteBtn;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *timeOutLab;

@property (nonatomic, strong) UILabel *tipsLab;

@property (nonatomic, strong) HYCircleProgressView *circleView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger prepareTimeOut;

@property (nonatomic, assign) NSInteger actionTimeoutMs;

@property (nonatomic, assign) NSInteger actionVerifiedCount;

@property (nonatomic, strong) NSArray * actionArray;

@property (nonatomic, assign) NSInteger alertCount;

@property (nonatomic, strong) UIView *authView;

@property (nonatomic, strong) UIImageView *faceImageView;

@property (nonatomic, assign) BOOL isFaceToScreen;

@property (nonatomic, strong) NSDictionary *reportDic;

@property (nonatomic, assign) NSInteger actionPlayCount;

@property (nonatomic, strong) HYConfigModel *model;

@property (nonatomic, copy) HYResultSuccCallback resultSuccCallBack;

@property (nonatomic, copy) HYResultFailCallback resultFailCallBack;



@end

@implementation HYAuthApi

+ (void)startAuth:(HYConfigModel *)model
         withSuccCallback:(HYResultSuccCallback)hYResultSuccCallback
 withFailCallback:(HYResultFailCallback)hYResultFailCallback{
    
    HYAuthApi *authApi = [[HYAuthApi alloc]init];
    authApi.resultSuccCallBack = hYResultSuccCallback;
    authApi.resultFailCallBack = hYResultFailCallback;
    authApi.model = model;
    [authApi checkCamera];
}
-(void)checkCamera{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
       if (granted) {
           NSLog(@"允许访问相机");
           dispatch_async(dispatch_get_main_queue(), ^{
              [self startHuiYanAuth];
           });
       } else {
           NSLog(@"用户拒绝访问相机~");
           [HYCommonToast showHudWithText:@"用户拒绝访问相机~"];
           self->isHasCameraPermissions = NO;
           dispatch_async(dispatch_get_main_queue(), ^{
               NSLog(@"请开启访问相机权限!");
               [HYCommonToast showHudWithText:@"请开启访问相机权限!"];
           });
       }
    }];
}
- (void)startHuiYanAuth {
    [self timer];
    self.actionPlayCount = 0;
    [_timer setFireDate:[NSDate distantPast]];
    self.reportDic = @{};
    self.actionType = -1;
    self.prepareTimeOut = self.model.prepareTimeOut;
    self.actionTimeoutMs = self.model.actionTimeoutMs;
    self.actionVerifiedCount = 0;
    self.actionArray = @[];
    HuiYanPrivateConfig *privateConfig = [[HuiYanPrivateConfig alloc]init];
    privateConfig.authLicense = [[NSBundle mainBundle] pathForResource:@"licsence.lic" ofType:@""];
    privateConfig.riskLicense = [[NSBundle mainBundle] pathForResource:@"sdcs_test_androids.lic" ofType:@""];
    privateConfig.prepareTimeoutMs = 9999000;
    privateConfig.actionTimeoutMs = 9999000;
    privateConfig.userUIBundleName = @"UserUIBundle";
    privateConfig.isEncrypt = YES;
    privateConfig.showTimeOutMode = HYShowTimeOutMode_TIMEOUT_HIDDEN;
    privateConfig.authCircleErrorColor = 0xFFFFFF;
    privateConfig.authCircleCorrectColor = 0xFFFFFF;
    privateConfig.delegate = self;
    privateConfig.isUseBestFaceImage = self.model.isUseBestFaceImage;
    __weak  HYAuthApi *weakSelf = self;
    [HuiYanPrivateApi startGetAuthConfigData:privateConfig withSuccCallback:^(PrivateGetConfigResult * _Nonnull getConfigResult) {
        [weakSelf getLightDataWith:getConfigResult];
    } withFailCallback:^(int errCode, NSString * _Nonnull errMsg) {
//        [HYCommonToast showHudWithText:[NSString stringWithFormat:@"SDK startGetAuthConfigData errCode:%d, errMsg:%@", errCode, errMsg]];
        NSLog(@"startGetAuthConfigData errCode:%d, errMsg:%@", errCode, errMsg);
        [weakSelf.timer invalidate];
        weakSelf.timer = nil;
        self.prepareTimeOut = self.model.prepareTimeOut;
        self.actionTimeoutMs = self.model.actionTimeoutMs;
    }];
}
- (void)getLightDataWith:(PrivateGetConfigResult *)getConfigResult {
    
    NSMutableDictionary *params = @{
        @"selectData":getConfigResult.selectData?:@"",
        @"envRiskData":getConfigResult.envRiskData?:@"",
        @"requestId":[NSUUID UUID].UUIDString,
    }.mutableCopy;
    if (!self.model.isDefaultAction) {
        [params setValue:[self liveConfig] forKey:@"liveConfig"];
    }
    __weak  HYAuthApi *weakSelf = self;
    self.prepareTimeOut = self.prepareTimeOut;
    [HYNetWorkService postAction:@"getLiveType" withParams:params completion:^(NSDictionary * _Nonnull result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"无网络");
            [HYCommonToast showHudWithText:@"网络出错"];
        }else{
            NSInteger errorCode = [[result valueForKey:@"errorCode"] integerValue];
            if (errorCode == 0) {
                NSString *liveResult = [result valueForKey:@"liveResult"];
                NSString *riskResult = [result valueForKey:@"riskResult"];
                NSString *extraInfo = [result valueForKey:@"extraInfo"];
                
                NSData *jsonData = [liveResult dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *liveResultdic = [NSJSONSerialization JSONObjectWithData:jsonData
                options:NSJSONReadingMutableContainers
                error:nil];
                if (liveResultdic&&[liveResultdic objectForKey:@"actionData"]){
                    NSString *actionDataStr = [liveResultdic objectForKey:@"actionData"];
                    self.actionArray = [actionDataStr componentsSeparatedByString:@","];
                }
                PrivateLiveDataEntity *liveDataEntity = [[PrivateLiveDataEntity alloc]init];
                liveDataEntity.liveResult = liveResult;
                liveDataEntity.riskResult = riskResult;
                liveDataEntity.extraInfo = extraInfo;
                [weakSelf startAuthWithLiveData:liveDataEntity];
            }else{
                [HYCommonToast showHudWithText:[NSString stringWithFormat:@"Net errorCode:%ld  errorMsg:%@",errorCode,[result valueForKey:@"errorMsg"]]];
            }
        }
    }];
}


- (void)startAuthWithLiveData:(PrivateLiveDataEntity *)liveDataEntity {
    __weak  HYAuthApi *weakSelf = self;
    self.isFaceToScreen = YES;
    [HuiYanPrivateApi startAuthByLiveData:liveDataEntity withSuccCallback:^(PrivateCompareResult * _Nonnull compareResult, NSString * _Nonnull videoPath) {
        //extraInfo 透传
        compareResult.extraInfo = liveDataEntity.extraInfo;
        [weakSelf liveCompare:compareResult];
    } withFailCallback:^(int errCode, NSString * _Nonnull errMsg) {
        NSLog(@"errCode:%d, errMsg:%@", errCode, errMsg);
//        [HYCommonToast showHudWithText:[NSString stringWithFormat:@"SDK errCode:%d, errMsg:%@", errCode, errMsg]];
        [_timer invalidate];
        _timer = nil;
        self.prepareTimeOut = self.model.prepareTimeOut;
        self.actionTimeoutMs = self.model.actionTimeoutMs;
    }];
}
- (void)liveCompare:(PrivateCompareResult *)compareResult{
    if ([HYToastAlertView isShowing]) return;
    NSDictionary *params = @{
        @"platform":@(compareResult.platform),
        @"extraInfo":compareResult.extraInfo?:@"",
        @"sign":compareResult.sign?:@"",
        @"liveData":compareResult.liveData?:@"",
        @"requestId":[NSUUID UUID].UUIDString,
    };
    __weak  HYAuthApi *weakSelf = self;
    [HYNetWorkService postAction:@"liveCompare" withParams:params completion:^(NSDictionary * _Nonnull result, NSError * _Nullable error) {
        if (error) {
            [HYCommonToast showHudWithText:@"网络出错"];
            [weakSelf jumpResult:NO];
        }else{
            NSInteger errorCode = [[result valueForKey:@"errorCode"] integerValue];
            if (errorCode == 0) {
                [weakSelf jumpResult:YES];
            }else{
                [weakSelf jumpResult:NO];
                NSLog(@"%@",[result valueForKey:@"errorMsg"]);
                [HYCommonToast showHudWithText:[NSString stringWithFormat:@"Net errorCode:%ld  errorMsg:%@",errorCode,[result valueForKey:@"errorMsg"]]];
            }
        }
    }];
}
- (void)jumpResult:(BOOL)success{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *infoDic = @{
            @"0":@"眨眼",
            @"1":@"眨眼",
            @"2":@"张嘴",
            @"3":@"点头",
            @"4":@"摇头",
            @"5":@"正脸",
        };
        if (success){
            if (self.resultSuccCallBack)
            {
                self.resultSuccCallBack(self.reportDic);
            }
        }else{
            if (self.resultFailCallBack){
                self.resultFailCallBack(0, @"");
            }
        }

        self.alertCount = 0;
    });
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.reportDic
                                                       options:0
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    [HYCommonToast showHudWithText:jsonString];
}
- (void)timeTick{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ((self.actionType == -1)) {
            if (self.model.isNeverTimeOut){
                self.timeOutLab.text = @"";
            }else{
                self.timeOutLab.text = [NSString stringWithFormat:@"%lds",self.prepareTimeOut/1000];
                if (self.prepareTimeOut == 0){
                    [self showAlertViewWithType:0];
                }else{
                    self.prepareTimeOut = self.prepareTimeOut - 1000;
                }
            }
        }else if (self.actionType == HY_OPEN_MOUTH_CHECK || self.actionType == HY_BLINK_CHECK || self.actionType == HY_NOD_HEAD_CHECK || self.actionType == HY_SHAKE_HEAD_CHECK){
            self.timeOutLab.text = [NSString stringWithFormat:@"%lds",self.actionTimeoutMs/1000];
            if (self.actionTimeoutMs == 0){
                [self showAlertViewWithType:1];
            }else{
                self.actionTimeoutMs = self.actionTimeoutMs - 1000;
            }
        }else{
            self.timeOutLab.text = @"";
        }
        BOOL  isPlay = self.actionPlayCount%3 == 0 ? YES : NO;
        switch (self.actionType) {
            case -1:
             if (isPlay) [self playVoice:@"请正对屏幕"];
                break;
            case HY_OPEN_MOUTH_CHECK:
                if (isPlay) [self playVoice:@"请张嘴"];
                break;
            case HY_BLINK_CHECK:
                if (isPlay) [self playVoice:@"请眨眼"];
                break;
            case HY_NOD_HEAD_CHECK:
                if (isPlay) [self playVoice:@"请点点头"];
                break;
            case HY_SHAKE_HEAD_CHECK:
                if (isPlay) [self playVoice:@"请摇摇头"];
                break;
            default:
                break;
        };
        self.actionPlayCount++;
    });
 
}
- (void)showAlertViewWithType:(NSInteger )type{
    if ([HYToastAlertView isShowing]) return;
    __weak HYAuthApi *weakSelf = self;
    self.timeOutLab.hidden = YES;
    self.alertCount ++;
   __block BOOL mute = self.model.mute;
    if (!self.model.mute){
        self.model.mute = YES;
    }
    if (self.alertCount>self.model.restartCount) {
        if(self.cancelBtn){
            [self.cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        [self jumpResult:NO];
        return;
    }
    [HYToastAlertView createImg:self.authView];
        [HYToastAlertView showAlertViewWithbuttonClickedBlock:^(NSInteger index) {
            weakSelf.timeOutLab.hidden = NO;
            weakSelf.model.mute = mute;
            if (index == 0) {
                if (weakSelf.cancelBtn){
                    [weakSelf.cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }else{
                    [weakSelf.cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf startHuiYanAuth];
                    });
//                }
            }
        }];
}
- (void)playVoice:(NSString *)str{
    
    if (self.model.mute) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HYAudioPlayManager audioPlayClass].playContentStr = str;
    });
}
#pragma mark - HuiYanPrivateDelegate
- (void)actionCallbackType:(HYAuthTipsEvent)actionType {
    if ([HYToastAlertView isShowing]) return;
    NSString *tips = [self tipsWithEvent:actionType];
    if (tips) {
        self.tipsLab.text = [tips componentsSeparatedByString:@"/"].firstObject;
    }
    [self createReportDataWithTips:tips];
  
}
- (void)createReportDataWithTips:(NSString *)tips{
    //准备中
    if(!tips) return;
    NSString *code = [tips componentsSeparatedByString:@"/"].lastObject;
    NSString *text = [tips componentsSeparatedByString:@"/"].firstObject;
    NSDictionary *dataDic = @{
        @"code":code?code:@"",
        @"text":text?text:@"",
        @"time":[self getCurrentTime],
    };
    NSMutableDictionary *reportDic = self.reportDic.mutableCopy;
    NSString *dataKey = @"";
    //准备中
    if (self.actionType == -1){
        dataKey = @"zhunbeizhong";
        //张嘴
    }else if (self.actionType == HY_OPEN_MOUTH_CHECK){
        dataKey = @"zhangzui";
        //眨眼
    }else if (self.actionType == HY_BLINK_CHECK){
        dataKey = @"zhayan";
        //点头
    }else if (self.actionType == HY_NOD_HEAD_CHECK){
        dataKey = @"diantou";
        //摇头
    }else if (self.actionType == HY_SHAKE_HEAD_CHECK){
        dataKey = @"yaotou";
    }
    if (dataKey.length>0) {
        if ([reportDic valueForKey:dataKey]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[reportDic valueForKey:dataKey]];
            [array addObject:dataDic];
            [reportDic setObject:array forKey:dataKey];
        }else{
            NSArray *array = @[dataDic];
            [reportDic setObject:array forKey:dataKey];
        }
    }
    self.reportDic = reportDic.copy;
    
}
- (NSString *)getCurrentTime{
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        
        //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [df stringFromDate:currentDate];
}
- (void)onAuthEvent:(HYAuthEvent)actionEvent {
    if ([HYToastAlertView isShowing]) return;
    NSArray *animationImages = @[[UIImage imageNamed:@"正脸"],[UIImage imageNamed:@"正脸"]];
    switch (actionEvent) {
        case HY_OPEN_MOUTH_CHECK:
            self.actionType = actionEvent;
            self.actionPlayCount = 0;
            [_timer setFireDate:[NSDate distantPast]];
            self.imageView.hidden = NO;
            animationImages = @[[UIImage imageNamed:@"正脸"],[UIImage imageNamed:@"张嘴"]];
            break;
        case HY_BLINK_CHECK:
            self.actionPlayCount = 0;
            [_timer setFireDate:[NSDate distantPast]];
            self.actionType = actionEvent;
            [self playVoice:@"请眨眼"];
            self.imageView.hidden = NO;
            animationImages = @[[UIImage imageNamed:@"正脸"],[UIImage imageNamed:@"眨眼"]];
            break;
        case HY_NOD_HEAD_CHECK:
            self.actionPlayCount = 0;
            [_timer setFireDate:[NSDate distantPast]];
            self.actionType = actionEvent;
            [self playVoice:@"请点点头"];
            self.imageView.hidden = NO;
            animationImages = @[[UIImage imageNamed:@"正脸"],[UIImage imageNamed:@"点头"]];
            break;
        case HY_SHAKE_HEAD_CHECK:
            self.actionPlayCount = 0;
            [_timer setFireDate:[NSDate distantPast]];
            self.actionType = actionEvent;
            [self playVoice:@"请摇摇头"];
            self.imageView.hidden = NO;
            animationImages = @[[UIImage imageNamed:@"左"],[UIImage imageNamed:@"右"]];
            break;
        case HY_SILENCEN_CHECK:
            self.actionType = actionEvent;
            animationImages = @[[UIImage imageNamed:@"正脸"],[UIImage imageNamed:@"正脸"]];
            break;
        case HY_REFLECT_CHECK:
            self.actionType = actionEvent;
            self.imageView.hidden = YES;
            break;
        default:
            break;
    }
    if(self.imageView){
        [self.imageView stopAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.imageView.animationImages = animationImages;
            self.imageView.animationDuration = 1;
            self.imageView.animationRepeatCount = NSIntegerMax;
            [self.imageView startAnimating];
        });
    }
    if (self.actionType == HY_OPEN_MOUTH_CHECK || self.actionType == HY_BLINK_CHECK || self.actionType == HY_NOD_HEAD_CHECK || self.actionType == HY_SHAKE_HEAD_CHECK || self.actionType == HY_REFLECT_CHECK){
        CGFloat actionCount = self.actionArray.count;
        if (actionCount<=0) actionCount = 1;
        self.circleView.progress = self.actionVerifiedCount/actionCount;
        self.actionVerifiedCount ++;
        self.actionTimeoutMs = self.model.actionTimeoutMs;
        if (self.actionVerifiedCount<=1) return;
        if (self.model.mute) return;
        [HYAudioPlayManager audioPlayClass].playContentStr = @"BG";
    }
}
- (void)onMainViewCreate:(UIView *)authView {
    self.authView = authView;
    for (UIView *tmpView in [authView subviews]) {
        NSLog(@"tag:%ld",tmpView.tag);
        NSLog(@"tmpView:%@",tmpView);
        if(tmpView.tag == 10000) {
            self.cancelBtn = (UIButton *)tmpView;
        }else if(tmpView.tag == 10001) {
            UIButton *tmpBtn = (UIButton *)tmpView;
            [tmpBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if (tmpView.tag == 10002){
      // 静音
            self.muteBtn = (UIButton *)tmpView;
            [self.muteBtn addTarget:self action:@selector(mute:) forControlEvents:UIControlEventTouchUpInside];
            [self.muteBtn setImage:[[UIImage imageNamed:@"goodsVideoSound_open"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [self.muteBtn setImage:[[UIImage imageNamed:@"goodsVideoSound"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
            self.muteBtn.selected = self.model.mute;
        }else if (tmpView.tag == 10003){
            self.imageView = (UIImageView *)tmpView;
            self.imageView.hidden = YES;
        }else if (tmpView.tag == 10004){
            self.timeOutLab = (UILabel *)tmpView;
            if (self.model.isNeverTimeOut){
                self.timeOutLab.text = @"";
            }else{
                self.timeOutLab.text = [NSString stringWithFormat:@"%lds",self.prepareTimeOut/1000];
            }
        }else if (tmpView.tag == 10005){
            tmpView.backgroundColor = UIColor.clearColor;
            self.circleView = [[HYCircleProgressView alloc]initWithFrame:CGRectMake(0, 0, 278, 278)];
            self.circleView.progress = 0;
            [tmpView addSubview:self.circleView];
         
            self.faceImageView.frame = CGRectMake((SCREEN_WIDTH-198)/2.f, 167, 198, 223);
     
        }else if (tmpView.tag == 10006){
            self.tipsLab = (UILabel *)tmpView;
            self.tipsLab.text = @"准备中";
        }else if (tmpView.tag == 10007){
            UIImageView *imageView = (UIImageView *)tmpView;
            imageView.image = [UIImage new];
        }
    }
    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
     
    self.faceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"face"]];
    self.faceImageView.frame = CGRectMake((SCREEN_WIDTH-198)/2, 167+statusBarManager.statusBarFrame.size.height, 198, 223);
    [authView addSubview:self.faceImageView];
}

- (void)onMainViewDestroy {
    self.cancelBtn = nil;
    self.closeBtn = nil;
    self.muteBtn = nil;
    self.imageView = nil;
    self.timeOutLab = nil;
    self.circleView = nil;
    self.authView = nil;
    self.faceImageView = nil;
    [_timer invalidate];
    _timer = nil;
    self.prepareTimeOut = self.model.prepareTimeOut;
    self.actionTimeoutMs = self.model.actionTimeoutMs;
}

- (void)closeBtnClick:(UIButton *)sender {
    if (self.cancelBtn){
        [self.cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)mute:(UIButton *)button{
    button.selected = !button.selected;
    self.model.mute = !button.selected;
}
- (void)dealloc {
    [HuiYanPrivateApi release];
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (NSString *)liveConfig
{
    NSMutableDictionary *modeConfigDic = [NSMutableDictionary dictionary];
    NSArray *randomArr = @[];
    if (self.model.action_random){
        randomArr = [self randomArr:self.model.action_data];
    }else{
        randomArr = self.model.action_data;
    }
    for (int i = 0; i<4; i++) {
        NSString *actref_ux_modeStr = [NSString stringWithFormat:@"%@=%ld",@"actref_ux_mode",self.model.actref_ux_mode];
        
        NSString *need_action_videoStr = [NSString stringWithFormat:@"%@=%d",@"need_action_video",@(YES)];
        
        NSString *action_dataStr;
        if (self.model.action_data.count <= 0){
            action_dataStr = @"action_data=5";
        }else{
            
            action_dataStr = [NSString stringWithFormat:@"%@=%@",@"action_data",[randomArr componentsJoinedByString:@","]];
        }
       
        
        NSString *action_randomStr = [NSString stringWithFormat:@"%@=%d",@"action_random",self.model.action_random];
        
        NSString *reflect_images_shorten_strategyStr = [NSString stringWithFormat:@"%@=%d",@"reflect_images_shorten_strategy",@(YES)];
        
        NSString *action_video_shorten_strategyStr = [NSString stringWithFormat:@"%@=%d",@"action_video_shorten_strategy",@(YES)];
        
        NSString *configStr = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@",actref_ux_modeStr,need_action_videoStr,action_dataStr,action_randomStr,reflect_images_shorten_strategyStr,action_video_shorten_strategyStr];
        [modeConfigDic setValue:configStr forKey:[@(i+1) stringValue]];
    }
    NSDictionary *liveConfigDic = @{@"modeConfig":modeConfigDic};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:liveConfigDic
                                                       options:0
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSMutableString *responseString = [NSMutableString stringWithString:jsonString];
        NSString *character = nil;
        for (int i = 0; i < responseString.length; i ++) {
            character = [responseString substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"\\"])
                [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    return responseString?:@"";
}
- (NSString *)tipsWithEvent:(HYAuthTipsEvent )event
{
    if (event == ACT_OPEN_MOUTH){
        return @"请张嘴/1000";
    }else if (event == ACT_BLINK){
        return @"请眨眼/1001";
    }else if (event == ACT_NOD_HEAD){
        return @"请点点头/1002";
    }else if (event == ACT_SHAKE_HEAD){
        return @"请摇摇头/1003";
    }else if (event == LIGHT_TOO_LOW){
        return @"请保证光线充足/1004";
    }else if (event == LIGHT_TOO_STRONG){
        return @"请避免光线过强/1005";
    }else if (event == NO_FACE){
        return @"请正对屏幕/1006";
    }else if (event == INCOMPLETE_FACE){
        return @"请把脸移入框内/1007";
    }else if (event == POSE_FARTHER ){
        return @"请离远一点/1008";
    }else if (event == POSE_CLOSER){
        return @"请离近一点/1009";
    }else if (event == NO_LEFT_FACE||event == NO_RIGHT_FACE||event == NO_CHINE||event == NO_MOUTH||event == NO_NOSE||event == NO_LEFT_EYE||event == NO_RIGHT_EYE){
        return @"请保证脸部无遮挡/1010";
    }else if (event == TOO_MANY_FACE){
        return @"请确保框内只有一张人脸/1011";
    }else if (event == ACT_SCREEN_SHAKING){
        return @"请勿晃动/1012";
    }else{
        return nil;
    }
}
- (NSArray *)randomArr:(NSArray *)arr{
    NSMutableArray *newArr = [NSMutableArray new];
    while (newArr.count != arr.count) {
        //生成随机数
        int x =arc4random() % arr.count;
        id obj = arr[x];
        if (![newArr containsObject:obj]) {
            [newArr addObject:obj];
        }
    }
    return newArr;
}

@end
