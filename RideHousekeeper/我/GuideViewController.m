//
//  GuideViewController.m
//  RideHousekeeper
//
//  Created by Apple on 2017/2/17.
//  Copyright © 2017年 Duke Wu. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideView.h"
#import "ABCIntroView.h"

@interface GuideViewController ()<ABCIntroViewDelegate>

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
@property UIButton *doneButton;

@property ABCIntroView *introView;
@end

@implementation GuideViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    NSArray* guideImages = @[@"qgj1",@"qgj2",@"qgj3fu",@"qgj4"];
//    GuideView* guide = [[GuideView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    guide.guideImages = guideImages;
//    [self.view addSubview:guide];
//    [UIView animateWithDuration:0.5 animations:^{
//        guide.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    }];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 40, 35)];
//    [backBtn addTarget:self action:@selector(bkBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //[self.view addSubview:backBtn];
    
    self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
    self.introView.delegate = self;
    self.introView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.introView];
    
}

-(void)onDoneButtonPressed{
    
//    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.introView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - pop
- (void)bkBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
