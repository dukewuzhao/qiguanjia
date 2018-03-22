//
//  VehiclePositionViewController.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/8.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "VehiclePositionViewController.h"
#import "VehicleTrajectoryViewController.h"
#import "GPSPaopaoView.h"

@interface VehiclePositionViewController ()
@property(nonatomic,strong) BMKPointAnnotation* bikeAnnotation;
@property (nonatomic, strong) BMKPointAnnotation *annotation;//当前定位的位置
@end

@implementation VehiclePositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavView];
    [self.view addSubview:self.mapView];
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(ScreenWidth - 45, ScreenHeight-navHeight - 50, 35, 35);
    [locationBtn setImage:[UIImage imageNamed:@"bike_location"] forState:UIControlStateNormal];
    locationBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    
    
    UIButton *enlarge = [UIButton buttonWithType:UIButtonTypeCustom];
    enlarge.frame = CGRectMake(ScreenWidth - 45, ScreenHeight-navHeight - 150, 35, 35);
    enlarge.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [enlarge addTarget:self action:@selector(enlargeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enlarge];
    
    
    UIButton *narrow = [UIButton buttonWithType:UIButtonTypeCustom];
    narrow.frame = CGRectMake(enlarge.x, CGRectGetMaxY(enlarge.frame), 35, 35);
    narrow.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [narrow addTarget:self action:@selector(narrowClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:narrow];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 70)];
    image.image =[UIImage imageNamed:@"map_zoom"];
    [enlarge addSubview:image];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    [self.locationService startUserLocationService];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    [self.locationService stopUserLocationService];
    self.mapView.delegate = nil;
    self.locationService = nil;
}

- (void)setupNavView{
    [super setupNavView];
    self.navView.backgroundColor = [QFTools colorWithHexString:MainColor];
    self.navView.showBottomLabel = NO;
    [self.navView.centerButton setTitle:@"车辆位置" forState:UIControlStateNormal];
    @weakify(self);
    [self.navView.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navView.leftButtonBlock = ^{
        @strongify(self);
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.navView.rightButton setImage:[UIImage imageNamed:@"bike_track"] forState:UIControlStateNormal];
    self.navView.rightButtonBlock = ^{
        @strongify(self);
        
        [self.navigationController pushViewController:[VehicleTrajectoryViewController new] animated:YES];
    };
}

- (BMKMapView *)mapView
{
    if (!_mapView) {
        
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, navHeight, ScreenWidth, ScreenHeight - navHeight)];
        _mapView.mapType = BMKMapTypeStandard;
        _mapView.showMapScaleBar = YES;
        _mapView.rotateEnabled = NO; //设置是否可以旋转
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        _mapView.showsUserLocation = YES;
        [_mapView setZoomLevel:17];//缩小地图
    }
    return _mapView;
}

-(BMKLocationService *)locationService{
    
    if (!_locationService) {
        
        _locationService = [BMKLocationService new];
        _locationService.delegate = self;
        _locationService.distanceFilter = 100;
        _locationService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;//定位精度
    }
    return _locationService;
}

- (BMKPointAnnotation *)annotation
{
    if (!_annotation) {
        _annotation = [[BMKPointAnnotation alloc] init];
    }
    return _annotation;
}

//添加固定屏幕位置的标注
- (void)addBikeAnnotation
{
    if (!_bikeAnnotation) {
        _bikeAnnotation = [[BMKPointAnnotation alloc]init];
        _bikeAnnotation.isLockedToScreen = YES;
        _bikeAnnotation.screenPointToLock = CGPointMake(ScreenWidth/2, 300);
        _bikeAnnotation.title = @"我是固定屏幕的标注";
    }
    [self.mapView addAnnotation:_bikeAnnotation];
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    self.annotation.coordinate = coor;
    
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    [self.mapView updateLocationData:userLocation];
    [self customLocationAccuracyCircle];
    [self addBikeAnnotation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

- (void)customLocationAccuracyCircle {
    
    BMKLocationViewDisplayParam* testParam = [[BMKLocationViewDisplayParam alloc] init];
    testParam.isRotateAngleValid = false;// 跟随态旋转角度是否生效
    testParam.isAccuracyCircleShow = false;// 精度圈是否显示
    //testParam.locationViewImgName = @"icon_compass";// 定位图标名称
    testParam.locationViewOffsetX = 0;//定位图标偏移量(经度)
    testParam.locationViewOffsetY = 0;// 定位图标偏移量(纬度)
    
    [self.mapView updateLocationViewWithParam:testParam];
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            if (annotation == self.bikeAnnotation) {
                // 设置颜色
                annotationView.pinColor = BMKPinAnnotationColorGreen;
                // 设置可拖拽
                annotationView.draggable = NO;
                annotationView.image = [UIImage imageNamed:@"bike_position"];
                annotationView.annotation = annotation;
                // 设定popView的高度
                double popViewH = 100;
                
                GPSPaopaoView * popView = [[GPSPaopaoView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 20, popViewH)];
                [popView.layer setMasksToBounds:YES];
                [popView.layer setCornerRadius:3.0];
                popView.alpha = 0.9;
                
                BMKActionPaopaoView * pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
                annotationView.paopaoView = pView;
                
                
            } else {
                // 设置可拖拽
                annotationView.draggable = YES;
            }
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
        }
        return annotationView;
    }
    return nil;
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}

//放大缩小
-(void)enlargeClick{
    
    
    [self.mapView setZoomLevel:self.mapView.zoomLevel+1];//缩小地图
}

-(void)narrowClick{
    
    [self.mapView setZoomLevel:self.mapView.zoomLevel-1];//缩小地图
}

-(void)locationClick{
    
    [self.mapView setCenterCoordinate:self.annotation.coordinate animated:YES];
    
}

-(void)dealloc{
    if (self.mapView) {
        self.mapView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
