//
//  CustomBike.h
//  RideHousekeeper
//
//  Created by Apple on 2018/3/1.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleControlView.h"
#import "VehicleConfigurationView.h"
#import "VehicleStateView.h"
#import "VehiclePositioningMapView.h"
#import "BikeHeadView.h"
//@class VehicleControlView;
//@class VehicleConfigurationView;
//@class VehicleStateView;
//@class VehiclePositioningMapView;
//@class BikeHeadView;

@interface CustomBike : UIView
@property (nonatomic, assign) NSInteger                           bikeid; //车辆内部id
@property (nonatomic, assign) BOOL                                haveGPS;
@property (nonatomic, strong) VehicleControlView                  *vehicleControlView;
@property (nonatomic, strong) VehicleConfigurationView            *vehicleConfigurationView;
@property (nonatomic, strong) VehicleStateView                    *vehicleStateView;
@property (nonatomic, strong) VehiclePositioningMapView           *vehiclePositioningMapView;
@property (nonatomic, strong) BikeHeadView                        *bikeHeadView;

-(void)viewReset;

@end
