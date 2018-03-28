//
//  GPSDetailViewController.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/27.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "GPSDetailViewController.h"
#import "GPSDetailTableViewCell.h"
@interface GPSDetailViewController ()
{
    CGRect oldFrame;
    UIImageView *fullScreenIV;
}
@end

@implementation GPSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    [self setupNavView];
    
    //[self setupView];
    [self setupTableView];
}

- (void)setupNavView{
    [super setupNavView];
    self.navView.backgroundColor = [QFTools colorWithHexString:MainColor];
    self.navView.showBottomLabel = NO;
    [self.navView.centerButton setTitle:@"GPS服务"forState:UIControlStateNormal];
    @weakify(self);
    [self.navView.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navView.leftButtonBlock = ^{
        @strongify(self);
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    
}

- (void)setupTableView{
    // cell箭头名称
    self.icon_arrow = @"arrow";
    
    // 设置相关参数
    // cell背景颜色
    self.backgroundColor_Normal = [UIColor whiteColor];
    //cell选中背景颜色
     self.backgroundColor_Selected = CFCellBackgroundColor_Highlighted;
    //cell右边Label字体
     self.rightLabelFont = [UIFont systemFontOfSize:15];
    //cell右边Label文字颜色
     self.rightLabelFontColor = CFRightLabelTextColor;
    @weakify(self);
    CFSettingLabelItem *messageItem1 =[CFSettingLabelItem itemWithIcon:@"icon1" title:@"硬件版本"];
    messageItem1.text_right = @"GPS定位器一代";
    messageItem1.opration = ^{
        
    };
    CFSettingIconItem *messageItem2 = [CFSettingIconItem itemWithIcon:@"icon1" title:@"设备二维码"];
    messageItem2.icon_right = @"gps_bg";
    messageItem2.btnOpration = ^(UIButton *btn){
        @strongify(self);
        [self tapForFullScreen:btn];
    };
    
    CFSettingLabelItem *messageItem3 = [CFSettingLabelItem itemWithIcon:@"icon1" title:@"所属车辆"];
    messageItem3.text_right = @"小毛驴电动车";
    CFSettingLabelItem *messageItem4 = [CFSettingLabelItem itemWithIcon:@"icon1" title:@"激活时间"];
    messageItem4.text_right = @"2018-03-20";
    CFSettingLabelItem *messageItem5 = [CFSettingLabelItem itemWithIcon:@"icon1" title:@"IEME"];
    messageItem5.text_right = @"8893456524256023236";
    CFSettingLabelArrowItem *messageItem6 = [CFSettingLabelArrowItem itemWithIcon:@"icon1" title:@"版本号"];
    messageItem6.text_right = @"G100.1.2.1";
    
    CFSettingGroup *group1 = [[CFSettingGroup alloc] init];
    //group1.headerHeight = 20;
    group1.items = @[ messageItem1,messageItem2,messageItem3,messageItem4,messageItem5,messageItem6];

    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    firstView.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 20)];
    title.text = @"设备信息";
    title.font = [UIFont systemFontOfSize:13];
    [firstView addSubview:title];
    group1.headerView = firstView;
    
    CFSettingLabelItem *serviceItem = [CFSettingLabelItem itemWithIcon:@"icon1" title:@"绑定时间"];
    serviceItem.text_right = @"2018-03-20";
    CFSettingLabelItem *serviceItem2 =[CFSettingLabelItem itemWithIcon:@"icon3" title:@"服务截止时间"];
    serviceItem2.text_right = @"360天";
    CFSettingArrowItem *serviceItem3 =[CFSettingArrowItem itemWithIcon:@"icon3" title:@"继续充值"];
    
    CFSettingGroup *group2 = [[CFSettingGroup alloc] init];
    group2.items = @[ serviceItem,serviceItem2,serviceItem3];
    
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    secondView.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 20)];
    title2.text = @"服务时间";
    title2.font = [UIFont systemFontOfSize:13];
    [secondView addSubview:title2];
    group2.headerView = secondView;

    
    CFSettingArrowItem *equipmentItem = [CFSettingArrowItem itemWithIcon:@"icon4" title:@"与该车解绑"];
    CFSettingLabelArrowItem *equipmentItem2 = [CFSettingLabelArrowItem itemWithIcon:@"icon2" title:@"重新绑定"];
    equipmentItem2.opration = ^{
        
    };
    
    CFSettingLabelArrowItem *equipmentItem3 = [CFSettingLabelArrowItem itemWithIcon:@"icon3" title:@"重启设备"];
    equipmentItem3.text_right = @"数据丢失等故障,可尝试";
    equipmentItem3.opration = ^{
        
    };
    
    CFSettingGroup *group3 = [[CFSettingGroup alloc] init];
    group3.items = @[ equipmentItem,equipmentItem2,equipmentItem3];
    //group3.header = @"操作设备";
    UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    thirdView.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    UILabel *title3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 20)];
    title3.text = @"操作设备";
    title3.font = [UIFont systemFontOfSize:13];
    [thirdView addSubview:title3];
    group3.headerView = thirdView;
    
    [self.dataList addObject:group1];
    [self.dataList addObject:group2];
    [self.dataList addObject:group3];
    
}

