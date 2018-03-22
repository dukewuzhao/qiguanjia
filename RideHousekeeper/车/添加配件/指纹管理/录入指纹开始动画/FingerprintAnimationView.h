//
//  FingerprintAnimationView.h
//  RideHousekeeper
//
//  Created by Apple on 2018/3/21.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FingerprintAnimationView : UIView
@property (nonatomic, strong) dispatch_source_t timer;
@end
