//
//  HuiYanCommonUtilApi.h
//  HuiYanSDK
//
//  Created by webertzhang on 2023/7/17.
//  Copyright © 2023 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HuiYanCommonUtilApi : NSObject

/**
 * 打开后置闪光灯
 */
+ (void)turnOnFlash;

/**
 * 关闭后置闪光灯
 */
+ (void)turnOffFlash;

@end

NS_ASSUME_NONNULL_END
