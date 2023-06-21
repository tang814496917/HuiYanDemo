//
//  HYAudioPlayManager.h
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/21.
//  Copyright © 2023 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYAudioPlayManager : NSObject

+ (instancetype)audioPlayClass;

@property (nonatomic, copy) NSString *playContentStr;//播放内容

//-(void)messageRecived;//开始播放
//
//-(void)stopPlay;//暂停播放
@end

NS_ASSUME_NONNULL_END
