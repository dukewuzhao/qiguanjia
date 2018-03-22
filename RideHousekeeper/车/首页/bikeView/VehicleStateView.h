//
//  VehicleStateView.h
//  RideHousekeeper
//
//  Created by Apple on 2018/2/26.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleStateView : UIView

@property (nonatomic, strong) UIButton   *bikeLockBtn;
@property (nonatomic, strong) UILabel    *bikeLockLabel;//车辆上锁状态显示

@property (nonatomic, strong) UIButton   *bikeSwitchBtn;
@property (nonatomic, strong) UILabel    *bikeSwitchLabel;//车辆电门状态显示

@property (nonatomic, strong) UIButton   *bikeSeatBtn;
@property (nonatomic, strong) UILabel    *bikeSeatLabel;

@property (nonatomic, strong) UIButton   *bikeMuteBtn;
@property (nonatomic, strong) UILabel    *bikeMuteLabel;

@property (nonatomic, copy) void (^ bikeLockBlock)(NSInteger tag);
@property (nonatomic, copy) void (^ bikeSwitchBlock)(NSInteger tag);
@property (nonatomic, copy) void (^ bikeSeatBlock)(NSInteger tag);
@property (nonatomic, copy) void (^ bikeMuteBlock)(NSInteger tag);

-(void)setupFootView:(NSInteger)keyversionvalue;

@end
