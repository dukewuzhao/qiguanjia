//
//  BikeHeadView.h
//  RideHousekeeper
//
//  Created by Apple on 2018/3/1.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationHintsView.h"
@interface BikeHeadView : UIView{
    CAGradientLayer *gradientLayer;
}

@property (nonatomic, strong) UIImageView    *bikeLogo;//车辆上锁状态显示
@property (nonatomic, strong) UILabel    *bikeBleLab;//车辆上锁状态显示
@property (nonatomic, strong) UIImageView    *bikeBrandImg;//车辆电门状态显示
@property (nonatomic, strong) UIImageView   *bikeStateImg;
@property (nonatomic, strong) InformationHintsView   *tempureView;
@property (nonatomic, strong) InformationHintsView   *voltageView;
@property (nonatomic, assign) BOOL           haveGPS;
@end
