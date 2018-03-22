//
//  GPSHeadView.h
//  RideHousekeeper
//
//  Created by Apple on 2018/3/13.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYImage.h"
@interface GPSHeadView : UIView
@property(nonatomic,strong) YYAnimatedImageView *gpsImageView;
@property(nonatomic,strong) UILabel *promptLab;
@end
