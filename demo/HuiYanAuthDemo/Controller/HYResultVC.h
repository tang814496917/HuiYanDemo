//
//  HYResultVC.h
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/21.
//  Copyright © 2023 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYResultVC : UIViewController

@property (nonatomic, assign) BOOL isSuccess;

@property (nonatomic, strong) NSArray *actionArray;

@property (nonatomic, copy) void(^reStartCalledBack)(void);

@end

NS_ASSUME_NONNULL_END
