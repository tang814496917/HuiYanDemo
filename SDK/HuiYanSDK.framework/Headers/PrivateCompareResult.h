//
//  PrivateCompareResult.h
//  HuiYanSDK
//
//  Created by v_clvchen on 2021/6/2.
//  Copyright © 2021 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 PrivateCompareResult
 */
@interface PrivateCompareResult : NSObject

///系统 1.iOS 2. Android
@property (nonatomic, assign) int platform;
///客户透传数据
@property (strong, nonatomic) NSString *extraInfo;
///加密MD5值 透传
@property (strong, nonatomic) NSString *sign;
///base64 活体检测数据
@property (strong, nonatomic) NSString *liveData;

//非加密活体数据
@property (strong, nonatomic) NSString *unEncryptLiveData;
//需要加密最佳桢
@property int need_encrypted_best_img;
///base64 longCheckBestImage
@property (strong, nonatomic) NSString *longCheckBestImage;

@end

NS_ASSUME_NONNULL_END
