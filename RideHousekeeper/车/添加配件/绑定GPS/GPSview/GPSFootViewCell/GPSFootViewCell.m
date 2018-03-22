//
//  GPSFootViewCell.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/13.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "GPSFootViewCell.h"

@implementation GPSFootViewCell

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
        
        _stateImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.height/2 - 5, 10, 10)];
        _stateImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_stateImg];
        
        _stateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_stateImg.frame)+5, self.height/2 - 10, self.width - 20, 20)];
        _stateLab.textColor = [QFTools colorWithHexString:@"#999999"];
        _stateLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_stateLab];
    }
    return self;
}


@end
