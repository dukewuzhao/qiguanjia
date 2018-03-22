//
//  TrajectoryTableViewCell.h
//  RideHousekeeper
//
//  Created by 吴兆华 on 2018/3/11.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrajectoryTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *timeLab;

@property (strong, nonatomic) UIImageView *instructionImg;

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImageView *startImg;
@property (strong, nonatomic) UILabel *startLab;
@property (strong, nonatomic) UIImageView *endImg;
@property (strong, nonatomic) UILabel *endLab;


@property (strong, nonatomic) UILabel *mileageLab;

@property (strong, nonatomic) UILabel *timeConsumingLab;

@property (strong, nonatomic) UILabel *speedImgLab;
@end
