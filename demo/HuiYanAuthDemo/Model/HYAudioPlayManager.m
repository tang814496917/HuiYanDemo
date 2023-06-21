//
//  HYAudioPlayManager.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/21.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HYAudioPlayManager.h"
#import <AVFoundation/AVFoundation.h> //导入播放声音的框架


@interface HYAudioPlayManager()<AVSpeechSynthesizerDelegate>

@property (nonatomic, strong)AVSpeechSynthesizer *avSpeaker;
@property (nonatomic, strong)NSMutableArray *speechStringsArr;//存放要播放的内容
@property (nonatomic, strong)AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong)NSArray *voices;

///
@property (nonatomic, strong)AVPlayerItem *playerItem;//AVPlayer 切换播放源
@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)NSMutableArray *itemQueue;//存放消息数据

@property (nonatomic, assign)NSInteger currentIndex;//播放的数据个数

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
       
        //再选择需要使用的语言zh-CN  en-US
        _voices = @[[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"], [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"]];
        _speechStringsArr = [NSMutableArray array];
        _currentIndex = 0;
    }
    return  self;
}

//将需要播报的文本创建成AVSpeechUtterance对象，并加入播报队列
- (void)beginConversationWith:(AVSpeechUtterance *)utterance {
    
    //将播放的文本
    [self.synthesizer speakUtterance:utterance];
}

#pragma mark - 设置代理

//将要说某段话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
    
    NSLog(@"将要说某段话");
}

//已经开始
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    NSLog(@"已经开始");
}
//已经说完
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{

    NSLog(@"已经说完");
    
    //已经说完情况下移除播放内容
    for (AVSpeechUtterance *item in self.speechStringsArr) {
        
        if ([item isEqual:utterance]) {
            
            [self.speechStringsArr removeObject:item];
            break;
        }
    }
    
    //判断数据是否还存在未播放的数据, 如果存在继续播放
    if (self.speechStringsArr.count > 0) {
        
        //播放第一个数据
        [self  beginConversationWith:self.speechStringsArr.firstObject];
    }
}
//已经暂停
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{

    NSLog(@"已经暂停");
}
//已经继续说话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{

    NSLog(@"已经继续说话");
}
//已经取消说话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{

    NSLog(@"已经取消说话");
}

#pragma mark - GET
-(AVSpeechSynthesizer *)synthesizer {
    
    if (!_synthesizer) {
        
        //初始化语音合成器
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}

#pragma mark - SET
-(void)setPlayContentStr:(NSString *)playContentStr {

    //将播放消息插入数组
    NSLog(@"%@",playContentStr);

    if(playContentStr.length > 0 && playContentStr != nil){
        
        _playContentStr = playContentStr;
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_playContentStr];
         AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithAttributedString:attrStr];
        // 设置语音
        AVSpeechSynthesisVoice *voices = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];

        utterance.voice = voices;
        // 设置速率
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
        // 设置语调
        utterance.pitchMultiplier = 0.8;
        // 设置音量
        utterance.volume = 0.8;
        // 播报前停顿
        utterance.preUtteranceDelay = 0;
        // 播报后停顿
        utterance.postUtteranceDelay = 0.04;
        
        if(self.speechStringsArr.count > 0) {//存在没有播放完的数据

            //插入数组
            [self.speechStringsArr addObject:utterance];
            
        } else {//不存在要播放的数据
            
            [self.speechStringsArr addObject:utterance];
            [self beginConversationWith:utterance];
        }
    }
}
#pragma mark -未使用方法
/**
 
 -(void)pausePlay{//暂停播放
     
     [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
 }

 //继续播放
 -(void)continuePlay {
     
     [self.synthesizer continueSpeaking];
 }

 //停止播放
 -(void)stopPlay {
     
     [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
 }
 **/
@end
