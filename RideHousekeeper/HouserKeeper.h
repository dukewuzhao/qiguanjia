//
//  HouserKeeper.h
//  RideHousekeeper
//
//  Created by 同时科技 on 16/6/20.
//  Copyright © 2016年 Duke Wu. All rights reserved.
//

#import <Availability.h>

#ifndef __IPHONE_5_0
#warning "This project uses features only available in iOS SDK 5.0 and later."
#endif


#ifdef __OBJC__
//#define HouserKeeper_h
#define STOREAPPID @"1172731287"
#define logInUSERDIC      @"logInUserDic"     // 登录用户中心
#define passwordDIC      @"passwordDIC"     // 密码所有
#define userInfoDic      @"userInfoDic"     // 用户信息
#define SETRSSI @"selected"
#define MainColor @"#06c1ae"
#define QGJURL @"http://139.196.233.61:8888/" //远程访问ip
#define baidu @"http://api.map.baidu.com/telematics/v3/weather"
#define apple @"http://itunes.apple.com/cn/lookup"

#define TIP_OF_NO_NETWORK @"网络未连接,请检查网络配置"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define APPID_VALUE @"576a6330"
#define  LL_iPhoneX (ScreenWidth == 375.f && ScreenHeight == 812.f ? YES : NO)
#define  LL_MoreStatusBarHeight  (LL_iPhoneX ? 24.f : 0.f)
#define  navHeight  (LL_iPhoneX ? 88.f : 64.f)
#define  tabHeight  (LL_iPhoneX ? (49.f+34.f) : 49.f)
#define QGJ_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})
#define  QGJ_TabbarSafeBottomMargin   (LL_iPhoneX ? 34.f : 0.f)
#define KStatusBarHeight (LL_iPhoneX ? 24.f:0.f)
#define KStatusBarMargin (LL_iPhoneX ? 22.f:0.f)

#import "UIView+Extension.h"
#import "LxButton.h"
#import "UIColor+Expanded.h"
#import "UILabel+LXLabel.h"
#import "UIView+LX_Frame.h"
#import "UIView+FTCornerdious.h"
#import "SGQRCode.h"
#import "BaseViewController.h"
#import "AppDelegate.h"
#import "QFTools.h"
#import "ConverUtil.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "HttpRequest.h"
#import "MSWeakTimer.h"
#import "LoadView.h"
#import "YYModel.h"
#import "httpModel.h"
#import "sqliteModel.h"
#import "AnnotatedHeader.h"
#import "UIImageView+WebCache.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Masonry.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define HI_UINT16(a) (((a) >> 8) & 0xff)

#define LO_UINT16(a) ((a) & 0xff)

#define BUILD_UINT16(loByte, hiByte) ((uint16_t)(((loByte) & 0x00FF) + (((hiByte) & 0x00FF) << 8)))

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define FONT_YAHEI(s) [UIFont fontWithName:@"MicrosoftYahei" size:s]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

// 是否是iOS7
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)

#define PATHS NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)

#define HCRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:arc4random_uniform(255)/255.0]

#endif /* HouserKeeper_h */
