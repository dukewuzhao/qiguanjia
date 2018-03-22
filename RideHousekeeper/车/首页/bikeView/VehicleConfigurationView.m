//
//  VehicleConfigurationView.m
//  RideHousekeeper
//
//  Created by Apple on 2018/2/26.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "VehicleConfigurationView.h"

@implementation VehicleConfigurationView

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
        
        [self setupView];
    }
    return self;
}

-(void)setupView{
    float imageWith = self.width/3;
    float imageY = self.height*.4 - 32;
    self.bikeTestImge.frame = CGRectMake(imageWith/2 - 20,imageY , 40, 40);
    [self addSubview:self.bikeTestImge];
    
    self.bikeTestLabel.frame = CGRectMake(0, CGRectGetMaxY(self.bikeTestImge.frame)+ self.height *.15, imageWith, 15);
    self.bikeTestLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bikeTestLabel];
    
    self.bikeTemperatureLabel.frame = CGRectMake(imageWith/2 - 30, CGRectGetMaxY(self.bikeTestLabel.frame)+self.height *0.05, 30, 10);
    [self addSubview:self.bikeTemperatureLabel];
    
    self.bikeVoltageLabel.frame = CGRectMake(imageWith/2, self.bikeTemperatureLabel.y, 30, 10);
    self.bikeVoltageLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.bikeVoltageLabel];
    
    self.bikeSetUpImge.frame = CGRectMake(imageWith+imageWith/2 - 20, self.bikeTestImge.y, 40, 40);
    [self addSubview:self.bikeSetUpImge];
    
    self.bikeSetUpLabel.frame = CGRectMake(imageWith, self.bikeTestLabel.y, imageWith, 10);
    self.bikeSetUpLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bikeSetUpLabel];
    
    self.bikeSetUpDescribeLabel.frame  = CGRectMake(imageWith, self.bikeTemperatureLabel.y, imageWith, 10);
    self.bikeSetUpDescribeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bikeSetUpDescribeLabel];
    
    self.bikePartsManageImge.frame = CGRectMake(imageWith*2+imageWith/2 - 20, self.bikeTestImge.y, 40, 40);
    [self addSubview:self.bikePartsManageImge];
    
    self.bikePartsManageLabel.frame = CGRectMake(imageWith*2, self.bikeTestLabel.y, imageWith, 10);
    self.bikePartsManageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bikePartsManageLabel];
    
    self.bikePartsManagDescribeLabel.frame = CGRectMake(imageWith*2, self.bikeTemperatureLabel.y, imageWith, 10);
    self.bikePartsManagDescribeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bikePartsManagDescribeLabel];
    
    [self setupMaskView];
    
}

-(UIImageView *)bikeTestImge{
    
    if (!_bikeTestImge) {
        _bikeTestImge = [UIImageView new];
    }
    return _bikeTestImge;
}

-(UILabel *)bikeTestLabel{
    
    if (!_bikeTestLabel) {
        _bikeTestLabel = [UILabel new];
        _bikeTestLabel.font = [UIFont systemFontOfSize:15];
        _bikeTestLabel.textColor = [QFTools colorWithHexString:@"#111111"];
    }
    return _bikeTestLabel;
}

-(UILabel *)bikeTemperatureLabel{
    
    if (!_bikeTemperatureLabel) {
        _bikeTemperatureLabel = [UILabel new];
        _bikeTemperatureLabel.font = [UIFont systemFontOfSize:10];
        _bikeTemperatureLabel.textColor = [QFTools colorWithHexString:@"#666666"];
    }
    return _bikeTemperatureLabel;
}

-(UILabel *)bikeVoltageLabel{
    
    if (!_bikeVoltageLabel) {
        _bikeVoltageLabel = [UILabel new];
        _bikeVoltageLabel.font = [UIFont systemFontOfSize:10];
        _bikeVoltageLabel.textColor = [QFTools colorWithHexString:@"#666666"];
    }
    return _bikeVoltageLabel;
}

-(UIImageView *)bikeSetUpImge{
    
    if (!_bikeSetUpImge) {
        _bikeSetUpImge = [UIImageView new];
    }
    return _bikeSetUpImge;
}

-(UILabel *)bikeSetUpLabel{
    
    if (!_bikeSetUpLabel) {
        _bikeSetUpLabel = [UILabel new];
        _bikeSetUpLabel.font = [UIFont systemFontOfSize:15];
        _bikeSetUpLabel.textColor = [QFTools colorWithHexString:@"#111111"];
    }
    return _bikeSetUpLabel;
}

-(UILabel *)bikeSetUpDescribeLabel{
    
    if (!_bikeSetUpDescribeLabel) {
        _bikeSetUpDescribeLabel = [UILabel new];
        _bikeSetUpDescribeLabel.font = [UIFont systemFontOfSize:10];
        _bikeSetUpDescribeLabel.textColor = [QFTools colorWithHexString:@"#666666"];
    }
    return _bikeSetUpDescribeLabel;
}

-(UIImageView *)bikePartsManageImge{
    
    if (!_bikePartsManageImge) {
        _bikePartsManageImge = [UIImageView new];
    }
    return _bikePartsManageImge;
}


-(UILabel *)bikePartsManageLabel{
    
    if (!_bikePartsManageLabel) {
        _bikePartsManageLabel = [UILabel new];
        _bikePartsManageLabel.font = [UIFont systemFontOfSize:15];
        _bikePartsManageLabel.textColor = [QFTools colorWithHexString:@"#111111"];
    }
    return _bikePartsManageLabel;
}

