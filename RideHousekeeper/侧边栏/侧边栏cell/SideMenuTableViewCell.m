//
//  SideMenuTableViewCell.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/13.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "SideMenuTableViewCell.h"

@implementation SideMenuTableViewCell

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
        
        _IMG = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.height/2 - 15, 30, 30)];
        [self.contentView addSubview:_IMG];
        
        _TITLE = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_IMG.frame)+27.5, self.height/2 - 15, 200, 30)];
        _TITLE.textColor = [QFTools colorWithHexString:@"#555555"];
        [self.contentView addSubview:_TITLE];
    }
    return self;
}


@end
