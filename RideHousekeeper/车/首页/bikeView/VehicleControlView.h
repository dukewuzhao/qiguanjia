//
//  VehicleControlView.h
//  RideHousekeeper
//
//  Created by Apple on 2018/2/26.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleControlView : UIView

@property (nonatomic, strong) UIImageView   *bikeLockImge;//车辆上锁/解锁状态
@property (nonatomic, strong) UILabel       *bikeLockLabel;//车辆连接状态显示

@property (nonatomic, strong) UIImageView       *bikeBLEImage;
@property (nonatomic, strong) UILabel       *bikeIsConnectLabel;//车辆蓝牙是否连接

@end
