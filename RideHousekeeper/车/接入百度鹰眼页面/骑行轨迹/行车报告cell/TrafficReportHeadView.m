//
//  TrafficReportHeadView.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/12.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "TrafficReportHeadView.h"

@implementation TrafficReportHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 1, 60)];
    line.backgroundColor = [UIColor blackColor];
    [self addSubview:line];
    
    _instructionImg = [[UIImageView alloc] initWithFrame:CGRectMake(line.x - 7.5, 17.5, 15, 15)];
    _instructionImg.image = [UIImage imageNamed:@"big_dot"];
    [self addSubview:_instructionImg];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(62.5, 0, ScreenWidth - 62.5, 50)];
    _mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainView];
    
    _monthLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12.5, 30, 25)];
    _monthLab.text = @"06";
    _monthLab.textColor = [UIColor blackColor];
    _monthLab.font = [UIFont systemFontOfSize:20];
    _monthLab.textAlignment = NSTextAlignmentCenter;
    [_mainView addSubview:_monthLab];
    
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_monthLab.frame), 15, 30, 20)];
    _dateLab.textColor = [QFTools colorWithHexString:@"#666666"];
    _dateLab.text = @"六月";
    _dateLab.font = [UIFont systemFontOfSize:14];
    _dateLab.textAlignment = NSTextAlignmentCenter;
    [_mainView addSubview:_dateLab];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateLab.frame)+5, 10, 1, _mainView.height - 20)];
    line2.backgroundColor = [UIColor blackColor];
    [_mainView addSubview:line2];
    
    _mileageLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line2.frame)+10, _mainView.height/2 - 20, 50, 15)];
    _mileageLab.textColor = [QFTools colorWithHexString:MainColor];
    _mileageLab.font = [UIFont systemFontOfSize:13];
    _mileageLab.text = @"39.5km";
    _mileageLab.textAlignment = NSTextAlignmentCenter;
    [_mainView addSubview:_mileageLab];
    
    UIImageView *mileageImg = [[UIImageView alloc] initWithFrame:CGRectMake(_mileageLab.x, _mainView.height/2 + 5, 15, 15)];
    mileageImg.image  = [UIImage imageNamed:@"bike_mileage"];
    [_mainView addSubview:mileageImg];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mileageImg.frame), mileageImg.y, 30, 15)];
    lab.textColor = [UIColor blackColor];
    lab.text = @"里程";
    lab.font = [UIFont systemFontOfSize:14];
    [_mainView addSubview:lab];
    
    _noticeTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mileageLab.frame) + _mainView.width *.04, _mileageLab.y, 40, 15)];
    _noticeTimeLab.textColor = [QFTools colorWithHexString:MainColor];
    _noticeTimeLab.font = [UIFont systemFontOfSize:13];
    _noticeTimeLab.text = @"43次";
    _noticeTimeLab.textAlignment = NSTextAlignmentCenter;
    [_mainView addSubview:_noticeTimeLab];
    
    UIImageView *noticeTimeImg = [[UIImageView alloc] initWithFrame:CGRectMake(_noticeTimeLab.x+ _noticeTimeLab.width/2 - 15, mileageImg.y, 15, 15)];
    noticeTimeImg.image = [UIImage imageNamed:@"bike_notice"];
    [_mainView addSubview:noticeTimeImg];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(noticeTimeImg.frame), mileageImg.y, 30, 15)];
    lab2.textColor = [UIColor blackColor];
    lab2.text = @"警告";
    lab2.font = [UIFont systemFontOfSize:14];
    [_mainView addSubview:lab2];
    
    _speedLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_noticeTimeLab.frame) + _mainView.width *.04, _mileageLab.y, 70, 15)];
    _speedLab.textColor = [QFTools colorWithHexString:MainColor];
    _speedLab.font = [UIFont systemFontOfSize:13];
    _speedLab.text = @"17.4km/h";
    _speedLab.textAlignment = NSTextAlignmentCenter;
    [_mainView addSubview:_speedLab];
    
    UIImageView *speedImg = [[UIImageView alloc] initWithFrame:CGRectMake(_speedLab.centerX - 15, mileageImg.y, 15, 15)];
    speedImg.image = [UIImage imageNamed:@"bike_speed"];
    [_mainView addSubview:speedImg];
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(speedImg.frame), mileageImg.y, 30, 15)];
    lab3.textColor = [UIColor blackColor];
    lab3.text = @"车速";
    lab3.font = [UIFont systemFontOfSize:14];
    [_mainView addSubview:lab3];
    
//    _arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(_mainView.width - 35,_mainView.height/2 - 6 , 15, 12)];
//    _arrowImg.image = [UIImage imageNamed:@"icon_down"];
//    [_mainView addSubview:_arrowImg];
}

@end
