//
//  BikeMessageViewController.m
//  RideHousekeeper
//
//  Created by Apple on 2018/3/15.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "BikeMessageViewController.h"
#import "BikeMessageTableViewCell.h"
#import "SeizeSeatView.h"
#import "MessageFootview.h"
@interface BikeMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,strong) UITableView *TableView;
@property (nonatomic,strong) MessageFootview *messageView;
@property (nonatomic,strong) NSMutableArray *selectAry;
@end

@implementation BikeMessageViewController

-(NSMutableArray *)selectAry{
    
    if (!_selectAry) {
        _selectAry = [NSMutableArray new];
    }
    return _selectAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    [self setupNavView];
    
    for (int i = 0; i < 2; i++) {
        [self.selectAry addObject:@"0"];
    }
    
    [self setupTableview];

}

-(void)setupTableview{
    
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHeight , self.view.size.width, ScreenHeight - navHeight) style:UITableViewStylePlain];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    //TableView.scrollEnabled = NO;
    //TableView.separatorStyle = NO;
    [_TableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_TableView];
}

- (void)setupNavView{
    [super setupNavView];
    self.navView.backgroundColor = [QFTools colorWithHexString:MainColor];
    self.navView.showBottomLabel = NO;
    [self.navView.centerButton setTitle:@"消息通知"forState:UIControlStateNormal];
    @weakify(self);
    [self.navView.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navView.leftButtonBlock = ^{
        @strongify(self);
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.navView.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.navView.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navView.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navView.rightButtonBlock = ^{
        @strongify(self);
        
        self.isEdit = !self.isEdit;
        
        
        if (self.isEdit) {
            self.messageView = [MessageFootview new];
            self.messageView.delClickBlock = ^(NSInteger num){
                @strongify(self);
                if (num == 1) {
                    
                    for (int i = 0; i < self.selectAry.count; i++) {
                        self.selectAry[i] = @"1";
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self-> _TableView reloadData];
                    });
                    
                }else{
                    
                    if (![self.selectAry containsObject:@"1"]) {
                        [SVProgressHUD showSimpleText:@"请先选择"];
                    }
                    
                }
                
            };
            [self.messageView showInView:self.view];
        }else{
            
            [self.messageView disMissView];
        
        }
        
        __block BikeMessageViewController *blockSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [blockSelf-> _TableView reloadData];
        });
        
    };
    
}

-(void)noMessage{
    
    SeizeSeatView *view = [[SeizeSeatView alloc] initWithFrame:CGRectMake(0, navHeight, ScreenWidth, ScreenHeight - navHeight)];

    view.seizeImg.frame = CGRectMake(ScreenWidth*.3, ScreenHeight *.31, ScreenWidth *.4, ScreenWidth *.4 *1.354);
    [view addSubview:view.seizeImg];
    view.headlinesLab.frame = CGRectMake(0, CGRectGetMaxY(view.seizeImg.frame) + 50, ScreenWidth, 20);
    [view addSubview:view.headlinesLab];

    view.seizeImg.image = [UIImage imageNamed:@"no_bikemessage"];
    view.headlinesLab.textColor = [QFTools colorWithHexString:@"#cccccc"];
    view.headlinesLab.text = @"暂无消息";
    [self.view addSubview:view];
}

#pragma mark --- tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BikeMessageTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    if (!cell) {
        cell = [[BikeMessageTableViewCell alloc] initWithStyle:0 reuseIdentifier:@"messageCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.newsType.text = @"系统消息";
        cell.dateLab.text = @"2017-11-04 10:28";
        cell.versionRemindType.frame = CGRectMake(15, 8, ScreenWidth - cell.dateLab.x - 50, 15);
        cell.versionRemindType.text = @"版本更新提醒";
        [cell.footView addSubview:cell.versionRemindType];
        
        cell.RemindLab.frame = CGRectMake(15, CGRectGetMaxY(cell.versionRemindType.frame) + 3, ScreenWidth - cell.dateLab.x - 50, 15);
        cell.RemindLab.text = @"v2.1.1已更新";
        [cell.footView addSubview:cell.RemindLab];
    }else{
        
        cell.newsType.text = @"车辆消息";
        cell.dateLab.text = @"2017-11-04 10:28";
        cell.versionRemindType.frame = CGRectMake(15, cell.footView.height/2 - 7.5, ScreenWidth - cell.dateLab.x - 50, 15);
        cell.versionRemindType.text = @"车辆严重震动";
        [cell.footView addSubview:cell.versionRemindType];
        [cell.RemindLab removeFromSuperview];
        
    }
    
    if (self.isEdit) {
        cell.selectBtn.hidden = NO;
    }else{

        cell.selectBtn.hidden = YES;
    }
    
    if ([self.selectAry[indexPath.row] isEqualToString:@"0"]) {
        [cell.selectBtn setImage:[UIImage imageNamed:@"message_circle"] forState:UIControlStateNormal];
    }else{
        
        [cell.selectBtn setImage:[UIImage imageNamed:@"message_select"] forState:UIControlStateNormal];
    }
    
    cell.selectBtn.tag = indexPath.row;
    [cell.selectBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

-(void)clickBtn:(UIButton *)btn{
    
    if ([self.selectAry[btn.tag] isEqualToString:@"0"]) {
        self.selectAry[btn.tag] = @"1";
    }else{
        self.selectAry[btn.tag] = @"0";
    }
   
    
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    [self.TableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)dealloc{
    
    if (self.isEdit) {
        [self.messageView disMissView];
    }
    self.messageView = nil;
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
