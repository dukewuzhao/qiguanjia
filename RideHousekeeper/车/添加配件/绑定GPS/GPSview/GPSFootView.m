//
//  GPSFootView.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/13.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "GPSFootView.h"
#import "UIView+i7Rotate360.h"
@implementation GPSFootView

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
        
        [self setupDate];
        
        [self setupUI];
    }
    return self;
}

-(void)setupDate{
    NSArray *ary = @[@"扫描GPS二维码",@"中控连接GPS设备", @"查询SIM卡网络", @"搜索GPS卫星", @"设备注册服务器",@"预设URL上传点",@"上传成功"];
    for (int i = 0; i<7; i++) {
        
        GPSFootModel *model = [GPSFootModel new];
        model.titleLab = ary[i];
        model.styleNum = imgSpot;
        [self.titleArray addObject:model];
    }
    
}

-(NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray new];
    }
    return _titleArray;
}

-(void)setupUI{
    
    _checkTab = [[UITableView alloc] initWithFrame:CGRectMake(self.width*.264, self.height *.136, self.width*.6, self.height*.68)];
    _checkTab.delegate = self;
    _checkTab.dataSource = self;
    _checkTab.backgroundColor = [UIColor clearColor];
    _checkTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_checkTab];
    
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2 - 20, self.height - 45, 40, 30)];
    [stopBtn setImage:[UIImage imageNamed:@"stop_gps_binding"] forState:UIControlStateNormal];
    [[stopBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (self.btnStopClickBlock) {
            self.btnStopClickBlock();
        }
    }];
    [self addSubview:stopBtn];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titleArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 30.0f;
}


- ( void )tableView:( UITableView  *)tableView  willDisplayCell :( UITableViewCell  *)cell  forRowAtIndexPath :( NSIndexPath  *)indexPath{
    
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GPSFootViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"gpscell"];
    if (!cell) {
        cell = [[GPSFootViewCell alloc] initWithStyle:0 reuseIdentifier:@"gpscell"];
    }
    
    GPSFootModel *model = self.titleArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (model.styleNum == imgComplete) {
        cell.stateLab.textColor = [QFTools colorWithHexString:@"#999999"];
        cell.stateLab.font = [UIFont systemFontOfSize:15];
        cell.stateImg.image = [UIImage imageNamed:@"prompt_complete"];
    }else if (model.styleNum == imgCheck){
        cell.stateLab.textColor = [QFTools colorWithHexString:MainColor];
        cell.stateLab.font = [UIFont systemFontOfSize:17];
        cell.stateImg.image = [UIImage imageNamed:@"gps_connecting"];
        [cell.stateImg rotate360WithDuration:1.0 repeatCount:HUGE_VALF timingMode:i7Rotate360TimingModeLinear];
    }else if (model.styleNum == imgSpot){
        cell.stateLab.textColor = [QFTools colorWithHexString:@"#999999"];
        cell.stateLab.font = [UIFont systemFontOfSize:15];
        cell.stateImg.image = [UIImage imageNamed:@"prompt_prepare"];
    }
    //GPSFootModel *model =
    
    cell.stateLab.text = [_titleArray[indexPath.row] titleLab];
    
    return cell;
    
}

@end
