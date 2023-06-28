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

@property (nonatomic, strong) AVAudioPlayer *movePlayer;

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
-(void)setPlayContentStr:(NSString *)playContentStr {

    NSURL *url = [[NSBundle mainBundle] URLForResource:playContentStr withExtension:@"mp3"];
    NSError *err;
    self.movePlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    self.movePlayer.volume = 1.0;
    [self.movePlayer prepareToPlay];
    if(err!=nil) {
        NSLog(@"move player init error:%@",err);
    }else{
        [self.movePlayer play];
    }
}

@end
