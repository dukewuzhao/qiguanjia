//
//  DateSelectionViewController.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/14.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "DateSelectionViewController.h"
#import "LXCalender.h"
@interface DateSelectionViewController ()
@property(nonatomic,strong)LXCalendarView *calenderView;
@end

@implementation DateSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [QFTools colorWithHexString:@"ebecf2"];
    [self setupNavView];
    
    
    self.calenderView =[[LXCalendarView alloc]initWithFrame:CGRectMake(0, navHeight, ScreenWidth, 0)];
    
    self.calenderView.currentMonthTitleColor =[UIColor hexStringToColor:@"2c2c2c"];
    self.calenderView.lastMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    self.calenderView.nextMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    
    self.calenderView.isHaveAnimation = YES;
    
    self.calenderView.isCanScroll = YES;
    self.calenderView.isShowLastAndNextBtn = YES;
    
    self.calenderView.todayTitleColor =[UIColor greenColor];
    
    self.calenderView.selectBackColor =[QFTools colorWithHexString:MainColor];
    
    self.calenderView.isShowLastAndNextDate = NO;
    
    [self.calenderView dealData];
    
    self.calenderView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:self.calenderView];
    
    self.calenderView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%ld年 - %ld月 - %ld日",year,month,day);
    };
}

- (void)setupNavView{
    [super setupNavView];
    self.navView.backgroundColor = [QFTools colorWithHexString:MainColor];
    self.navView.showBottomLabel = NO;
    [self.navView.centerButton setTitle:@"日期选择" forState:UIControlStateNormal];
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
