//
//  HYConfigManager.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/19.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HYConfigManager.h"

static NSString *const HYrestartCount      =    @"HYrestartCount";
static NSString *const HYprepareTimeOut      =    @"HYprepareTimeOut";
static NSString *const HYisNeverTimeOut      =    @"HYisNeverTimeOut";
static NSString *const HYactref_ux_mode      =    @"HYactref_ux_mode";
static NSString *const HYactionTimeoutMs      =    @"HYactionTimeoutMs";
static NSString *const HYneed_action_video      =    @"HYneed_action_video";
static NSString *const HYaction_data      =    @"HYaction_data";
static NSString *const HYaction_random      =    @"HYaction_random";
static NSString *const HYreflect_images_shorten_strategy      =    @"HYreflect_images_shorten_strategy";
static NSString *const HYaction_video_shorten_strategy      =    @"HYaction_video_shorten_strategy";
static NSString *const HYIsNotMute      =    @"HYIsNotMute";
static NSString *const HYSuccessPage      =    @"HYSuccessPage";
static NSString *const HYFailurePage      =    @"HYFailurePage";
static NSString *const HYSuccessPageStr      =    @"HYSuccessPageStr";
static NSString *const HYFailurePageStr      =    @"HYFailurePageStr";
static NSString *const HYIsUseBestFaceImage     =    @"HYIsUseBestFaceImage";

@implementation HYConfigManager

