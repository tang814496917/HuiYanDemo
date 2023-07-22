//
//  HYAudioPlayManager.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/21.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HYAudioPlayManager.h"
#import <AVFoundation/AVFoundation.h> //导入播放声音的框架


@interface HYAudioPlayManager()

@end

@implementation HYAudioPlayManager


+ (instancetype)audioPlayClass
{
    static dispatch_once_t onceToken;
    static HYAudioPlayManager *instance = nil;
    dispatch_once(&onceToken, ^{
        
        instance = [[HYAudioPlayManager alloc] init];
    });
    return instance;
}


-(instancetype)init {
    
    if(self = [super init]){
    }
    return  self;
}






#pragma mark - SET
static SystemSoundID soundID = 0;
-(void)setPlayContentStr:(NSString *)playContentStr {
    AudioServicesDisposeSystemSoundID(soundID);
    NSString *str = [[NSBundle mainBundle] pathForResource:playContentStr ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:str];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
    AudioServicesPlayAlertSoundWithCompletion(soundID, ^{
            NSLog(@"播放完成");
    });

}

@end
