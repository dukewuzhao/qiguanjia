//
//  MessageFootview.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/16.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "MessageFootview.h"

@implementation MessageFootview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self initContent];
    }
    
    return self;
}

- (void)initContent
{
    
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 47, ScreenWidth, 47)];
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 47)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_mainView addSubview:_contentView];
    }
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    [view addSubview:_mainView];
    [_mainView addSubview:_contentView];
    
    UIButton *allSelect = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 47)];
    //[allSelect setImage:[UIImage imageNamed:@"message_circle"] forState:UIControlStateNormal];
    [allSelect setTitle:@"全选" forState:UIControlStateNormal];
    [allSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    @weakify(self);
    [[allSelect rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.delClickBlock) {
            self.delClickBlock(1);
        }
    }];
    allSelect.backgroundColor = [UIColor blueColor];
    [_contentView addSubview:allSelect];
    
    UIButton *allDelete = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 47)];
    //[allDelete setImage:[UIImage imageNamed:@"message_circle"] forState:UIControlStateNormal];
    [allDelete setTitle:@"删除" forState:UIControlStateNormal];
    [allDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[allDelete rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self);
        if (self.delClickBlock) {
            self.delClickBlock(2);
        }
    }];
    allDelete.backgroundColor = [UIColor blueColor];
    [_contentView addSubview:allDelete];
    
    
    [_contentView setFrame:CGRectMake(0, 47, ScreenWidth, 47)];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(0, 0, ScreenWidth, 47)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView
{
    [_contentView setFrame:CGRectMake(0, 0, ScreenWidth, 47)];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         
                         _mainView.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 47)];
                     }
                     completion:^(BOOL finished){
                         
                         [_mainView removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
}

- (void)sexChooseClicked:(UITapGestureRecognizer *)gesture {
    
    
    if ([gesture view].tag == 70) {
        
        
        
    }else if ([gesture view].tag == 71) {
        
        
        
        
    }
    
}

@end
