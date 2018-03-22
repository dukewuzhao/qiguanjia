//
//  MessageFootview.h
//  RideHousekeeper
//
//  Created by Apple on 2018/3/16.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MessageFootview : UIView
{
    UIView *_mainView;
    UIView *_contentView;
}

- (void)showInView:(UIView *)view ;
- (void)disMissView;

@property (nonatomic, copy) void (^ delClickBlock)(NSInteger num);

@end
