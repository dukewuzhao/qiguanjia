//
//  BikeHeadView.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/1.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "BikeHeadView.h"

@implementation BikeHeadView

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
        //uiview渐变色
        //初始化CAGradientlayer对象，使它的大小为UIView的大小
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
        [self.layer addSublayer:gradientLayer];
        gradientLayer.locations = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.8]];
        //设置渐变区域的起始和终止位置（范围为0-1）
        //设置颜色数组
        gradientLayer.colors = @[(__bridge id)[QFTools colorWithHexString:MainColor].CGColor,(__bridge id)[QFTools colorWithHexString:@"#c4ede8"].CGColor,(__bridge id)[QFTools colorWithHexString:@"#ebecf2"].CGColor];
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    _bikeLogo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, ScreenWidth *.3, ScreenWidth *.3 *.368)];
    [self addSubview:_bikeLogo];
    
    self.bikeBrandImg.frame = CGRectMake(ScreenWidth*.192, ScreenHeight *.13, ScreenWidth*.616, ScreenWidth*.616*.7);
    [self addSubview:self.bikeBrandImg];
    self.bikeStateImg.backgroundColor = [QFTools colorWithHexString:MainColor];
    self.bikeStateImg.clipsToBounds = YES;
    self.bikeStateImg.layer.cornerRadius = 20.f;
    [self addSubview:self.bikeStateImg];
    self.bikeStateImg.hidden = YES;
    
}

- (UIImageView *)bikeStateImg{
    if (!_bikeStateImg) {
        _bikeStateImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 65, ScreenHeight *.146, 40, 40)];
    }
    return _bikeStateImg;
}

-(UIImageView *)bikeBrandImg{
    
    if (!_bikeBrandImg) {
        _bikeBrandImg = [UIImageView new];
    }
    return _bikeBrandImg;
}

- (void)setHaveGPS:(BOOL)haveGPS{
    _haveGPS = haveGPS;
    if (haveGPS) {
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 0.5);
        //gradientLayer.locations = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.5]];
        self.bikeStateImg.hidden = NO;
        self.bikeBrandImg.frame = CGRectMake(ScreenWidth * .265, ScreenHeight *.1, ScreenWidth*.47, ScreenWidth *.47*.7);
    }else{
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 0.7);
        gradientLayer.locations = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.7]];
        self.bikeStateImg.hidden = YES;
        self.bikeBrandImg.frame = CGRectMake(ScreenWidth*.192, ScreenHeight *.13, ScreenWidth*.616, ScreenWidth*.616*.7);
    }
    [self layoutIfNeeded];
}

-(void)layoutIfNeeded{
    
    
}

//-(void)setFrame:(CGRect)frame{
//
//
//}

@end
