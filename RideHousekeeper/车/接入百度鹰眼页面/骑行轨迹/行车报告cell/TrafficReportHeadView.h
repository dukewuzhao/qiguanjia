//
//  TrafficReportHeadView.h
//  RideHousekeeper
//
//  Created by Apple on 2018/3/12.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficReportHeadView : UIView

@property (strong, nonatomic) UIImageView *instructionImg;

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UILabel *dateLab;
@property (strong, nonatomic) UILabel *monthLab;

@property (strong, nonatomic) UILabel *mileageLab;

@property (strong, nonatomic) UILabel *noticeTimeLab;

@property (strong, nonatomic) UILabel *speedLab;
@property (strong, nonatomic) UIImageView *arrowImg;
@end
