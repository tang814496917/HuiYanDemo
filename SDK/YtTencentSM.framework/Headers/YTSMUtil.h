//
//  YTSMUtil.h
//  YtTencentSM
//
//  Created by sunnydu on 2022/7/26.
//  Copyright © 2022 Tecnet.Youtu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTSMUtil : NSObject
- (NSString *)generateSMEncReq:(NSDictionary*)data;
- (NSString *)generateSMEncReq:(NSString *)requestContent appid:(NSString *)appId sessionid:(NSString *)sessionId config:(NSString *)config;
@end

NS_ASSUME_NONNULL_END
