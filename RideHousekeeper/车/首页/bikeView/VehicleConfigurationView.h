//
//  VehicleConfigurationView.h
//  RideHousekeeper
//
//  Created by Apple on 2018/2/26.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleConfigurationView : UIView

@property (nonatomic, strong) UIImageView   *bikeTestImge;
@property (nonatomic, strong) UILabel       *bikeTestLabel;//车辆连接状态显示

@property (nonatomic, strong) UILabel       *bikeTemperatureLabel;//车辆温度
@property (nonatomic, strong) UILabel       *bikeVoltageLabel;//车辆电压

@property (nonatomic, strong) UIImageView   *bikeSetUpImge;//车辆设置图片
@property (nonatomic, strong) UILabel       *bikeSetUpLabel;//车辆设置
@property (nonatomic, strong) UILabel       *bikeSetUpDescribeLabel;//车辆设置描述

@property (nonatomic, strong) UIImageView   *bikePartsManageImge;//配件管理图片
@property (nonatomic, strong) UILabel       *bikePartsManageLabel;//配件管理
@property (nonatomic, strong) UILabel       *bikePartsManagDescribeLabel;//配件管理描述

@property (nonatomic, strong) UIView       *clickView;

@property (nonatomic, assign) BOOL          haveGPS;

@property (nonatomic, copy) void (^ bikeTestClickBlock)();
@property (nonatomic, copy) void (^ bikeSetUpClickBlock)();
@property (nonatomic, copy) void (^ bikePartsManagClickBlock)();

@end