-(UILabel *)bikePartsManagDescribeLabel{
    
    if (!_bikePartsManagDescribeLabel) {
        _bikePartsManagDescribeLabel = [UILabel new];
        _bikePartsManagDescribeLabel.font = [UIFont systemFontOfSize:10];
        _bikePartsManagDescribeLabel.textColor = [QFTools colorWithHexString:@"#666666"];
    }
    return _bikePartsManagDescribeLabel;
}

-(UIView *)clickView{
    
    if (!_clickView) {
        _clickView = [UIView new];
        
    }
    return _clickView;
}

//-(void)setFrame:(CGRect)frame{
//
//    self.frame = frame;
//    //NSLog(@"%@",frame);
//}

-(void)setupMaskView{
    //NSLog(@"frame-->%@",NSStringFromCGRect(self.frame));
    float imageWith = self.width/3;
    [self.clickView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.clickView.frame = CGRectMake(0, 0, self.width, self.height);
    [self addSubview:self.clickView];
    for (int i = 0; i<3; i++) {
        UIView *maskview = [[UIView alloc] initWithFrame:CGRectMake(imageWith*i, 0, imageWith, self.height)];
        maskview.tag = 30+i;
        [self.clickView addSubview:maskview];
        maskview.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
        [maskview addGestureRecognizer:tap];
        if (i<2) {
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maskview.frame), 0, 1, self.height)];
            lineview.alpha = 0.4;
            lineview.backgroundColor = [QFTools colorWithHexString:MainColor];
            [self.clickView addSubview:lineview];
        }
    }
}

-(void)clickImage:(UITapGestureRecognizer *)tap{
    
    if ([tap view].tag == 30) {
        
        if (self.bikeTestClickBlock) {
            self.bikeTestClickBlock();
        }
    }else if ([tap view].tag == 31){
        
        if (self.bikeSetUpClickBlock) {
            self.bikeSetUpClickBlock();
        }
    }else if ([tap view].tag == 32){
        
        if (self.bikePartsManagClickBlock) {
            self.bikePartsManagClickBlock();
        }
    }
}


- (void)setHaveGPS:(BOOL)haveGPS{
    _haveGPS = haveGPS;
    float imageWith = self.width/3;
    
    if (haveGPS) {
        float imageY = self.height*.43 - 25;
        self.bikeTestImge.frame = CGRectMake(imageWith/2 - 15, imageY, 30, 30);
        
        self.bikeTestLabel.frame = CGRectMake(0, CGRectGetMaxY(_bikeTestImge.frame)+ self.height *.07, imageWith, 10);
        
        self.bikeTemperatureLabel.frame = CGRectMake(imageWith/2 - 30, CGRectGetMaxY(_bikeTestLabel.frame)+self.height *0.07, 30, 10);
        
        self.bikeVoltageLabel.frame = CGRectMake(imageWith/2, self.bikeTemperatureLabel.y, 30, 10);
        
        self.bikeSetUpImge.frame = CGRectMake(imageWith+imageWith/2 - 15, self.bikeTestImge.y, 30, 30);
        
        self.bikeSetUpLabel.frame = CGRectMake(imageWith, self.bikeTestLabel.y, imageWith, 10);
        
        self.bikeSetUpDescribeLabel.frame  = CGRectMake(imageWith, self.bikeTemperatureLabel.y, imageWith, 10);
        
        self.bikePartsManageImge.frame = CGRectMake(imageWith*2+imageWith/2 - 15, self.bikeTestImge.y, 30, 30);
        
        self.bikePartsManageLabel.frame = CGRectMake(imageWith*2, self.bikeTestLabel.y, imageWith, 10);
        
        self.bikePartsManagDescribeLabel.frame = CGRectMake(imageWith*2, self.bikeTemperatureLabel.y, imageWith, 10);
        [self setupMaskView];
    }else{
        float imageY = self.height*.4 - 32;
        self.bikeTestImge.frame = CGRectMake(imageWith/2 - 20, imageY, 40, 40);
        
        self.bikeTestLabel.frame = CGRectMake(0, CGRectGetMaxY(self.bikeTestImge.frame)+ self.height *.15, imageWith, 10);
        
        self.bikeTemperatureLabel.frame = CGRectMake(imageWith/2 - 30, CGRectGetMaxY(self.bikeTestLabel.frame)+self.height *0.05, 30, 10);
        
        self.bikeVoltageLabel.frame = CGRectMake(imageWith/2, self.bikeTemperatureLabel.y, 30, 10);
        
        self.bikeSetUpImge.frame = CGRectMake(imageWith+imageWith/2 - 20, self.bikeTestImge.y, 40, 40);
        
        self.bikeSetUpLabel.frame = CGRectMake(imageWith, self.bikeTestLabel.y, imageWith, 10);
        
        self.bikeSetUpDescribeLabel.frame  = CGRectMake(imageWith, self.bikeTemperatureLabel.y, imageWith, 10);
        
        self.bikePartsManageImge.frame = CGRectMake(imageWith*2+imageWith/2 - 20, self.bikeTestImge.y, 40, 40);
        
        self.bikePartsManageLabel.frame = CGRectMake(imageWith*2, self.bikeTestLabel.y, imageWith, 10);
        
        self.bikePartsManagDescribeLabel.frame = CGRectMake(imageWith*2, self.bikeTemperatureLabel.y, imageWith, 10);
        [self setupMaskView];
    }
    [self layoutIfNeeded];
}



@end
