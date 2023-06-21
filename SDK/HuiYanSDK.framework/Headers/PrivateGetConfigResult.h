//
//  DeviceInfo.h
//  HuiYanSDK
//
//  Created by v_clvchen on 2021/6/2.
//  Copyright © 2021 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 PrivateGetConfigResult
 */
@interface PrivateGetConfigResult : NSObject

///设备信息
@property (strong, nonatomic) NSString *selectData;
///环境风险
@property (strong, nonatomic) NSString *envRiskData;

@end

NS_ASSUME_NONNULL_END
