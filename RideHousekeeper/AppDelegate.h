//
//  AppDelegate.h
//  RideHousekeeper
//
//  Created by 同时科技 on 16/6/20.
//  Copyright © 2016年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "BikeViewController.h"
#import "WYDevice.h"
#import "JPUSHService.h"
#import "ViewController.h"
#import "XYSideViewController.h"
#import "UIViewController+XYSideCategory.h"

static NSString *appKey = @"801964875e8ff89ec5f10a41";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>
{
    BMKMapManager* _mapManager;
}
@property (assign, nonatomic) bool available;

@property (assign, nonatomic) BOOL isPop;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *mainController;
@property (nonatomic,strong)   WYDevice *device;

@property (nonatomic, strong) NSMutableArray *macArrM2;
@property (nonatomic, strong) NSMutableArray *passwordArrM2;
@property (nonatomic, strong)NSString *child2;
@property (nonatomic, strong)NSString *main2;

+ (AppDelegate *)currentAppDelegate;


@end

