//
//  HYAuthApi.h
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/7/12.
//  Copyright © 2023 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HYAuthApi : NSObject

/**
 * 活体核身成功回调
 *
 * @param reportData 上报数据
 */
typedef void (^HYResultSuccCallback)(NSDictionary *reportData);
/**
 * 活体核身失败回调
 *
 * @param errCode 错误码
 * @param errMsg 错误信息
 */
typedef void (^HYResultFailCallback)(int errCode, NSString * _Nonnull errMsg);

/**
 * 开始活体验证
 *
 * @param HYConfigModel  配置项
 * @param HYResultSuccCallback 验证成功，数据回调
 * @param HYResultFailCallback 验证失败回调
 */
+ (void)startAuth:(HYConfigModel *)model
         withSuccCallback:(HYResultSuccCallback)hYResultSuccCallback
         withFailCallback:(HYResultFailCallback)hYResultFailCallback;

@end

NS_ASSUME_NONNULL_END
