//
//  PrivateLiveDataEntity.h
//  HuiYanSDK
//
//  Created by v_clvchen on 2021/6/2.
//  Copyright © 2021 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 PrivateLiveDataEntity
 */
@interface PrivateLiveDataEntity : NSObject
///活体检测的字符串信息
@property (strong, nonatomic) NSString *liveResult;
///风险等级相关结果
@property (strong, nonatomic) NSString *riskResult;
///客户透传数据
@property (strong, nonatomic) NSString *extraInfo;
@end

NS_ASSUME_NONNULL_END
