//
//  HYCircleProgressView.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/21.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "HYCircleProgressView.h"

@implementation HYCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupView];
    }
    return self;
}
- (void)setupView{
    CGFloat r = (self.bounds.size.height-15)/2.f;
    for (int i = 0; i < 24; i++) {
        UIView *singleView = [UIView new];
        
        singleView.backgroundColor = [UIColor colorWithRed:217/255.f green:217/255.f blue:217/255.f alpha:1];
        singleView.clipsToBounds = YES;
        singleView.layer.cornerRadius = 3.5;
        singleView.bounds = CGRectMake(0, 0, 7, 15);
        singleView.center = CGPointMake(self.bounds.size.height/2  + sin(i/12.f*M_PI)*r ,self.bounds.size.height/2  - cos(i/12.f*M_PI)*r);
        singleView.transform = CGAffineTransformMakeRotation(i/12.f*M_PI);
        singleView.tag = 300+i;
        [self addSubview:singleView];
    }
}
- (void)setProgress:(CGFloat)progress
{
    if (progress < 0){
        progress = 0;
    }else if (progress > 1){
        progress = 1;
    }
    _progress = progress;
    
    NSInteger count =  roundf(progress*24);
    if (count == 0) return;
    for (int i = 0; i<24; i++) {
        UIView *temp = [self viewWithTag:300+i];
        if (i<=count){
            temp.backgroundColor = [UIColor colorWithRed:7/255.f green:76/255.f blue:228/255.f alpha:1];
        }else{
            temp.backgroundColor = [UIColor colorWithRed:217/255.f green:217/255.f blue:217/255.f alpha:1];
        }
    }
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
