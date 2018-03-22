//
//  VehicleControlView.m
//  RideHousekeeper
//
//  Created by Apple on 2018/2/26.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "VehicleControlView.h"

@implementation VehicleControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.bikeLockImge.frame = CGRectMake(25, self.height/2 - 15, 30, 30);
    [self addSubview:self.bikeLockImge];
    
    self.bikeLockLabel.frame = CGRectMake(CGRectGetMaxX(self.bikeLockImge.frame)+ 10, self.height/2 - 10, 50, 20);
    self.bikeLockLabel.textColor = [QFTools colorWithHexString:@"#111111"];
    [self addSubview:self.bikeLockLabel];
    
    self.bikeBLEImage.frame = CGRectMake(self.width - 100, self.height/2 - 15, 30, 30);
    [self addSubview:self.bikeBLEImage];
    
    self.bikeIsConnectLabel.frame = CGRectMake(CGRectGetMaxX(self.bikeBLEImage.frame)+ 10, self.height/2 - 10, 50, 20);
    self.bikeIsConnectLabel.textColor = [UIColor redColor];
    [self addSubview:self.bikeIsConnectLabel];
}

-(UIImageView *)bikeLockImge{
    
    if (!_bikeLockImge) {
        _bikeLockImge = [UIImageView new];
    }
    return _bikeLockImge;
}

-(UILabel *)bikeLockLabel{
    
    if (!_bikeLockLabel) {
        _bikeLockLabel = [UILabel new];
        _bikeLockLabel.font = [UIFont systemFontOfSize:16];
    }
    return _bikeLockLabel;
}

-(UIImageView *)bikeBLEImage{
    
    if (!_bikeBLEImage) {
        _bikeBLEImage = [UIImageView new];
    }
    return _bikeBLEImage;
}

-(UILabel *)bikeIsConnectLabel{
    
    if (!_bikeIsConnectLabel) {
        _bikeIsConnectLabel = [UILabel new];
        _bikeIsConnectLabel.font = [UIFont systemFontOfSize:16];
    }
    return _bikeIsConnectLabel;
}

@end
