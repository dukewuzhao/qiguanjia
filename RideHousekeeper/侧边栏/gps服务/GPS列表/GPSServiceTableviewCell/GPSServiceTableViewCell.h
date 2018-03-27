//
//  GPSServiceTableViewCell.h
//  RideHousekeeper
//
//  Created by Apple on 2018/3/27.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPSServiceTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *GPSmage;
@property (strong, nonatomic) UILabel *GPSnameLab;
@property (strong, nonatomic) UILabel *bikeName;
@property (strong, nonatomic) UIImageView *usericon;
@property (strong, nonatomic) UILabel *phone;
@property (strong, nonatomic) UILabel *DaysRemainingLab;
@property (strong, nonatomic) UILabel *dayLeft;
@property (strong, nonatomic) UIButton *PayBtn;
@end
