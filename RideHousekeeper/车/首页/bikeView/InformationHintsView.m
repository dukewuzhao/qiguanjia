//
//  InformationHintsView.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/27.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "InformationHintsView.h"

@implementation InformationHintsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor whiteColor];
        
        self.displayLab.frame = CGRectMake(5, 7.5, 30, 15);
        self.displayLab.font =[UIFont systemFontOfSize:13];
        self.displayLab.textColor = [QFTools colorWithHexString:@"#999999"];
        self.displayLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.displayLab];
        
        self.displayImg.frame = CGRectMake(CGRectGetMaxX(self.displayLab.frame)+5, self.displayLab.y, 8, 15);
        [self addSubview:self.displayImg];
        
    }
    return self;
}

-(UILabel *)displayLab{
    
    if (!_displayLab) {
        _displayLab = [UILabel new];
    }
    return _displayLab;
}

-(UIImageView *)displayImg{
    
    if (!_displayImg) {
        _displayImg = [UIImageView new];
    }
    return _displayImg;
}

@end
