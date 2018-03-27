//
//  GPSServicesViewController.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/15.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "GPSServicesViewController.h"
#import "GPSDetailViewController.h"
#import "GPSServiceTableViewCell.h"
#import "SeizeSeatView.h"

@interface GPSServicesViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GPSServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    [self setupNavView];
    
    [self setupView];
    
}

-(void)setupView{
    
    UITableView *listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHeight, ScreenWidth, ScreenHeight - navHeight - QGJ_TabbarSafeBottomMargin)];
    listTableView.backgroundColor = [UIColor clearColor];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:listTableView];
}

-(void)NoGPSService{
    
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

#pragma mark -- TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [UIView new];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [UIView new];
    return footerView;
}

- ( void )tableView:( UITableView  *)tableView  willDisplayCell :( UITableViewCell  *)cell  forRowAtIndexPath :( NSIndexPath  *)indexPath
{
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    
    view.tintColor = [QFTools colorWithHexString:@"#ebecf2"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPSServiceTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"GPSCell"];
    if (!cell) {
        cell = [[GPSServiceTableViewCell alloc] initWithStyle:0 reuseIdentifier:@"GPSCell"];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.GPSmage.image = [UIImage imageNamed:@"gps_bg"];
    cell.GPSnameLab.text = @"GPS定位器";
    cell.bikeName.text = @"小毛驴电动车";
    cell.usericon.image = [UIImage imageNamed:@"GPS_user_icon"];
    cell.phone.text = @"13685235986";
    cell.dayLeft.text = @"360天";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[GPSDetailViewController new] animated:YES];
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
