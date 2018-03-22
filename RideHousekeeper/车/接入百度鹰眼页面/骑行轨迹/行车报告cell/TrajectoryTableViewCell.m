//
//  TrajectoryTableViewCell.m
//  RideHousekeeper
//
//  Created by 吴兆华 on 2018/3/11.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "TrajectoryTableViewCell.h"

@implementation TrajectoryTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 50, 20)];
        _timeLab.text = @"19:12";
        _timeLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:_timeLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 1, 90)];
        line.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:line];
        
        _instructionImg = [[UIImageView alloc] initWithFrame:CGRectMake(line.x - 5, line.height/2 - 10, 10, 10)];
        _instructionImg.image = [UIImage imageNamed:@"small_dot"];
        [self.contentView addSubview:_instructionImg];
        
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(62.5, 0, ScreenWidth - 62.5, 80)];
        _mainView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_mainView];
        
        _startImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        _startImg.image = [UIImage imageNamed:@"trajectory_start"];
        [_mainView addSubview:_startImg];
        
        _startLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_startImg.frame)+10, _startImg.y, 120, 20)];
        _startLab.font = [UIFont systemFontOfSize:20];
        _startLab.text = @"春申路";
        _startLab.textColor = [UIColor blackColor];
        [_mainView addSubview:_startLab];
        
        _endImg = [[UIImageView alloc] initWithFrame:CGRectMake(_startImg.x, CGRectGetMaxY(_startLab.frame)+10, 20, 20)];
        _endImg.image = [UIImage imageNamed:@"trajectory_end"];
        [_mainView addSubview:_endImg];
        
        _endLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_endImg.frame)+7, _endImg.y, 120, 20)];
        _endLab.font = [UIFont systemFontOfSize:20];
        _endLab.text = @"龙吴路";
        _endLab.textColor = [UIColor blackColor];
        [_mainView addSubview:_endLab];
        
        _mileageLab = [[UILabel alloc] initWithFrame:CGRectMake(_startLab.x, CGRectGetMaxY(_endLab.frame)+5, 50, 15)];
        _mileageLab.font = [UIFont systemFontOfSize:14];
        _mileageLab.text = @"20.2km";
        _mileageLab.textColor = [QFTools colorWithHexString:@"#666666"];
        [_mainView addSubview:_mileageLab];
        
        
        _timeConsumingLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mileageLab.frame)+ ScreenWidth * .04, _mileageLab.y, 70, 15)];
        _timeConsumingLab.font = [UIFont systemFontOfSize:14];
        _timeConsumingLab.text = @"12.5分钟";
        _timeConsumingLab.textColor = [QFTools colorWithHexString:@"#666666"];
        [_mainView addSubview:_timeConsumingLab];
        
        _speedImgLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeConsumingLab.frame)+ScreenWidth * .04, _mileageLab.y, 70, 15)];
        _speedImgLab.font = [UIFont systemFontOfSize:14];
        _speedImgLab.text = @"30.0km/h";
        _speedImgLab.textColor = [QFTools colorWithHexString:@"#666666"];
        [_mainView addSubview:_speedImgLab];
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(_mainView.width - 20,_mainView.height/2 - 7.5 , 8.4, 15)];
        arrowImg.image = [UIImage imageNamed:@"arrow"];
        [_mainView addSubview:arrowImg];
    }
    return self;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
