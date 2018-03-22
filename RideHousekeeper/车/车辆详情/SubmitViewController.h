//
//  SubmitViewController.h
//  RideHousekeeper
//
//  Created by smartwallit on 16/7/14.
//  Copyright © 2016年 Duke Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubmitDelegate <NSObject>

@optional
-(void) addViewControllerdidAddString:(NSString *) nameText deviceTag:(NSInteger)deviceNum;

-(void) submitBegainUpgrate;

-(void) submitUnbundDevice:(NSInteger)bikeid;

@end

@interface SubmitViewController : BaseViewController

@property(nonatomic,assign) NSInteger deviceNum;
@property(nonatomic,strong) NSString* keystate;
@property (nonatomic,weak) id<SubmitDelegate> delegate;
@end


