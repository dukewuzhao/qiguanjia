//
//  AboutQGJViewController.m
//  RideHousekeeper
//
//  Created by smartwallit on 16/8/15.
//  Copyright © 2016年 Duke Wu. All rights reserved.
//

#import "AboutQGJViewController.h"
#import "AgreementViewController.h"
#import "GuideViewController.h"

@interface AboutQGJViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *datarray;
}

@property(nonatomic,weak) UILabel *edition;

@end

@implementation AboutQGJViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    
     datarray = [NSMutableArray arrayWithObjects:@"用户服务协议",@"介绍动画",nil];
    
    [self setupNavView];
    
    [self setuptable];
}

- (void)setupNavView{
    [super setupNavView];
    self.navView.backgroundColor = [QFTools colorWithHexString:MainColor];
    self.navView.showBottomLabel = NO;
    [self.navView.centerButton setTitle:@"关于骑管家" forState:UIControlStateNormal];
    @weakify(self);
    [self.navView.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navView.leftButtonBlock = ^{
        @strongify(self);
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    
}

- (void)setuptable{

    UIImageView *qgjIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - ScreenHeight *.075, ScreenHeight *.1, ScreenHeight *.15,ScreenHeight*.15*1.2)];
    qgjIcon.image = [UIImage imageNamed:@"logo_1"];
    [self.view addSubview:qgjIcon];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(qgjIcon.frame)+ ScreenHeight*.1, ScreenWidth, ScreenHeight *.4)];
    table.bounces = NO;
    table.separatorStyle = NO;
    table.backgroundColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    [table setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:table];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return datarray.count *2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row %2 == 0) {
        return 45;
    }else{
    
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    if (indexPath.row %2 == 0) {
        
        cell.textLabel.text = datarray[indexPath.row/2];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        if (indexPath.row == 0 || indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        
    }else{
        cell.userInteractionEnabled = NO;
            }
    //cell.textLabel.text = datarray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        AgreementViewController *agreeVc = [AgreementViewController new];
        
        [self.navigationController pushViewController:agreeVc animated:YES];
        
    }else if (indexPath.row == 2){
        
        GuideViewController *guideVc = [GuideViewController new];
        
        [self.navigationController pushViewController:guideVc animated:YES];
    
    }
    
}

- ( void )tableView:( UITableView  *)tableView  willDisplayCell :( UITableViewCell  *)cell  forRowAtIndexPath :( NSIndexPath  *)indexPath
{
    if (indexPath.row%2) {
        //cell.backgroundColor = [UIColor colorWithRed:30.0/255 green:36.0/255 blue:49.0/255 alpha:1.0];
        cell.backgroundColor = [UIColor clearColor];
    }else{
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
        
        
    }
}


//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return  10;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *interval = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 10)];
//    interval.backgroundColor = [UIColor blackColor];
//    return interval;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
