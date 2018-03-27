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
    
    [self addSubview:self.tempureView];
    
    [self addSubview:self.voltageView];
}

-(UILabel *)bikeBleLab{
    if (!_bikeBleLab) {
        
        _bikeBleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bikeStateImg.frame)+5, self.bikeStateImg.centerY - 10, 50, 20)];
        _bikeBleLab.textColor = [QFTools colorWithHexString:@"#111111"];
        _bikeBleLab.font = [UIFont systemFontOfSize:15];
    }
    return  _bikeBleLab;
}

- (UIImageView *)bikeStateImg{
    if (!_bikeStateImg) {
        float imgeSize = self.height *.18;
        _bikeStateImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.height - imgeSize - 10, imgeSize, imgeSize)];
        _bikeStateImg.backgroundColor = [QFTools colorWithHexString:MainColor];
        _bikeStateImg.clipsToBounds = YES;
        _bikeStateImg.layer.cornerRadius = _bikeStateImg.width/2;
    }
    return _bikeStateImg;
}

-(UIImageView *)bikeBrandImg{
    
    if (!_bikeBrandImg) {
        _bikeBrandImg = [UIImageView new];
    }
    return _bikeBrandImg;
}

-(InformationHintsView *)tempureView{
    
    if (!_tempureView) {
        _tempureView = [[InformationHintsView alloc] initWithFrame:CGRectMake(self.width - 50, 10, 50, 30)];
        _tempureView.layer.contents = (id)[UIImage imageNamed:@"suspension_bg"].CGImage;
        _tempureView.displayLab.text = @"温度";
        _tempureView.displayImg.image = [UIImage imageNamed:@"bike_temperature"];
    }
    return _tempureView;
}

-(InformationHintsView *)voltageView{
    
    if (!_voltageView) {
        _voltageView = [[InformationHintsView alloc] initWithFrame:CGRectMake(self.width - 50, CGRectGetMaxY(self.tempureView.frame)+5, 50, 30)];
        _voltageView.layer.contents = (id)[UIImage imageNamed:@"suspension_bg"].CGImage;
        _voltageView.displayLab.text = @"电压";
        _voltageView.displayImg.image = [UIImage imageNamed:@"bike_voltage"];
    }
    return _voltageView;
}

- (void)setHaveGPS:(BOOL)haveGPS{
    _haveGPS = haveGPS;
    if (haveGPS) {
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 0.5);
        //gradientLayer.locations = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.5]];
        self.bikeStateImg.hidden = NO;
        self.bikeBrandImg.frame = CGRectMake(ScreenWidth * .265, ScreenHeight *.1, ScreenWidth*.47, ScreenWidth *.47*.7);
        [self addSubview:self.bikeStateImg];
        [self addSubview:self.bikeBleLab];
    }else{
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 0.7);
        gradientLayer.locations = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.7]];
        self.bikeStateImg.hidden = YES;
        self.bikeBrandImg.frame = CGRectMake(ScreenWidth*.192, ScreenHeight *.13, ScreenWidth*.616, ScreenWidth*.616*.7);
        [self.bikeStateImg removeFromSuperview];
        [self.bikeBleLab removeFromSuperview];
        self.bikeStateImg = nil;
        self.bikeBleLab = nil;
        
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
