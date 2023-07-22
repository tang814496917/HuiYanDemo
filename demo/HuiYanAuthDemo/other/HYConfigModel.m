//
//  HYConfigModel.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/7/12.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HYConfigModel.h"

@interface HYConfigModel ()

@property (nonatomic, assign) BOOL need_action_video;

@property (nonatomic, assign) BOOL reflect_images_shorten_strategy;

@property (nonatomic, assign) BOOL action_video_shorten_strategy;

@end

@implementation HYConfigModel

- (instancetype)init{
    self = [super init];
    if (self){
            //第一次没数据时  默认数据
            self.actref_ux_mode = 0;
            self.need_action_video = YES;
            self.action_data = @[@1,@2,@3,@4];
            self.action_random = NO;
            self.reflect_images_shorten_strategy = YES;
            self.action_video_shorten_strategy = YES;
            self.mute = NO;
            self.isUseBestFaceImage = YES;
            self.actionTimeoutMs = 15000;
            self.prepareTimeOut = 15000;
            self.restartCount = 5;
            self.isNeverTimeOut = NO;
            self.hostUrl = @"https://biology-port.yz-intelligence.com:9978/";
            self.isDefaultAction = YES;
    }
    return self;
}
@end
