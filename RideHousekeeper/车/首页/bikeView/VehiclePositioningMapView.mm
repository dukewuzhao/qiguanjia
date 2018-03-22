//
//  VehiclePositioningMapView.m
//  RideHousekeeper
//
//  Created by Apple on 2018/2/27.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "VehiclePositioningMapView.h"
#import "VehiclePositionViewController.h"

@implementation VehiclePositioningMapView

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
        self.maskView.frame = CGRectMake(0, -1, self.width, self.height);
        self.maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMaskView)];
        [self.maskView addGestureRecognizer:tap];
        [self addSubview:self.maskView];
    }
    return self;
}

-(void)clickMaskView{
    
    [self.viewController.navigationController pushViewController:[VehiclePositionViewController new] animated:YES];
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (BMKMapView *)mapView
{
    if (!_mapView) {
        NSInteger h = ScreenHeight *.225 - 40;
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 30, h)];
        _mapView.mapType = BMKMapTypeStandard;
        //_mapView.showMapScaleBar = YES;
        _mapView.logoPosition = BMKLogoPositionRightTop;
    }
    return _mapView;
}

-(void)setupUI{
    [self addSubview:self.mapView];
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 17;//地图显示比例
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.mapView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.mapView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.mapView.layer.mask = maskLayer;
    
    _locationLab = [[UILabel alloc] initWithFrame:CGRectMake(15, self.mapView.height+ 10, self.width/2, 20)];
    _locationLab.textColor = [QFTools colorWithHexString:@"#666666"];
    _locationLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:_locationLab];
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 85, _locationLab.y, 70, 20)];
    _timeLab.textColor = [QFTools colorWithHexString:@"#999999"];
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:_timeLab];
}

- (BMKPointAnnotation *)annotation
{
    if (!_annotation) {
        _annotation = [[BMKPointAnnotation alloc] init];
    }
    return _annotation;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            if (annotation == self.annotation) {
                // 设置颜色
                annotationView.pinColor = BMKPinAnnotationColorGreen;
                // 设置可拖拽
                annotationView.draggable = NO;
                annotationView.image = [UIImage imageNamed:@"bike_position"];
                annotationView.annotation = annotation;
                
            }
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
        }
        return annotationView;
    }
    return nil;
}

-(UIView *)maskView{
    
    if (!_maskView) {
        _maskView = [UIView new];
    }
    return _maskView;
}

-(void)dealloc{
    
    if (self.mapView) {
        self.mapView.delegate = nil;
        self.mapView = nil;
    }
}

@end
