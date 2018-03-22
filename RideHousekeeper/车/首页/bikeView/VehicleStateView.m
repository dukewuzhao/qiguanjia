//
//  VehicleStateView.m
//  RideHousekeeper
//
//  Created by Apple on 2018/2/26.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "VehicleStateView.h"

@implementation VehicleStateView

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
    
    [self setupFootView:0];
}

-(void)setupFootView:(NSInteger)keyversionvalue{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (keyversionvalue == 2 || keyversionvalue == 6 || keyversionvalue == 9) {
        for (int i = 0; i<4; i++) {
            UIButton *controlerBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.height *.2 + ((self.width - self.height *.4 - 180)/3 + 45)*i, self.height/2 - 35, 45, 45)];
            UILabel *bikesearch = [[UILabel alloc] initWithFrame:CGRectMake(controlerBtn.x, CGRectGetMaxY(controlerBtn.frame)+5, 45, 20)];
            controlerBtn.tag = 20+i;
            bikesearch.tag = 100+i;
            
            if (controlerBtn.tag == 20) {
                _bikeLockBtn = controlerBtn;
                [controlerBtn setImage:[UIImage imageNamed:@"icon_bike_lock_blue"] forState:UIControlStateNormal];
            }else if (controlerBtn.tag == 21){
                _bikeSwitchBtn = controlerBtn;
                [controlerBtn setImage:[UIImage imageNamed:@"open_the_switch"] forState:UIControlStateNormal];
            }else if (controlerBtn.tag == 22){
                _bikeSeatBtn = controlerBtn;
                [controlerBtn setImage:[UIImage imageNamed:@"icon_bike_seat"] forState:UIControlStateNormal];
            }else if(controlerBtn.tag == 23){
                _bikeMuteBtn = controlerBtn;
                [controlerBtn setImage:[UIImage imageNamed:@"bike_nomute_icon"] forState:UIControlStateNormal];
            }
            
            if (bikesearch.tag == 100) {
                _bikeLockLabel = bikesearch;
                bikesearch.text = @"上锁";
            }else if (bikesearch.tag == 101){
                _bikeSwitchLabel = bikesearch;
                bikesearch.text = @"电门";
            }else if (bikesearch.tag == 102){
                _bikeSeatLabel = bikesearch;
                bikesearch.text = @"座桶";
            }else if(bikesearch.tag == 103){
                _bikeMuteLabel = bikesearch;
                bikesearch.text = @"静音";
            }
            bikesearch.textColor = [UIColor blackColor];
            bikesearch.textAlignment = NSTextAlignmentCenter;
            [self addSubview:bikesearch];
            [controlerBtn addTarget:self action:@selector(controlerClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:controlerBtn];
        }
        
    }else{
        for (int i = 0; i<3; i++) {
            UIButton *controlerBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.height *.33 + ((self.width - self.height *.66 - 135)/2 +45)*i , self.height/2 - 35, 45, 45)];
            
            UILabel *bikesearch = [[UILabel alloc] initWithFrame:CGRectMake(controlerBtn.x, CGRectGetMaxY(controlerBtn.frame)+5, 45, 20)];
            controlerBtn.tag = 20+i;
            bikesearch.tag = 100+i;
            
            if (controlerBtn.tag == 20) {
                _bikeLockBtn = controlerBtn;
                [controlerBtn setImage:[UIImage imageNamed:@"icon_bike_lock_blue"] forState:UIControlStateNormal];
            }else if (controlerBtn.tag == 21){
                _bikeSwitchLabel = bikesearch;
                [controlerBtn setImage:[UIImage imageNamed:@"open_the_switch"] forState:UIControlStateNormal];
            }else if (controlerBtn.tag == 22){
                _bikeMuteBtn = controlerBtn;
                [controlerBtn setImage:[UIImage imageNamed:@"bike_nomute_icon"] forState:UIControlStateNormal];
            }
            if (bikesearch.tag == 100) {
                _bikeLockLabel = bikesearch;
                bikesearch.text = @"上锁";
            }else if (bikesearch.tag == 101){
                _bikeSwitchLabel = bikesearch;
                bikesearch.text = @"电门";
            }else if (bikesearch.tag == 102){
                _bikeMuteLabel = bikesearch;
                bikesearch.text = @"静音";
            }
            bikesearch.textColor = [UIColor blackColor];
            bikesearch.textAlignment = NSTextAlignmentCenter;
            [self addSubview:bikesearch];
            [controlerBtn addTarget:self action:@selector(controlerClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:controlerBtn];
            
        }
    }
    
}

-(void)controlerClick:(UIButton *)btn{
    
    if (![[AppDelegate currentAppDelegate].device isConnected]) {
        
        [SVProgressHUD showSimpleText:@"蓝牙未连接"];
        return;
        
    }
    
    if (btn.tag == 20) {
        if (self.bikeLockBlock) {
            self.bikeLockBlock(btn.tag);
        }
        
    }else if (btn.tag == 21){
        
        if (self.bikeSwitchBlock) {
            self.bikeSwitchBlock(btn.tag);
        }
    }else if (btn.tag == 22){
        
        if (self.bikeSeatBlock) {
            self.bikeSeatBlock(btn.tag);
        }
    }else if (btn.tag == 23){
        
        if (self.bikeMuteBlock) {
            self.bikeMuteBlock(btn.tag);
        }
    }
}


@end
