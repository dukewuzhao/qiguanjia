//
//  BikeMessageTableViewCell.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/15.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "BikeMessageTableViewCell.h"

@implementation BikeMessageTableViewCell

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
        
        self.remindImg.frame = CGRectMake(20, 15, 33, 33);
        self.remindImg.image = [UIImage imageNamed:@"message_clock"];
        [self.contentView addSubview:self.remindImg];
        
        self.newsType.frame = CGRectMake(CGRectGetMaxX(self.remindImg.frame) + 13, self.remindImg.y, 100, 15);
        self.newsType.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.newsType];
        
        self.dateLab.frame = CGRectMake(self.newsType.x, CGRectGetMaxY(self.newsType.frame)+ 3, 140, 15);
        self.dateLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.dateLab];
        
        self.footView = [[UIView alloc] initWithFrame:CGRectMake(self.newsType.x, CGRectGetMaxY(self.dateLab.frame)+10, ScreenWidth - self.newsType.x, 50)];
        self.footView.backgroundColor = [QFTools colorWithHexString:@"#666666"];
        [self.contentView addSubview:self.footView];
        
        self.selectBtn.frame = CGRectMake(self.footView.width - 38, self.footView.height/2 - 9, 18, 18);
        [self.selectBtn setImage:[UIImage imageNamed:@"message_circle"] forState:UIControlStateNormal];
        [self.footView addSubview: self.selectBtn];
        
    }
    return self;
}

-(UIImageView *)remindImg{
    
    if (!_remindImg) {
        _remindImg = [UIImageView new];
    }
    return _remindImg;
}

-(UILabel *)newsType{
    
    if (!_newsType) {
        _newsType = [UILabel new];
        _newsType.font = [UIFont systemFontOfSize:15];
    }
    return _newsType;
}

-(UILabel *)dateLab{
    
    if (!_dateLab) {
        _dateLab = [UILabel new];
        _dateLab.font = [UIFont systemFontOfSize:13];
    }
    return _dateLab;
}

-(UILabel *)versionRemindType{
    
    if (!_versionRemindType) {
        _versionRemindType = [UILabel new];
        _versionRemindType.font = [UIFont systemFontOfSize:14];
    }
    return _versionRemindType;
}

-(UILabel *)RemindLab{
    
    if (!_RemindLab) {
        _RemindLab = [UILabel new];
        _RemindLab.font = [UIFont systemFontOfSize:12];
    }
    return _RemindLab;
}

-(UIView *)footView{
    
    if (!_footView) {
        _footView = [UILabel new];
    }
    return _footView;
}

-(UIButton *)selectBtn{
    
    if (!_selectBtn) {
        _selectBtn = [UIButton new];
    }
    return _selectBtn;
}

@end
