//
//  GPSServiceTableViewCell.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/27.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "GPSServiceTableViewCell.h"

@implementation GPSServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
    }
    return self;
}

-(UIImageView *)GPSmage{
    
    if (!_GPSmage) {
        _GPSmage = [UIImageView new];
    }
    return _GPSmage;
}

-(UILabel *)GPSnameLab{
    
    if (!_GPSnameLab) {
        _GPSnameLab = [UILabel new];
        _GPSnameLab.textColor = [QFTools colorWithHexString:@"#111111"];
        _bikeName.font = [UIFont systemFontOfSize:17];
    }
    return _GPSnameLab;
}

-(UILabel *)bikeName{
    
    if (!_bikeName) {
        _bikeName = [UILabel new];
        _bikeName.textColor = [QFTools colorWithHexString:@"#111111"];
        _bikeName.font = [UIFont systemFontOfSize:15];
    }
    return _bikeName;
}

-(UIImageView *)usericon{
    
    if (!_usericon) {
        _usericon = [UIImageView new];
    }
    return _usericon;
}

-(UILabel *)phone{
    
    if (!_phone) {
        _phone = [UILabel new];
        _phone.textColor = [QFTools colorWithHexString:@"#666666"];
        _phone.font = [UIFont systemFontOfSize:15];
    }
    return _phone;
}

-(UILabel *)DaysRemainingLab{
    
    if (!_DaysRemainingLab) {
        _DaysRemainingLab = [UILabel new];
        _DaysRemainingLab.textColor = [QFTools colorWithHexString:@"#999999"];
        _DaysRemainingLab.font = [UIFont systemFontOfSize:13];
    }
    return _DaysRemainingLab;
}

-(UILabel *)dayLeft{
    
    if (!_dayLeft) {
        _dayLeft = [UILabel new];
        _dayLeft.textColor = [QFTools colorWithHexString:MainColor];
        _dayLeft.font = [UIFont systemFontOfSize:14];
    }
    return _dayLeft;
}


-(UIButton *)PayBtn{
    
    if (!_PayBtn) {
        _PayBtn = [UIButton new];
        _PayBtn.backgroundColor = [QFTools colorWithHexString:MainColor];
    }
    return _PayBtn;
}

-(void)layoutSubviews{
    
    self.GPSmage.frame = CGRectMake(20, 15, self.height - 30, self.height - 30);
    [self.contentView addSubview:self.GPSmage];
    
    self.GPSnameLab.frame = CGRectMake(CGRectGetMaxX(self.GPSmage.frame) + 25, 20,100, 15);
    [self.contentView addSubview:self.GPSnameLab];
    
    self.bikeName.frame = CGRectMake(self.GPSnameLab.x, CGRectGetMaxY(self.GPSnameLab.frame)+ 2, 100, 15);
    [self.contentView addSubview:self.bikeName];
    
    self.usericon.frame = CGRectMake(self.GPSnameLab.x, CGRectGetMaxY(self.bikeName.frame)+2, 15, 15);
    [self.contentView addSubview:self.usericon];
    
    self.phone.frame = CGRectMake(CGRectGetMaxX(self.usericon.frame) + 5, self.usericon.y, 100, 15);
    [self.contentView addSubview:self.phone];
    
    self.DaysRemainingLab.frame = CGRectMake(self.GPSnameLab.x, CGRectGetMaxY(self.GPSmage.frame) - 15, 100, 15);
    self.DaysRemainingLab.text = @"剩余服务天数";
    [self.contentView addSubview:self.DaysRemainingLab];
    
    self.dayLeft.frame = CGRectMake(CGRectGetMaxX(self.DaysRemainingLab.frame) + 10, self.DaysRemainingLab.y, 80, 15);
    self.dayLeft.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.dayLeft];
}

@end
