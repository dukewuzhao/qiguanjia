//
//  GPSServicesViewController.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/15.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "GPSServicesViewController.h"
#import "SeizeSeatView.h"
@interface GPSServicesViewController ()

@end

@implementation GPSServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    [self setupNavView];
    
    SeizeSeatView *view = [[SeizeSeatView alloc] initWithFrame:CGRectMake(0, navHeight, ScreenWidth, ScreenHeight - navHeight)];
    view.seizeImg.frame = CGRectMake(ScreenWidth*.3, ScreenHeight *.31, ScreenWidth *.4, ScreenWidth *.4 *.98);
    [view addSubview:view.seizeImg];
    view.headlinesLab.frame = CGRectMake(0, CGRectGetMaxY(view.seizeImg.frame) + 50, ScreenWidth, 20);
    [view addSubview:view.headlinesLab];
    
    view.subtitleLab.frame = CGRectMake(0, CGRectGetMaxY(view.headlinesLab.frame), ScreenWidth, 20);
    [view addSubview:view.subtitleLab];
    
    view.taggingLab.frame = CGRectMake(0, ScreenHeight - navHeight - 55, ScreenWidth, 40);
    [view addSubview:view.taggingLab];
    
    view.seizeImg.image = [UIImage imageNamed:@"no_bikeGPS"];
    view.headlinesLab.textColor = [QFTools colorWithHexString:@"#cccccc"];
    view.headlinesLab.text = @"您的爱车还未添加GPS";
    view.subtitleLab.text = @"可到门店购买安装";
    view.taggingLab.text = @"注:安装好后直接扫描GPS上二维码与电动车绑定";
    [self.view addSubview:view];
    
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
