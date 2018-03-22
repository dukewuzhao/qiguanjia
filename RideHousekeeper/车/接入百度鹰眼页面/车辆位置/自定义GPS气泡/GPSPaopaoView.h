//
//  GPSPaopaoView.h
//  RideHousekeeper
//
//  Created by 吴兆华 on 2018/3/11.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPSPaopaoView : UIView

@property (nonatomic, strong) UIView    *headView;
@property (nonatomic, strong) UILabel    *locationTime;
@property (nonatomic, strong) UILabel    *locationAddress;
@property (nonatomic, strong) UIImageView     *gpsImg;
@property (nonatomic, strong) UIImageView     *gsmImg;

@end
