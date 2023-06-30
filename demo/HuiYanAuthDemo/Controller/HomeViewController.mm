//
//  HomeViewController.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/13.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HomeViewController.h"
#import "ParamSettingViewController.h"
#import "Masonry.h"
#import "ViewController.h"
#import <HuiYanSDK/HuiYanPrivateApi.h>
#import <HuiYanSDK/PrivateLiveDataEntity.h>
#import <HuiYanSDK/PrivateCompareResult.h>
#import <HuiYanSDK/PrivateGetConfigResult.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "HYConfigManager.h"
#import "HYNetWorkService.h"
#import "HYToastAlertView.h"
#import "HYCircleProgressView.h"
#import "HYAudioPlayManager.h"
#import "HYResultVC.h"
#import "HYCommonToast.h"
#import "AFNetworkReachabilityManager.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface HomeViewController ()<UITextViewDelegate,UITextFieldDelegate,HuiYanPrivateDelegate> {
    BOOL isHasCameraPermissions;
 
}

@property (nonatomic, assign) HYAuthEvent actionType;

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


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self checkNet];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
       if (granted) {
           NSLog(@"允许访问相机");
           self->isHasCameraPermissions = YES;
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
- (void)setupView
{
    self.title = @"首页";
    self.view.backgroundColor = UIColor.whiteColor;
    NSArray *titleArray = @[@"活体检测",@"参数设置",@"1:1人脸",@"1:N检索"];
    for (int i = 0; i<4; i++) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(16+((SCREEN_WIDTH-44)/2.f+12)*(i%2), 64+90*(i/2), (SCREEN_WIDTH-44)/2.f, 78);
        view.layer.shadowColor = [UIColor colorWithRed:7/255.f green:40/255.f blue:85/255.f alpha:0.06].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,6);
        view.layer.shadowOpacity = 0.6;
        view.clipsToBounds = NO;
        view.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:view];
        view.tag = 100+i;
        [view addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"编组%d",i+1]]];
        imageView.frame = CGRectMake(view.bounds.size.width/2-55, 19, 40, 40);
        imageView.userInteractionEnabled = YES;
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(view.bounds.size.width/2, 28, view.bounds.size.width/2, 22)];
        label.textColor = [UIColor colorWithRed:29/255.0 green:31/255.0 blue:36/255.0 alpha:1/1.0];
        label.font = [UIFont fontWithName:@"PingFangSC" size:16];
        label.text = titleArray[i];
        [view addSubview:label];
    }
    
    UIImageView *bottomLogo = [[UIImageView alloc]init];
    bottomLogo.image = [UIImage imageNamed:@"home_logo"];
    [self.view addSubview:bottomLogo];
    
    [bottomLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 35));
        make.bottom.offset(-65);
    }];
        
    UILabel *bottomTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 17)];
    bottomTitleLab.text = @"腾讯优图，你身边的视觉AI专家";
    bottomTitleLab.textColor = [UIColor colorWithRed:93/255.f green:103/255.f blue:117/255.f alpha:1];
    bottomTitleLab.font = [UIFont systemFontOfSize:16];
    bottomTitleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomTitleLab];
    [bottomTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.height.offset(17);
        make.bottom.offset(-40);
    }];
}
- (void)push:(UIButton *)button{
    switch (button.tag) {
        case 100:
            [self startHuiYanAuth];
            break;
        case 101:
            [self.navigationController pushViewController:[ParamSettingViewController new] animated:YES];
            break;
        case 102:
            
            break;
        case 103:
            
            break;
            
        default:
            break;
    }
}
- (void)startHuiYanAuth {
    if (!isHasCameraPermissions) {
        NSLog(@"用户拒绝访问相机~");
        [HYCommonToast showHudWithText:@"用户拒绝访问相机~"];
        return;
    }
    [self timer];
    [_timer setFireDate:[NSDate distantPast]];
    self.alertCount = 0;
    self.actionType = HY_NONE;
    self.prepareTimeOut = [HYConfigManager shareInstance].prepareTimeOut;
    self.actionTimeoutMs = [HYConfigManager shareInstance].actionTimeoutMs;
    self.actionVerifiedCount = 0;
    self.actionArray = @[];
    
    [HYConfigManager shareInstance].privateConfig.delegate = self;
    [HYConfigManager shareInstance].privateConfig.isUseBestFaceImage = [HYConfigManager shareInstance].isUseBestFaceImage;
    __weak  HomeViewController *weakSelf = self;
    [HuiYanPrivateApi startGetAuthConfigData:[HYConfigManager shareInstance].privateConfig withSuccCallback:^(PrivateGetConfigResult * _Nonnull getConfigResult) {
        [weakSelf getLightDataWith:getConfigResult];
    } withFailCallback:^(int errCode, NSString * _Nonnull errMsg) {
//        [HYCommonToast showHudWithText:[NSString stringWithFormat:@"SDK startGetAuthConfigData errCode:%d, errMsg:%@", errCode, errMsg]];
        NSLog(@"startGetAuthConfigData errCode:%d, errMsg:%@", errCode, errMsg);
    }];
}
- (void)getLightDataWith:(PrivateGetConfigResult *)getConfigResult {
    
    NSMutableDictionary *params = @{
        @"selectData":getConfigResult.selectData?:@"",
        @"envRiskData":getConfigResult.envRiskData?:@"",
        @"requestId":[NSUUID UUID].UUIDString,
    }.mutableCopy;
    if ([HYConfigManager shareInstance].action_data.count != 0) {
        [params setValue:[[HYConfigManager shareInstance] liveConfig] forKey:@"liveConfig"];
    }
    __weak  HomeViewController *weakSelf = self;
    self.prepareTimeOut = [HYConfigManager shareInstance].prepareTimeOut;
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
    __weak  HomeViewController *weakSelf = self;
    [HuiYanPrivateApi startAuthByLiveData:liveDataEntity withSuccCallback:^(PrivateCompareResult * _Nonnull compareResult, NSString * _Nonnull videoPath) {
        //extraInfo 透传
        compareResult.extraInfo = liveDataEntity.extraInfo;
        [weakSelf liveCompare:compareResult];
    } withFailCallback:^(int errCode, NSString * _Nonnull errMsg) {
        NSLog(@"errCode:%d, errMsg:%@", errCode, errMsg);
//        [HYCommonToast showHudWithText:[NSString stringWithFormat:@"SDK errCode:%d, errMsg:%@", errCode, errMsg]];
    }];
}
- (void)liveCompare:(PrivateCompareResult *)compareResult{
    NSDictionary *params = @{
        @"platform":@(compareResult.platform),
        @"extraInfo":compareResult.extraInfo?:@"",
        @"sign":compareResult.sign?:@"",
        @"liveData":compareResult.liveData?:@"",
        @"requestId":[NSUUID UUID].UUIDString,
    };
    __weak  HomeViewController *weakSelf = self;
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
        HYResultVC *vc = [[HYResultVC alloc]init];
        vc.isSuccess = success;
        NSDictionary *infoDic = @{
            @"0":@"眨眼",
            @"1":@"眨眼",
            @"2":@"张嘴",
            @"3":@"点头",
            @"4":@"摇头",
            @"5":@"正脸",
        };
        if (success){
            NSMutableArray *actionStrArr = [NSMutableArray array];
            [self.actionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([infoDic valueForKey:obj]){
                    [actionStrArr addObject:[infoDic valueForKey:obj]];
                }
            }];
            vc.actionArray = actionStrArr.copy;
        }
        __weak  HomeViewController *weakSelf = self;
        vc.reStartCalledBack = ^{
            [weakSelf startHuiYanAuth];
        };
        [self.navigationController pushViewController:vc animated:YES];
    });
}
- (void)timeTick{
    if ((self.actionType == HY_NONE)) {
        if (self.prepareTimeOut <= 0){
            [self showAlertViewWithType:0];
        }else{
            self.prepareTimeOut = self.prepareTimeOut - 1000;
        }
        self.timeOutLab.text = [NSString stringWithFormat:@"%lds",self.prepareTimeOut/1000];
    }else if (self.actionType == HY_OPEN_MOUTH_CHECK || self.actionType == HY_BLINK_CHECK || self.actionType == HY_NOD_HEAD_CHECK || self.actionType == HY_SHAKE_HEAD_CHECK){
        if (self.actionTimeoutMs <= 0){
            [self showAlertViewWithType:1];
        }else{
            self.actionTimeoutMs = self.actionTimeoutMs - 1000;
        }
        self.timeOutLab.text = [NSString stringWithFormat:@"%lds",self.actionTimeoutMs/1000];
    }else{
        self.timeOutLab.text = @"";
    }
}
- (void)showAlertViewWithType:(NSInteger )type{
    if ([HYToastAlertView isShowing]) return;
    __weak HomeViewController *weakSelf = self;
    self.timeOutLab.hidden = YES;
    self.alertCount ++;
    if (self.alertCount>=[HYConfigManager shareInstance].restartCount) {
        [self jumpResult:NO];
        return;
    }
        [HYToastAlertView showAlertViewWithbuttonClickedBlock:^(NSInteger index) {
            weakSelf.timeOutLab.hidden = NO;
            if (index == 0) {
                if (weakSelf.cancelBtn){
                    [weakSelf.cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }else{
                if (weakSelf.alertCount >= [HYConfigManager shareInstance].restartCount){
                    if (weakSelf.cancelBtn){
                        [weakSelf.cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }else{
                    if (type == 0) {
                        weakSelf.prepareTimeOut = [HYConfigManager shareInstance].prepareTimeOut;
                    }else{
                        weakSelf.actionTimeoutMs = [HYConfigManager shareInstance].actionTimeoutMs;
                    }
                }
            }
        }];
}
- (void)playVoice:(NSString *)str{
    
    if (![HYConfigManager shareInstance].isNotMute) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HYAudioPlayManager audioPlayClass].playContentStr = str;
    });
}
#pragma mark - HuiYanPrivateDelegate
- (void)actionCallbackType:(HYAuthTipsEvent)actionType {
    NSString *tips = [[HYConfigManager shareInstance] tipsWithEvent:actionType];
    if (tips) {
        self.tipsLab.text = tips;
    }
}

- (void)onAuthEvent:(HYAuthEvent)actionEvent {
    NSArray *animationImages = @[[UIImage imageNamed:@"正脸"],[UIImage imageNamed:@"正脸"]];
    switch (actionEvent) {
        case HY_OPEN_MOUTH_CHECK:
            [self playVoice:@"请张嘴"];
            animationImages = @[[UIImage imageNamed:@"正脸"],[UIImage imageNamed:@"张嘴"]];
            break;
        case HY_BLINK_CHECK:
            [self playVoice:@"请眨眼"];
            animationImages = @[[UIImage imageNamed:@"正脸"],[UIImage imageNamed:@"眨眼"]];
            break;
        case HY_NOD_HEAD_CHECK:
            [self playVoice:@"请点点头"];
            animationImages = @[[UIImage imageNamed:@"正脸"],[UIImage imageNamed:@"点头"]];
            break;
        case HY_SHAKE_HEAD_CHECK:
            [self playVoice:@"请摇摇头"];
            animationImages = @[[UIImage imageNamed:@"左"],[UIImage imageNamed:@"右"]];
            break;
        case HY_SILENCEN_CHECK:
            animationImages = @[[UIImage imageNamed:@"正脸"],[UIImage imageNamed:@"正脸"]];
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
    self.actionType = actionEvent;
    if (self.actionType == HY_OPEN_MOUTH_CHECK || self.actionType == HY_BLINK_CHECK || self.actionType == HY_NOD_HEAD_CHECK || self.actionType == HY_SHAKE_HEAD_CHECK || self.actionType == HY_REFLECT_CHECK){
        CGFloat actionCount = self.actionArray.count;
        if (actionCount<=0) actionCount = 1;
        self.circleView.progress = self.actionVerifiedCount/actionCount;
        self.actionVerifiedCount ++;
        self.actionTimeoutMs = [HYConfigManager shareInstance].actionTimeoutMs;
        if (self.actionVerifiedCount<=1) return;
        if (![HYConfigManager shareInstance].isNotMute) return;
        [HYAudioPlayManager audioPlayClass].playContentStr = @"BG";
    }
}
- (void)onMainViewCreate:(UIView *)authView {
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
            self.muteBtn.selected = ![HYConfigManager shareInstance].isNotMute;
        }else if (tmpView.tag == 10003){
            self.imageView = (UIImageView *)tmpView;
        }else if (tmpView.tag == 10004){
            self.timeOutLab = (UILabel *)tmpView;
        }else if (tmpView.tag == 10005){
            tmpView.backgroundColor = UIColor.clearColor;
            self.circleView = [[HYCircleProgressView alloc]initWithFrame:CGRectMake(0, 0, 278, 278)];
            self.circleView.progress = 0;
            [tmpView addSubview:self.circleView];
        }else if (tmpView.tag == 10006){
            self.tipsLab = (UILabel *)tmpView;
        }
    }
}

- (void)onMainViewDestroy {
    self.cancelBtn = nil;
    self.closeBtn = nil;
    self.muteBtn = nil;
    self.imageView = nil;
    self.timeOutLab = nil;
    self.circleView = nil;
    [_timer invalidate];
    _timer = nil;
    self.prepareTimeOut = [HYConfigManager shareInstance].prepareTimeOut;
    self.actionTimeoutMs = [HYConfigManager shareInstance].actionTimeoutMs;
}

- (void)closeBtnClick:(UIButton *)sender {
    if (self.cancelBtn){
        [self.cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)mute:(UIButton *)button{
    button.selected = !button.selected;
    [HYConfigManager shareInstance].isNotMute = !button.selected;
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
- (void)checkNet{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                [HYCommonToast showHudWithText:@"网络出错"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
        }
    }];

    //开始监控
    [manager startMonitoring];
}
@end
