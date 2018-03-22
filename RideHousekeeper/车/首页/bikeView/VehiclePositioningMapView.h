//
//  VehiclePositioningMapView.h
//  RideHousekeeper
//
//  Created by Apple on 2018/2/27.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface VehiclePositioningMapView : UIView<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) UILabel    *locationLab;
@property (nonatomic, strong) UILabel    *timeLab;
@property (nonatomic, strong) UIView     *maskView;
@property (nonatomic, strong) BMKPointAnnotation *annotation;
@property (nonatomic, copy) void (^ bikeMapClickBlock)();

@end
