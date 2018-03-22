//
//  GPSHeadView.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/13.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "GPSHeadView.h"

@implementation GPSHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.width*.207, 15, self.width *.586, self.height*.7)];
    bgImg.image = [UIImage imageNamed:@"gps_headbg@2x"];
    [self addSubview:bgImg];
    
    _gpsImageView = [YYAnimatedImageView new] ;
    _gpsImageView.autoPlayAnimatedImage = NO;
    _gpsImageView.size = CGSizeMake(bgImg.width*.9, bgImg.width*.9);
    _gpsImageView.centerX  = bgImg.centerX;
    _gpsImageView.y = bgImg.height*.15;
    [self addSubview:_gpsImageView];
    
    _promptLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(bgImg.frame)+self.height*.027, self.width - 40, 20)];
    _promptLab.textAlignment = NSTextAlignmentCenter;
    _promptLab.textColor = [UIColor whiteColor];
    _promptLab.text = @"扫描二维码完成";
    [self addSubview:_promptLab];
}

@end
