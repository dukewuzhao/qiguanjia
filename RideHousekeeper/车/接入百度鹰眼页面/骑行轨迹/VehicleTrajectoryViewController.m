//
//  VehicleTrajectoryViewController.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/8.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "VehicleTrajectoryViewController.h"
#import "TrajectoryTableViewCell.h"
#import "TrafficReportHeadView.h"
#import "NoticeTableViewCell.h"
#import "DateSelectionViewController.h"
@interface VehicleTrajectoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation VehicleTrajectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    // Do any additional setup after loading the view.
    [self setupNavView];
    
    [self setupMainView];
}

- (void)setupNavView{
    [super setupNavView];
    self.navView.backgroundColor = [QFTools colorWithHexString:MainColor];
    self.navView.showBottomLabel = NO;
    [self.navView.centerButton setTitle:@"骑行轨迹" forState:UIControlStateNormal];
    @weakify(self);
    [self.navView.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navView.leftButtonBlock = ^{
        @strongify(self);
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.navView.rightButton setImage:[UIImage imageNamed:@"date_selection"] forState:UIControlStateNormal];
    self.navView.rightButtonBlock = ^{
        @strongify(self);
        
        [self.navigationController pushViewController:[DateSelectionViewController new] animated:YES];
    };
}

-(void)setupMainView{
    
    UITableView *trajectoryTab = [[UITableView alloc] initWithFrame:CGRectMake(0, navHeight, ScreenWidth, ScreenHeight - navHeight) style:UITableViewStyleGrouped];
    trajectoryTab.delegate = self;
    trajectoryTab.dataSource = self;
    trajectoryTab.backgroundColor = [UIColor clearColor];
    trajectoryTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[trajectoryTab setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:trajectoryTab];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 9;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row%2 == 0) {
        
        return 45.0f;
    }else{
        
        return 90.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TrafficReportHeadView * header = [[TrafficReportHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}
- ( void )tableView:( UITableView  *)tableView  willDisplayCell :( UITableViewCell  *)cell  forRowAtIndexPath :( NSIndexPath  *)indexPath{

    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    
    view.tintColor = [QFTools colorWithHexString:@"#cccccc"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row%2 == 0) {
        
        NoticeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"notice"];
        if (!cell) {
            cell = [[NoticeTableViewCell alloc] initWithStyle:0 reuseIdentifier:@"notice"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        TrajectoryTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"trajectory"];
        if (!cell) {
            cell = [[TrajectoryTableViewCell alloc] initWithStyle:0 reuseIdentifier:@"trajectory"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
