//
//  nameTextFiledController.h
//  阿尔卑斯
//
//  Created by 同时科技 on 16/7/19.
//  Copyright © 2016年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol nameTextDelegate <NSObject>

@optional
-(void) addViewControllerdidAddString:(NSString *) school;

@end
@interface nameTextFiledController : BaseViewController

@property(nonatomic,assign) NSInteger deviceNum;
@property (nonatomic,weak) id<nameTextDelegate> delegate;
@end
