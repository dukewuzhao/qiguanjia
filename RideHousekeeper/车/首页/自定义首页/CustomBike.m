//
//  CustomBike.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/1.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "CustomBike.h"

@implementation CustomBike

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
    
    self.bikeHeadView.bikeBrandImg.image = [UIImage imageNamed:@"icon_default_model"];
    self.bikeHeadView.bikeLogo.image = [UIImage imageNamed:@"brand_logo"];
    self.bikeHeadView.bikeStateImg.image = [UIImage imageNamed:@"lock_gps"];
    [self addSubview:self.bikeHeadView];
    self.vehicleControlView.bikeLockImge.image = [UIImage imageNamed:@"lock"];
    self.vehicleControlView.bikeLockLabel.text = @"已关锁";
    self.vehicleControlView.bikeBLEImage.image = [UIImage imageNamed:@"vehicle_physical_examination_icon"];
    self.vehicleControlView.bikeIsConnectLabel.text = @"未连接";
    [self addSubview:self.vehicleControlView];
    self.vehicleConfigurationView.bikeTestImge.image = [UIImage imageNamed:@"vehicle_physical_examination"];
    self.vehicleConfigurationView.bikeTestLabel.text = @"车辆体检";
    self.vehicleConfigurationView.bikeTemperatureLabel.text = @"温度";
    self.vehicleConfigurationView.bikeVoltageLabel.text = @"电压";
    self.vehicleConfigurationView.bikeSetUpImge.image = [UIImage imageNamed:@"vehicle_setting"];
    self.vehicleConfigurationView.bikeSetUpLabel.text = @"车辆设置";
    self.vehicleConfigurationView.bikeSetUpDescribeLabel.text = @"智能电动车";
    self.vehicleConfigurationView.bikePartsManageImge.image = [UIImage imageNamed:@"spare_parts_management"];
    self.vehicleConfigurationView.bikePartsManageLabel.text = @"配件管理";
    self.vehicleConfigurationView.bikePartsManagDescribeLabel.text = @"设备随心配置";
    [self addSubview:self.vehicleConfigurationView];
    [self addSubview:self.vehicleStateView];
    
}

-(VehicleControlView *)vehicleControlView{
    
    if (!_vehicleControlView) {
        _vehicleControlView = [[VehicleControlView alloc] initWithFrame: CGRectMake( 0, CGRectGetMaxY(self.bikeHeadView.frame)+ 2, ScreenWidth, ScreenHeight *.09)];
//        _vehicleControlView.layer.masksToBounds = YES;
//        _vehicleControlView.layer.cornerRadius = 10;
    }
    return _vehicleControlView;
}

-(VehicleConfigurationView *)vehicleConfigurationView{
    
    if (!_vehicleConfigurationView) {
        float heighty = ( ScreenHeight * .805 - navHeight - CGRectGetMaxY(self.vehicleControlView.frame) - ScreenHeight *.168)/2;
        _vehicleConfigurationView = [[VehicleConfigurationView alloc] initWithFrame: CGRectMake(15, CGRectGetMaxY(self.vehicleControlView.frame)+heighty, ScreenWidth - 30, ScreenHeight *.168)];
        _vehicleConfigurationView.layer.masksToBounds = YES;
        _vehicleConfigurationView.layer.cornerRadius = 10;
    }
    return _vehicleConfigurationView;
}

-(VehicleStateView *)vehicleStateView{
    
    if (!_vehicleStateView) {
        _vehicleStateView = [[VehicleStateView alloc] initWithFrame: CGRectMake(15, ScreenHeight * .805 - navHeight, ScreenWidth - 30, ScreenHeight *.165)];
        _vehicleStateView.layer.masksToBounds = YES;
        _vehicleStateView.layer.cornerRadius = 10;
    }
    return _vehicleStateView;
}


-(VehiclePositioningMapView *)vehiclePositioningMapView{
    
    if (!_vehiclePositioningMapView) {
        
        _vehiclePositioningMapView = [[VehiclePositioningMapView alloc] initWithFrame: CGRectMake(15, CGRectGetMaxY(self.bikeHeadView.frame)+ 5, ScreenWidth - 30, ScreenHeight *.225)];
        //_vehiclePositioningMapView.layer.masksToBounds = YES;
        _vehiclePositioningMapView.layer.cornerRadius = 10;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_vehiclePositioningMapView.bounds];
        _vehiclePositioningMapView.layer.shadowColor = [UIColor blackColor].CGColor;
        _vehiclePositioningMapView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        _vehiclePositioningMapView.layer.shadowOpacity = 0.15f;
        _vehiclePositioningMapView.layer.shadowRadius = 5.0f;
        _vehiclePositioningMapView.layer.shadowPath = shadowPath.CGPath;
    }
    return _vehiclePositioningMapView;
}

