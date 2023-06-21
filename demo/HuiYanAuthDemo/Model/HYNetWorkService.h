//
//  HYNetWorkService.h
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/19.
//  Copyright © 2023 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYNetWorkService : NSObject

+ (void)postAction:(NSString *)action withParams:(NSDictionary *)params  completion:(void(^)(NSDictionary * result, NSError * _Nullable  error))completion;
@end

NS_ASSUME_NONNULL_END
