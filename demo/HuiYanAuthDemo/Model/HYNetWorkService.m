//
//  HYNetWorkService.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/19.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HYNetWorkService.h"
#import "AFNetworking.h"
#import "HYConfigManager.h"
@implementation HYNetWorkService
+ (void)postAction:(NSString *)action withParams:(NSDictionary *)params  completion:(void(^)(NSDictionary * result, NSError * _Nullable  errorStr))completion{
    
    AFHTTPSessionManager *manager = [self manager];

    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSError *requestError = nil;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",[HYConfigManager shareInstance].hostUrl,action] parameters:nil error:&requestError];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [manager.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *result = @{};
        if(error){
            
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions error:nil];
            result = dict;
        }
        if(completion){
            completion(result,error);
        }
    }];
    [dataTask resume];
}
+ (AFHTTPSessionManager *)manager {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:10];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8"
                      forHTTPHeaderField:@"content-type"];
        [manager.responseSerializer setAcceptableContentTypes:
        [NSSet setWithObjects:@"application/json", @"text/json", nil]];
    return manager;
}
@end
