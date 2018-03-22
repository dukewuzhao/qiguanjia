//
//  BindingGPSViewController.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/13.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "BindingGPSViewController.h"
#import "GPSHeadView.h"
#import "GPSFootView.h"

@interface BindingGPSViewController ()

@property (nonatomic,strong) GPSHeadView *headView;

@property (nonatomic,strong) GPSFootView *footview;
@end

@implementation BindingGPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    [self setupNavView];
    [self setupMainView];
}

- (void)setupNavView{
    [super setupNavView];
    self.navView.backgroundColor = [QFTools colorWithHexString:MainColor];
    self.navView.showBottomLabel = NO;
    [self.navView.centerButton setTitle:@"绑定智能配件" forState:UIControlStateNormal];
    @weakify(self);
    [self.navView.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navView.leftButtonBlock = ^{
        @strongify(self);
        
        [self.navigationController popViewControllerAnimated:YES];
    };
}

-(void)setupMainView{
    
    _headView = [[GPSHeadView alloc] initWithFrame:CGRectMake(0, navHeight, ScreenWidth, ScreenHeight*.412)];
    _headView.backgroundColor = [QFTools colorWithHexString:MainColor];
    [self.view addSubview:_headView];
    __block NSInteger i = 0;
    _footview = [[GPSFootView alloc] initWithFrame:CGRectMake(17, CGRectGetMaxY(_headView.frame) - 20, ScreenWidth - 34, ScreenHeight *.494)];
    _footview.backgroundColor = [UIColor whiteColor];
    _footview.layer.cornerRadius = 10;
    _footview.layer.masksToBounds = YES;
    @weakify(self);
    _footview.btnStopClickBlock = ^{
        @strongify(self);
        GPSFootModel *model1 = self.footview.titleArray[i];
        i ++;
        GPSFootModel *model2 = self.footview.titleArray[i];
        model1.styleNum = imgComplete;
        model2.styleNum = imgCheck;
        if (i == 1) {
            [self.headView.gpsImageView stopAnimating];
           YYImage *image = [YYImage imageNamed:@"gps_connect_CentralControl.gif"];
            self.headView.gpsImageView.image = image;
            [self.headView.gpsImageView startAnimating];
        
        }else if (i == 2){
            [self.headView.gpsImageView stopAnimating];
            YYImage *image = [YYImage imageNamed:@"query_SIM_network.gif"];
            self.headView.gpsImageView.image = image;
            [self.headView.gpsImageView startAnimating];
        }else if (i == 3){
            [self.headView.gpsImageView stopAnimating];
            YYImage *image = [YYImage imageNamed:@"gps_search_satellite.gif"];
            self.headView.gpsImageView.image = image;
            [self.headView.gpsImageView startAnimating];
        }else if (i == 4){
            [self.headView.gpsImageView stopAnimating];
            YYImage *image = [YYImage imageNamed:@"connect_server.gif"];
            self.headView.gpsImageView.image = image;
            [self.headView.gpsImageView startAnimating];
        }else if (i == 5){
            [self.headView.gpsImageView stopAnimating];
            YYImage *image = [YYImage imageNamed:@"gps_upload_coordinates.gif"];
            self.headView.gpsImageView.image = image;
            [self.headView.gpsImageView startAnimating];
        }else if (i == 6){
            model2.styleNum = imgComplete;
            [self.headView.gpsImageView stopAnimating];
            YYImage *image = [YYImage imageNamed:@"gps_complete.gif"];
            self.headView.gpsImageView.image = image;
            [self.headView.gpsImageView startAnimating];
            i = 0;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // something
            [self.footview.checkTab reloadData];
        });
        
    };
    [self.view addSubview:_footview];
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
