//
//  FingerprintAnimationView.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/21.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "FingerprintAnimationView.h"

@implementation FingerprintAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self addSubview:backview];
        
        UILabel *PromptLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, ScreenWidth - 40, 20)];
        PromptLab.textAlignment = NSTextAlignmentCenter;
        PromptLab.textColor = [UIColor whiteColor];
        PromptLab.text = @"录入指纹";
        PromptLab.font = [UIFont systemFontOfSize:20];
        [backview addSubview:PromptLab];
        
        UILabel *operationLab = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(PromptLab.frame)+15, ScreenWidth - 80, 50)];
        operationLab.textAlignment = NSTextAlignmentCenter;
        operationLab.textColor = [UIColor whiteColor];
        operationLab.numberOfLines = 0;
        operationLab.text = @"将手指放置在车辆指纹传感器上按压再抬起，重复此操作";
        [backview addSubview:operationLab];
        
        UIImageView *fingerarrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.width *.58, CGRectGetMaxY(operationLab.frame)+ScreenHeight * 0.06, self.width*.24, self.width*.024)];
        fingerarrow.image = [UIImage imageNamed:@"Indicator_arrow"];
        [backview addSubview:fingerarrow];
        
        UIImageView *fingerBg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*.2, CGRectGetMaxY(operationLab.frame)+ScreenHeight * 0.06, ScreenWidth*.477, ScreenWidth*.477)];
        fingerBg.image = [UIImage imageNamed:@"fingerprint_animation_bg"];
        [backview addSubview:fingerBg];
        
        UIImageView *fingerIcon = [[UIImageView alloc] init];
        fingerIcon.size = CGSizeMake(ScreenWidth *.2, ScreenWidth *.2);
        fingerIcon.center = fingerBg.center;
        fingerIcon.image = [UIImage imageNamed:@"fingerprint_nomal"];
        [backview addSubview:fingerIcon];
        
        UIImageView *finger = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*.333, CGRectGetMaxY(fingerBg.frame)+25, ScreenWidth*.4, ScreenWidth*.4 *1.8)];
        finger.image = [UIImage imageNamed:@"finger"];
        [backview addSubview:finger];
        
        CAKeyframeAnimation * ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        ani.duration = 3.0;
        ani.removedOnCompletion = NO;
        ani.repeatCount = HUGE_VALF;
        ani.fillMode = kCAFillModeForwards;
        ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        NSValue * value1 = [NSValue valueWithCGPoint:CGPointMake(ScreenWidth*.533, CGRectGetMaxY(fingerBg.frame)+25 +ScreenWidth*.36)];
        NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(ScreenWidth*.533, CGRectGetMaxY(fingerBg.frame)+ScreenWidth*.121)];
        NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(ScreenWidth*.533, CGRectGetMaxY(fingerBg.frame)+25 +ScreenWidth*.36)];
        ani.values = @[value1, value2, value3];
        //ani.delegate = self;
        [finger.layer addAnimation:ani forKey:@"PostionKeyframeValueAni"];
        
        //fingerIcon.image = [UIImage imageNamed:str];
        //定时器开始执行的延时时间
        NSTimeInterval delayTime = 0.0f;
        //定时器间隔时间
        NSTimeInterval timeInterval = 3.0f;
        //创建子线程队列
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //使用之前创建的队列来创建计时器
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        //设置延时执行时间，delayTime为要延时的秒数
        dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
        //设置计时器
        dispatch_source_set_timer(_timer, startDelayTime, timeInterval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_timer, ^{
            
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_enter(group);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [fingerIcon setImage:[UIImage imageNamed:@"fingerprint_press"]];
                //NSLog(@"second API got data1");
                dispatch_group_leave(group);
            });
            dispatch_group_enter(group);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [fingerIcon setImage:[UIImage imageNamed:@"fingerprint_nomal"]];
                //NSLog(@"second API got data2");
                dispatch_group_leave(group);
            });
            
//            dispatch_group_enter(group);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSLog(@"second API got data3");
//                dispatch_group_leave(group);
//            });
//
//            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//                
//            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //[fingerIcon setImage:[UIImage imageNamed:str]];
            }) ;
        });
        // 启动计时器
        dispatch_resume(_timer);
        
        
    }
    return self;
}

@end
