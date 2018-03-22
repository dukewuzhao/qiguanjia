//
//  BikeMessageTableViewCell.h
//  RideHousekeeper
//
//  Created by Apple on 2018/3/15.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BikeMessageTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *remindImg;
@property(nonatomic,strong) UILabel *newsType;
@property(nonatomic,strong) UILabel *dateLab;
@property(nonatomic,strong) UILabel *versionRemindType;
@property(nonatomic,strong) UILabel *RemindLab;
@property(nonatomic,strong) UIView *footView;
@property(nonatomic,strong) UIButton *selectBtn;
@end
