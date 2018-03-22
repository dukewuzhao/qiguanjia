//
//  NoticeTableViewCell.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/12.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 7.5, 50, 20)];
        _timeLab.text = @"19:12";
        _timeLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:_timeLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 1, 45)];
        line.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:line];
        
        _instructionImg = [[UIImageView alloc] initWithFrame:CGRectMake(line.x - 5, line.height/2 - 10, 10, 10)];
        _instructionImg.image = [UIImage imageNamed:@"small_dot"];
        [self.contentView addSubview:_instructionImg];
        
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(62.5, 0, ScreenWidth - 62.5, 35)];
        _mainView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_mainView];
        
        UIImageView *noticeImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 20, 20)];
        noticeImg.image = [UIImage imageNamed:@"trajectory_shake"];
        [_mainView addSubview:noticeImg];
        
        UILabel *shakeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(noticeImg.frame)+ 10, noticeImg.y, 100, 25)];
        shakeLab.textColor = [UIColor redColor];
        shakeLab.text = @"车辆震动";
        shakeLab.font = [UIFont systemFontOfSize:20];
        [_mainView addSubview:shakeLab];
        
        _noticeTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shakeLab.frame) + ScreenWidth * .12, 7.5, 60, 20)];
        _noticeTimeLab.text = @"7次";
        _noticeTimeLab.font = [UIFont systemFontOfSize:15];
        _noticeTimeLab.textColor = [UIColor redColor];
        [_mainView addSubview:_noticeTimeLab];
        
        _arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(_mainView.width - 20,_mainView.height/2 - 4.05 , 15, 8.1)];
        _arrowImg.image = [UIImage imageNamed:@"icon_down"];
        [_mainView addSubview:_arrowImg];
    }
    return self;
}

@end
