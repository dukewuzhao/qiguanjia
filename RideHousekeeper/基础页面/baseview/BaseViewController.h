//
//  BaseViewController.h
//  MMDrawerControllerDemo
//
//  Created by 谢涛 on 16/5/31.
//  Copyright © 2016年 X.T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMNavView.h"


typedef void (^RightBarButtonActionBlock) (void);
typedef void (^LeftBarButtonActionBlock) (void);

@interface BaseViewController : UIViewController
@property (nonatomic, strong) ZMNavView       *navView;

- (void)setupNavView;
/**
 *  push新的控制器到导航控制器
 *
 *  @param newViewController 目标新的视图控制器
 */
- (void)pushNewViewController:(UIViewController *)newViewController;


@end
