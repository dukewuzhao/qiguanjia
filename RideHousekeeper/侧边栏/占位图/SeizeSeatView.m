//
//  SeizeSeatView.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/15.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "SeizeSeatView.h"

@implementation SeizeSeatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


-(UIImageView *)seizeImg{
    
    if (!_seizeImg) {
        _seizeImg = [UIImageView new];
    }
    return _seizeImg;
}

-(UILabel *)headlinesLab{
    
    if (!_headlinesLab) {
        _headlinesLab = [UILabel new];
        _headlinesLab.textAlignment = NSTextAlignmentCenter;
        _headlinesLab.textColor = [QFTools colorWithHexString:@"#cccccc"];
    }
    return _headlinesLab;
}

-(UILabel *)subtitleLab{
    
    if (!_subtitleLab) {
        _subtitleLab = [UILabel new];
        _subtitleLab.textAlignment = NSTextAlignmentCenter;
        _subtitleLab.textColor = [QFTools colorWithHexString:@"#cccccc"];
    }
    return _subtitleLab;
}
-(UILabel *)taggingLab{
    
    if (!_taggingLab) {
        _taggingLab = [UILabel new];
        _taggingLab.textAlignment = NSTextAlignmentCenter;
        _taggingLab.textColor = [QFTools colorWithHexString:@"#cccccc"];
        _taggingLab.font = [UIFont systemFontOfSize:15];
        _taggingLab.numberOfLines = 0;
    }
    return _taggingLab;
}

@end
