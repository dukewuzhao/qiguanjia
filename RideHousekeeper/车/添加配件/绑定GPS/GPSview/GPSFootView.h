//
//  GPSFootView.h
//  RideHousekeeper
//
//  Created by Apple on 2018/3/13.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSFootViewCell.h"
#import "GPSFootModel.h"
typedef NS_ENUM(NSUInteger, imgStyle) {
    imgComplete = 1,
    imgCheck,
    imgSpot
};

@interface GPSFootView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, copy) void (^ btnStopClickBlock)();
@property (nonatomic, strong) UITableView *checkTab;

@end
