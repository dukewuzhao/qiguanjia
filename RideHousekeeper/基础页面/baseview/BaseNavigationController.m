//
//  BaseNavigationController.m
//  Timeshutter
//
//  Created by Brance on 2017/11/24.
//  Copyright © 2017年 292692700@qq.com. All rights reserved.
//

#import "BaseNavigationController.h"
#import "AnimationObject.h"
#import "VehiclePositionViewController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>
@property (strong, nonatomic) UIView *bottomNavLine;
@end

@implementation BaseNavigationController

-(UIView *)bottomNavLine{
    if (!_bottomNavLine) {
        _bottomNavLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 1.0/ [UIScreen mainScreen].scale)];
        _bottomNavLine.backgroundColor = [QFTools colorWithHexString:@"0xDCDCDC"];
    }
    return _bottomNavLine;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //藏旧
//    [self hideBorderInView:self.navigationBar];
//    //添新
//    [self.navigationBar addSubview:self.bottomNavLine];
    
}

- (void)hideBorderInView:(UIView *)view{
    if ([view isKindOfClass:[UIImageView class]]
        && view.frame.size.height <= 1) {
        view.hidden = YES;
    }
    for (UIView *subView in view.subviews) {
        [self hideBorderInView:subView];
    }
}

- (void)showNavBottomLine{
    _bottomNavLine.hidden = NO;
}

- (void)hideNavBottomLine{
    [self hideBorderInView:self.navigationBar];
    if (_bottomNavLine) {
        _bottomNavLine.hidden = YES;
    }
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.statusBarStyle = UIStatusBarStyleDefault;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarStyle;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;//隐藏二级页面的tabbar
    }
    [super pushViewController:viewController animated:animated];
    
}

#pragma mark - 跳转动画
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    
//    if (([fromVC isKindOfClass:[BikeViewController class]]&&[toVC isKindOfClass:[VehiclePositionViewController class]]) || ([fromVC isKindOfClass:[VehiclePositionViewController class]]&&[toVC isKindOfClass:[BikeViewController class]])) {
//
//        AnimationObject *animation = [[AnimationObject alloc] init];
//
//        if (operation==UINavigationControllerOperationPush) {
//            animation.type = AnimationTypeGoNewVC;
//        }else{
//            animation.type = AnimationTypeBack;
//        }
//        animation.circleCenterRect = CGRectMake(5, 64, 50, 20);
//        return animation;
//    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