+(instancetype)shareInstance{
    static HYConfigManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HYConfigManager alloc] init];
    });
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self){
        if (![[NSUserDefaults standardUserDefaults] valueForKey:HYactref_ux_mode]){
            //第一次没数据时  默认数据
            self.actref_ux_mode = 0;
            self.need_action_video = YES;
            self.action_data = @[@1,@2,@3,@4];
            self.action_random = NO;
            self.reflect_images_shorten_strategy = YES;
            self.action_video_shorten_strategy = YES;
            self.isNotMute = NO;
            self.successPage = YES;
            self.failurePage = YES;
            self.isUseBestFaceImage = YES;
            self.actionTimeoutMs = 15000;
            self.prepareTimeOut = 15000;
            self.restartCount = 5;
            self.isNeverTimeOut = YES;
        }
        self.privateConfig.authLicense = [[NSBundle mainBundle] pathForResource:@"licsence.lic" ofType:@""];
        self.privateConfig.riskLicense = [[NSBundle mainBundle] pathForResource:@"sdcs_test_android.lic" ofType:@""];
        self.privateConfig.prepareTimeoutMs = 9999000;
        self.privateConfig.actionTimeoutMs = 9999000;
        self.privateConfig.userUIBundleName = @"UserUIBundle";
        self.privateConfig.isEncrypt = YES;
        self.privateConfig.showTimeOutMode = HYShowTimeOutMode_TIMEOUT_HIDDEN;
    }
    return self;
}
#pragma mark --------------- setter -----------
- (void)setRestartCount:(NSInteger)restartCount
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(restartCount) forKey:HYrestartCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setIsNeverTimeOut:(BOOL)isNeverTimeOut
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(isNeverTimeOut) forKey:HYisNeverTimeOut];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setPrepareTimeOut:(NSInteger)prepareTimeOut
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(prepareTimeOut) forKey:HYprepareTimeOut];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setActref_ux_mode:(NSInteger)actref_ux_mode
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(actref_ux_mode) forKey:HYactref_ux_mode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setActionTimeoutMs:(NSInteger)actionTimeoutMs
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(actionTimeoutMs) forKey:HYactionTimeoutMs];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setNeed_action_video:(BOOL)need_action_video
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(need_action_video) forKey:HYneed_action_video];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setAction_data:(NSArray *)action_data
{
    
    [[NSUserDefaults  standardUserDefaults] setValue:action_data?:@[] forKey:HYaction_data];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setAction_random:(BOOL)action_random
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(action_random) forKey:HYaction_random];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setReflect_images_shorten_strategy:(BOOL)reflect_images_shorten_strategy
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(reflect_images_shorten_strategy) forKey:HYreflect_images_shorten_strategy];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setAction_video_shorten_strategy:(BOOL)action_video_shorten_strategy
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(action_video_shorten_strategy) forKey:HYaction_video_shorten_strategy];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setIsNotMute:(BOOL)isNotMute
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(isNotMute) forKey:HYIsNotMute];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setSuccessPage:(BOOL)successPage
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(successPage) forKey:HYSuccessPage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setFailurePage:(BOOL)failurePage
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(failurePage) forKey:HYFailurePage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setSuccessPageStr:(NSString *)successPageStr
{
    [[NSUserDefaults  standardUserDefaults] setValue:successPageStr?:@"" forKey:HYSuccessPageStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setFailurePageStr:(NSString *)failurePageStr
{
    [[NSUserDefaults  standardUserDefaults] setValue:failurePageStr?:@"" forKey:HYFailurePageStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setIsUseBestFaceImage:(BOOL)isUseBestFaceImage
{
    [[NSUserDefaults  standardUserDefaults] setValue:@(isUseBestFaceImage) forKey:HYIsUseBestFaceImage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark ----------- getter -----------------
- (NSInteger)restartCount
{
    NSNumber *restartCount = [[NSUserDefaults standardUserDefaults] valueForKey:HYrestartCount];
    return [restartCount integerValue];
}
- (BOOL)isNeverTimeOut
{
    NSNumber *isNeverTimeOut = [[NSUserDefaults standardUserDefaults] valueForKey:HYisNeverTimeOut];
    return [isNeverTimeOut boolValue];
}
- (NSInteger)prepareTimeOut
{
    NSNumber *prepareTimeOut = [[NSUserDefaults standardUserDefaults] valueForKey:HYprepareTimeOut];
    return [prepareTimeOut integerValue];
}
- (NSInteger)actref_ux_mode
{
    NSNumber *actref_ux_mode = [[NSUserDefaults standardUserDefaults] valueForKey:HYactref_ux_mode];
    return [actref_ux_mode integerValue];
}
- (NSInteger)actionTimeoutMs
{
    NSNumber *actionTimeoutMs = [[NSUserDefaults standardUserDefaults] valueForKey:HYactionTimeoutMs];
    return [actionTimeoutMs integerValue];
}
- (BOOL)need_action_video
{
    NSNumber *need_action_video = [[NSUserDefaults standardUserDefaults] valueForKey:HYneed_action_video];
    return [need_action_video boolValue];
}
- (NSArray *)action_data
{
    NSArray *action_data = [[NSUserDefaults standardUserDefaults] valueForKey:HYaction_data];
    return action_data;
}
- (BOOL)action_random
{
    NSNumber *action_random = [[NSUserDefaults standardUserDefaults] valueForKey:HYaction_random];
    return [action_random boolValue];
}
- (BOOL)reflect_images_shorten_strategy
{
    NSNumber *reflect_images_shorten_strategy = [[NSUserDefaults standardUserDefaults] valueForKey:HYreflect_images_shorten_strategy];
    return [reflect_images_shorten_strategy boolValue];
}
- (BOOL)action_video_shorten_strategy
{
    NSNumber *action_video_shorten_strategy = [[NSUserDefaults standardUserDefaults] valueForKey:HYaction_video_shorten_strategy];
    return [action_video_shorten_strategy boolValue];
}
- (BOOL)isNotMute
{
    NSNumber *isNotMute = [[NSUserDefaults standardUserDefaults] valueForKey:HYIsNotMute];
    return [isNotMute boolValue];
}
- (BOOL)successPage
{
    NSNumber *successPage = [[NSUserDefaults standardUserDefaults] valueForKey:HYSuccessPage];
    return [successPage boolValue];
}
- (NSString *)successPageStr
{
    NSString *successPageStr = [[NSUserDefaults standardUserDefaults] valueForKey:HYSuccessPageStr];
    return successPageStr;
}
- (BOOL)failurePage
{
    NSNumber *failurePage = [[NSUserDefaults standardUserDefaults] valueForKey:HYFailurePage];
    return [failurePage boolValue];
}
- (NSString *)failurePageStr
{
    NSString *failurePageStr = [[NSUserDefaults standardUserDefaults] valueForKey:HYFailurePageStr];
    return failurePageStr;
}
- (BOOL)isUseBestFaceImage
{
    NSNumber *isUseBestFaceImage = [[NSUserDefaults standardUserDefaults] valueForKey:HYIsUseBestFaceImage];
    return [isUseBestFaceImage boolValue];
}
- (HuiYanPrivateConfig *)privateConfig
{
    if (!_privateConfig){
        _privateConfig = [[HuiYanPrivateConfig alloc] init];
    }
    return _privateConfig;
}
- (NSString *)liveConfig
{
    NSMutableDictionary *modeConfigDic = [NSMutableDictionary dictionary];
    for (int i = 0; i<4; i++) {
        NSString *actref_ux_modeStr = [NSString stringWithFormat:@"%@=%ld",@"actref_ux_mode",self.actref_ux_mode];
        
        NSString *need_action_videoStr = [NSString stringWithFormat:@"%@=%d",@"need_action_video",self.need_action_video];
        
        NSString *action_dataStr = [NSString stringWithFormat:@"%@=%@",@"action_data",[self.action_data componentsJoinedByString:@","]];
        
        NSString *action_randomStr = [NSString stringWithFormat:@"%@=%d",@"action_random",self.action_random];
        
        NSString *reflect_images_shorten_strategyStr = [NSString stringWithFormat:@"%@=%d",@"reflect_images_shorten_strategy",self.reflect_images_shorten_strategy];
        
        NSString *action_video_shorten_strategyStr = [NSString stringWithFormat:@"%@=%d",@"action_video_shorten_strategy",self.action_video_shorten_strategy];
        
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

@end
