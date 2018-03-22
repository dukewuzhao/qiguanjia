//
//  GPSPaopaoView.m
//  RideHousekeeper
//
//  Created by 吴兆华 on 2018/3/11.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "GPSPaopaoView.h"

@implementation GPSPaopaoView

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
    
    self.backgroundColor = [UIColor whiteColor];
    self.locationTime.frame = CGRectMake(10, 15, self.width - 10, 15);
    self.locationTime.font = [UIFont systemFontOfSize:15];
    self.locationTime.textColor = [UIColor blackColor];
    self.locationTime.text = @"车辆最后定位时间：今天14:45";
    [self addSubview:self.locationTime];
    
    self.locationAddress.frame = CGRectMake(10, CGRectGetMaxY(self.locationTime.frame) + 2, self.width - 10, 15);
    self.locationAddress.font = [UIFont systemFontOfSize:15];
    self.locationAddress.textColor = [UIColor blackColor];
    self.locationAddress.text = @"位置：上海市徐汇区桂平路481号";
    [self addSubview:self.locationAddress];
    
    UILabel * instructionLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.locationAddress.frame)+20, 65, 15)];
    instructionLab.textColor = [UIColor blackColor];
    instructionLab.text = @"信号强度:";
    instructionLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:instructionLab];
    
    UIImageView *gps = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(instructionLab.frame)+5, CGRectGetMaxY(self.locationAddress.frame)+10, 25, 25)];
    gps.image = [UIImage imageNamed:@"GPS"];
    [self addSubview:gps];
    
    UILabel * gpsLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gps.frame)+2, instructionLab.y, 25, 15)];
    gpsLab.textColor = [UIColor blackColor];
    gpsLab.text = @"GPS";
    gpsLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:gpsLab];
    
    self.gpsImg.frame = CGRectMake(CGRectGetMaxX(gpsLab.frame) + 2, gps.y + 10, 20, 15);
    self.gpsImg.image = [UIImage imageNamed:@"signal_intensity"];
    [self addSubview:self.gpsImg];
    
    UIImageView *gsm = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gpsImg.frame)+5, gps.y, 25, 25)];
    gsm.image = [UIImage imageNamed:@"GMS"];
    [self addSubview:gsm];
    
    UILabel * gsmLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gsm.frame)+2, instructionLab.y, 30, 15)];
    gsmLab.textColor = [UIColor blackColor];
    gsmLab.text = @"GSM";
    gsmLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:gsmLab];
    
    self.gsmImg.frame = CGRectMake(CGRectGetMaxX(gsmLab.frame) + 2, gps.y + 10, 20, 15);
    self.gsmImg.image = [UIImage imageNamed:@"signal_intensity"];
    [self addSubview:self.gsmImg];
    
    UIButton *navigationBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gsmImg.frame)+10, gps.y+ 5, 45, 20)];
    navigationBtn.backgroundColor = [QFTools colorWithHexString:MainColor];
    [navigationBtn setTitle:@"导航" forState:UIControlStateNormal];
    [navigationBtn setImage:[UIImage imageNamed:@"navigation _arrow"] forState:UIControlStateNormal];
    navigationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:navigationBtn];
    
}

//画出尖尖
- (void)drawRect:(CGRect)rect {
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    
    CGFloat startX = self.width/2 -5;
    CGFloat startY = self.height;
    CGContextMoveToPoint(context, startX, startY);//设置起点
    
    CGContextAddLineToPoint(context, startX + 5, startY + 5);
    
    CGContextAddLineToPoint(context, startX + 10, startY);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor blackColor] setFill]; //设置填充色
    [[UIColor blackColor] setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
}

-(UILabel *)locationTime{
    
    if (!_locationTime) {
        _locationTime = [UILabel new];
        
    }
    return _locationTime;
}

-(UILabel *)locationAddress{
    
    if (!_locationAddress) {
        _locationAddress = [UILabel new];
        
    }
    return _locationAddress;
}

-(UIImageView *)gpsImg{
    
    if (!_gpsImg) {
        _gpsImg = [UIImageView new];
        
    }
    return _gpsImg;
}

-(UIImageView *)gsmImg{
    
    if (!_gsmImg) {
        _gsmImg = [UIImageView new];
        
    }
    return _gsmImg;
}

-(UIView *)headView{
    
    if (!_headView) {
        _headView = [UIView new];
        
    }
    return _headView;
}



@end
