//
//  VehiclePositionViewController.h
//  RideHousekeeper
//
//  Created by Apple on 2018/3/8.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface VehiclePositionViewController : BaseViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>
    
@property(nonatomic,strong)BMKMapView* mapView;
@property(nonatomic,strong)BMKLocationService* locationService;
@end
