//
//  ViewController.m
//  HuiYanAuthDemo
//
//  Copyright © 2020 tencent. All rights reserved.
//

#import "ViewController.h"
#import <HuiYanSDK/HuiYanPrivateApi.h>
#import <HuiYanSDK/PrivateLiveDataEntity.h>
#import <HuiYanSDK/PrivateCompareResult.h>
#import <HuiYanSDK/PrivateGetConfigResult.h>
#import <AVFoundation/AVCaptureDevice.h>

//#import <OcrSDKKit/OcrSDKKit.h>
//#import <OcrSDKKit/CustomConfigUI.h>
//#import <OcrSDKKit/OcrCommDef.h>

@interface ViewController ()<UITextViewDelegate,UITextFieldDelegate,HuiYanPrivateDelegate> {
    BOOL isHasCameraPermissions;
    
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"SDK version :%@",[HuiYanPrivateApi sdkVersion]);
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.center = self.view.center;
    button.bounds = CGRectMake(0, 0, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(startHuiYanAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}


-(void) viewWillAppear:(BOOL)animated {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
       if (granted) {
           NSLog(@"允许访问相机");
           self->isHasCameraPermissions = YES;
       } else {
           NSLog(@"用户拒绝访问相机~");
           self->isHasCameraPermissions = NO;
           dispatch_async(dispatch_get_main_queue(), ^{
               NSLog(@"请开启访问相机权限!");
           });
       }
    }];
}
- (void)startHuiYanAuth{
    if (!isHasCameraPermissions) {
        NSLog(@"用户拒绝访问相机~");
        return;
    }
    
//    [self startOCR];
    
    HuiYanPrivateConfig *config = [[HuiYanPrivateConfig alloc] init];
    config.authLicense = [[NSBundle mainBundle] pathForResource:@"licsence.lic" ofType:@""];
    config.riskLicense = [[NSBundle mainBundle] pathForResource:@"sdcs_test_android.lic" ofType:@""];

    config.actionTimeoutMs = 10000;
    config.prepareTimeoutMs = 10000;
    config.isDeleteVideoCache = YES;
//    config.userUIBundleName = @"UserUIBundle";
//    config.userLanguageBundleName = @"languageSrcBundle";
//    config.languageType = HY_ZH_HANT;
//    config.userLanguageFileName = @"en";

    [HuiYanPrivateApi startGetAuthConfigData:config withSuccCallback:^(PrivateGetConfigResult * _Nonnull getConfigResult) {
        NSLog(@"result:%@",getConfigResult);
        //后端请求获取光线数据
        PrivateLiveDataEntity *liveDataEntity= [self getLightDataWith:getConfigResult];
        [self startAuthWithLiveData:liveDataEntity];
    } withFailCallback:^(int errCode, NSString * _Nonnull errMsg) {
        NSLog(@"startGetAuthConfigData errCode:%d, errMsg:%@", errCode, errMsg);
    }];
}

- (PrivateLiveDataEntity *) getLightDataWith:(PrivateGetConfigResult *)getConfigResult {
    //客户侧自己请去拉取一闪活体数据传入sdk
    PrivateLiveDataEntity *liveDataEntity = [[PrivateLiveDataEntity alloc] init];
    liveDataEntity.liveResult = @"{\"errorCode\":0,\"errorMsg\":\"OK\",\"colorData\":\"4 70 2 3 3 2 0 0 ;ejEHAAMAAAAAAAAARgAAAAAAAACzvxxhAAAAAO/ACgAAAAAAAAAATOY1h/I3HsjyH79G8gIAAAACAAAAAgAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAA=;5e8e35d060c542c4559d5bf358b45178\",\"actionData\":\"0\",\"selectData\":\"{\\\"platform\\\":1,\\\"protocal\\\":1,\\\"android_data\\\":{},\\\"ios_data\\\":{\\\"systemName\\\":\\\"iOS\\\",\\\"model\\\":\\\"iPhone\\\",\\\"sysVersion\\\":\\\"14.4\\\",\\\"deviceInfo\\\":\\\"x86_64\\\"},\\\"change_point_num\\\":2,\\\"config\\\":\\\"actref_ux_mode=1\\\\u0026action_data=0\\\\u0026need_action_video=true\\\",\\\"client_version\\\":\\\"sdk_version:1.1.15.3.1;ftrack_sdk_version:v3.0.5-mini.6;faction_sdk_version:3.7.2;freflect_sdk_version:3.7.4\\\",\\\"reflect_param\\\":\\\" version 2\\\"}\"}";
    liveDataEntity.riskResult = @"{\"errCode\":0,\"riskLevel\":2,\"riskTag\":\"\",\"needVideo\":false,\"checkImageParams\":\"\"}";
    liveDataEntity.extraInfo = @"3jQsNJlwnVDiZvZTseD8OvTXzJ2g/eHXXtnEF9lsK4M=";
    return liveDataEntity;
}

- (void) startAuthWithLiveData:(PrivateLiveDataEntity *)liveDataEntity {
//    [HuiYanPrivateApi startAuthByLiveData:nil withSuccCallback:nil withFailCallback:nil];
    [HuiYanPrivateApi startAuthByLiveData:liveDataEntity withSuccCallback:^(PrivateCompareResult * _Nonnull compareResult, NSString * _Nonnull videoPath) {
        NSLog(@"%@",compareResult);
        //compareResult 最后结果数据
        //活体通过检测结果数据
        // 将本地核身的数据信息，发送到服务器端做比对验证，得到最终结果。
    } withFailCallback:^(int errCode, NSString * _Nonnull errMsg) {
        NSLog(@"errCode:%d, errMsg:%@", errCode, errMsg);
    }];
}

#pragma mark - HuiYanPrivateDelegate
- (void)actionCallbackType:(NSString *)actionType {
    NSLog(@"tips*:%@",actionType);
}

- (void)onAuthEvent:(HYAuthEvent)actionEvent {
    NSLog(@"onAuthEvent*:%lu",actionEvent);
}

- (void)onMainViewCreate:(UIView *)authView {
    for (UIView *tmpView in [authView subviews]) {
        NSLog(@"tag:%ld",tmpView.tag);
        NSLog(@"tmpView:%@",tmpView);
        if(tmpView.tag == 100) {
            UIButton *tmpBtn = (UIButton *)tmpView;
            [tmpBtn addTarget:self action:@selector(demoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)onMainViewDestroy {
    //上面所持有的view对象请置空，避免内存泄漏
    NSLog(@"onMainViewDestroy");
}

- (void)demoBtnClick:(UIButton *)sender {
    NSLog(@"user button");
}

- (void)dealloc {
    [HuiYanPrivateApi release];
}


@end
