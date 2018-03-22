//
//  BaseViewController.m
//  MMDrawerControllerDemo
//
//  Created by 谢涛 on 16/5/31.
//  Copyright © 2016年 X.T. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@property (nonatomic, copy) RightBarButtonActionBlock rightBarButtonAction;
@property (nonatomic, copy) LeftBarButtonActionBlock leftBarButtonAction;
@end

@implementation BaseViewController

- (void)pushNewViewController:(UIViewController *)newViewController {
    [self.navigationController pushViewController:newViewController animated:YES];
}

- (void)configureNavgationItemTitle:(NSString *)navigationTitle {
    self.navigationItem.title = navigationTitle;
}

- (void)clickedLeftBarButtonItemAction
{
    if (self.leftBarButtonAction) {
        self.leftBarButtonAction();
    }
}

- (void)clickedRightBarButtonItemAction
{
    if (self.rightBarButtonAction) {
        self.rightBarButtonAction();
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

-(ZMNavView *)navView{
    if (!_navView) {
        ZMNavView *navView = [[ZMNavView alloc] init];
        [self.view addSubview:navView];
        navView.backgroundColor = [UIColor whiteColor];
        self.navView = navView;
        [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(navHeight);
        }];
        [self.navView.superview layoutIfNeeded];
    }
    return _navView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取导航栏下面黑线
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //隐藏自带的导航栏
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 加载自定义导航
- (void)setupNavView{
    [self navView];
}


#pragma mark - 点击屏幕取消键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)dealloc{

    NSLog(@"baseview被释放了");
}



@end