-(BikeHeadView *)bikeHeadView{
    
    if (!_bikeHeadView) {
        _bikeHeadView = [[BikeHeadView alloc] initWithFrame:CGRectMake( 0, 0, ScreenWidth, ScreenHeight * .4) ];
    }
    return _bikeHeadView;
}

- (void)setHaveGPS:(BOOL)haveGPS{
    _haveGPS = haveGPS;
    if (haveGPS) {
        
        self.bikeHeadView.frame = CGRectMake( 0, 0, ScreenWidth, ScreenHeight * .312);
        self.vehiclePositioningMapView.locationLab.text = @"徐汇区桂平路桂中园";
        self.vehiclePositioningMapView.timeLab.text = @"2分钟前";
        [self addSubview:self.vehiclePositioningMapView];
        float heighty = ( ScreenHeight * .805 - navHeight - CGRectGetMaxY(self.vehiclePositioningMapView.frame) - ScreenHeight *.128)/2;
        self.vehicleConfigurationView.frame = CGRectMake(15,  CGRectGetMaxY(self.vehiclePositioningMapView.frame) + heighty, ScreenWidth - 30, ScreenHeight *.128);
        self.vehicleConfigurationView.bikeTestImge.image = [UIImage imageNamed:@"vehicle_physical_examination_icon"];
        self.vehicleConfigurationView.bikeTestLabel.text = @"未连接";
        self.vehicleConfigurationView.bikeTestLabel.textColor = [UIColor redColor];
        [self.vehicleControlView removeFromSuperview];
        self.vehicleControlView = nil;
        self.bikeHeadView.haveGPS = YES;
        self.vehicleConfigurationView.haveGPS = YES;
        
    }else{
        
        self.bikeHeadView.frame = CGRectMake( 0, 0, ScreenWidth, ScreenHeight * .4);
        self.vehicleControlView.frame = CGRectMake( 0, CGRectGetMaxY(self.bikeHeadView.frame)+2, ScreenWidth, ScreenHeight *.09);
        self.vehicleControlView.bikeBLEImage.image = [UIImage imageNamed:@"lock"];
        self.vehicleControlView.bikeLockLabel.text = @"已关锁";
        self.vehicleControlView.bikeLockImge.image = [UIImage imageNamed:@"vehicle_physical_examination_icon"];
        self.vehicleControlView.bikeIsConnectLabel.text = @"未连接";
        [self addSubview:self.vehicleControlView];
        float heighty = ( ScreenHeight * .805 - navHeight - CGRectGetMaxY(self.vehicleControlView.frame) - ScreenHeight *.168)/2;
        self.vehicleConfigurationView.frame = CGRectMake(15, CGRectGetMaxY(self.vehicleControlView.frame)+heighty, ScreenWidth - 30, ScreenHeight *.168);
        self.vehicleConfigurationView.bikeTestImge.image = [UIImage imageNamed:@"vehicle_physical_examination"];
        self.vehicleConfigurationView.bikeTestLabel.text = @"车辆体检";
        self.vehicleConfigurationView.bikeTestLabel.textColor = [UIColor blackColor];
        [self.vehiclePositioningMapView removeFromSuperview];
        self.vehiclePositioningMapView = nil;
        self.bikeHeadView.haveGPS = NO;
        self.vehicleConfigurationView.haveGPS = NO;
    }
    [self layoutIfNeeded];
}

-(void)viewReset{
    if (self.haveGPS) {
        self.vehicleConfigurationView.bikeTestLabel.text = @"未连接";
        self.vehicleConfigurationView.bikeTestLabel.textColor = [UIColor redColor];
        self.vehicleConfigurationView.bikeTestImge.image = [UIImage imageNamed:@"vehicle_physical_examination_icon"];
    }else{
        self.vehicleControlView.bikeIsConnectLabel.text = @"未连接";
        self.vehicleControlView.bikeIsConnectLabel.textColor = [UIColor redColor];
        self.vehicleConfigurationView.bikeTestImge.image = [UIImage imageNamed:@"vehicle_physical_examination"];
    }
    self.vehicleConfigurationView.bikeTemperatureLabel.text = @"温度";
    self.vehicleConfigurationView.bikeVoltageLabel.text = @"电压";
}

-(void)dealloc{
    
    NSLog(@"释放了");
}

@end