-(void)setupChildView{
    
    // cell箭头名称
    self.icon_arrow = @"arrow";
    
    // 设置相关参数
    // cell背景颜色
    self.backgroundColor_Normal = [UIColor whiteColor];
    //cell选中背景颜色
    self.backgroundColor_Selected = CFCellBackgroundColor_Highlighted;
    //cell右边Label字体
    self.rightLabelFont = [UIFont systemFontOfSize:15];
    //cell右边Label文字颜色
    self.rightLabelFontColor = CFRightLabelTextColor;
    CFSettingLabelItem *messageItem1 =[CFSettingLabelItem itemWithIcon:@"icon1" title:@"设备名称"];
    messageItem1.text_right = @"GPS定位器一代";
    
    CFSettingLabelItem *messageItem3 = [CFSettingLabelItem itemWithIcon:@"icon1" title:@"所属车辆"];
    messageItem3.text_right = @"小毛驴电动车";
    CFSettingLabelItem *messageItem4 = [CFSettingLabelItem itemWithIcon:@"icon1" title:@"激活时间"];
    messageItem4.text_right = @"2018-03-20";
    CFSettingLabelItem *messageItem5 = [CFSettingLabelItem itemWithIcon:@"icon1" title:@"IEME"];
    messageItem5.text_right = @"8893456524256023236";
    CFSettingLabelArrowItem *messageItem6 = [CFSettingLabelArrowItem itemWithIcon:@"icon1" title:@"版本号"];
    messageItem6.text_right = @"G100.1.2.1";
    
    CFSettingGroup *group1 = [[CFSettingGroup alloc] init];
    group1.items = @[ messageItem1,messageItem3,messageItem4,messageItem5,messageItem6];
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    firstView.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 20)];
    title.text = @"设备信息";
    title.font = [UIFont systemFontOfSize:13];
    [firstView addSubview:title];
    group1.headerView = firstView;
    
    CFSettingLabelItem *serviceItem = [CFSettingLabelItem itemWithIcon:@"icon1" title:@"绑定时间"];
    serviceItem.text_right = @"2018-03-20";
    CFSettingLabelItem *serviceItem2 =[CFSettingLabelItem itemWithIcon:@"icon3" title:@"服务截止时间"];
    serviceItem2.text_right = @"360天";
    
    CFSettingGroup *group2 = [[CFSettingGroup alloc] init];
    group2.items = @[ serviceItem,serviceItem2];
    
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    secondView.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 20)];
    title2.text = @"服务时间";
    title2.font = [UIFont systemFontOfSize:13];
    [secondView addSubview:title2];
    group2.headerView = secondView;
    
    
    [self.dataList addObject:group1];
    [self.dataList addObject:group2];
    
}


-(void)tapForFullScreen:(UIButton *)btn{
    UIImageView *avatarIV = (UIImageView *)btn.imageView;
    oldFrame = [avatarIV convertRect:avatarIV.frame toView:[UIApplication sharedApplication].keyWindow];
    if (fullScreenIV==nil) {
        fullScreenIV= [[UIImageView alloc]initWithFrame:avatarIV.frame];
    }
    fullScreenIV.backgroundColor = [UIColor blackColor];
    fullScreenIV.userInteractionEnabled = YES;
    fullScreenIV.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:@"gps_bg" imageViewWidth:ScreenWidth];
    fullScreenIV.contentMode = UIViewContentModeScaleAspectFit;
    [[UIApplication sharedApplication].keyWindow addSubview:fullScreenIV];
    
    [UIView animateWithDuration:0.3 animations:^{
        fullScreenIV.frame = CGRectMake(0,0,ScreenWidth, ScreenHeight);
    }];
    UITapGestureRecognizer *originalTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForOriginal:)];
    [fullScreenIV addGestureRecognizer:originalTap];
    
}

-(void)tapForOriginal:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        fullScreenIV.frame = oldFrame;
        fullScreenIV.alpha = 0.03;
    } completion:^(BOOL finished) {
        fullScreenIV.alpha = 1;
        [fullScreenIV removeFromSuperview];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
