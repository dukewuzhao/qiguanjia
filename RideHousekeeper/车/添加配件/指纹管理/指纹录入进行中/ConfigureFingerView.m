//
//  ConfigureFingerView.m
//  TaiwanIntelligence
//
//  Created by Apple on 2018/3/21.
//  Copyright © 2018年 DUKE.Wu. All rights reserved.
//

#import "ConfigureFingerView.h"

@implementation ConfigureFingerView

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
        
        UILabel *PromptLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, ScreenWidth - 40, 20)];
        PromptLab.textAlignment = NSTextAlignmentCenter;
        PromptLab.textColor = [UIColor blackColor];
        PromptLab.text = @"录入指纹";
        PromptLab.font = [UIFont systemFontOfSize:20];
        [self addSubview:PromptLab];
        
        UILabel *operationLab = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(PromptLab.frame)+15, ScreenWidth - 80, 50)];
        operationLab.textAlignment = NSTextAlignmentCenter;
        operationLab.textColor = [UIColor blackColor];
        operationLab.numberOfLines = 0;
        operationLab.text = @"将手指放置在车辆指纹传感器上按压再抬起，重复此操作";
        [self addSubview:operationLab];
    
        _fingerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*.28, CGRectGetMaxY(operationLab.frame)+50, ScreenWidth*.44, ScreenWidth*.44*1.48)];
        _fingerIcon.image = [UIImage imageNamed:@"fingerprint_nomal"];
        [self addSubview:_fingerIcon];
        
    }
    return self;
}



@end
