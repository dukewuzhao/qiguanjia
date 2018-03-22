//
//  BikeViewController.m
//  RideHousekeeper
//
//  Created by 同时科技 on 16/6/20.
//  Copyright © 2016年 Duke Wu. All rights reserved.
//

#import "BikeViewController.h"
#import "AddBikeViewController.h"
#import "BindingUserViewController.h"
#import "SubmitViewController.h"
#import "FaultViewController.h"
//#import "TwoDimensionalCodecanViewController.h"
#import "DeviceModel.h"
#import "AccessoriesViewController.h"
#import "SideMenuViewController.h"
#import "Constants.h"
#import "AppFilesViewController.h"
#import "UserFilesViewController.h"
#import "SSZipArchive.h"
#import "UnzipFirmware.h"
#import "Utility.h"
#import "DFUHelper.h"
#import "LrdOutputView.h"
#import "QuartzCore/QuartzCore.h" 
#import "CustomProgress.h"
#import "FaultModel.h"
#import "DfuDownloadFile.h"
#import "WuPageControl.h"
#import "DroppyScrollView.h"
#import "CustomBike.h"
#import "BindingGPSViewController.h"
@interface BikeViewController ()<ScanDelegate,UIAlertViewDelegate,SubmitDelegate,AddBikeDelegate,DfuDownloadFileDelegate,LrdOutputViewDelegate>

{
    NSMutableArray *rssiList;//搜索到的车辆的model数组
    NSMutableDictionary *uuidarray;//UUID字典
    NSInteger Inductionvalue;//手机感应的rssi值
    NSString *querydate;//查询的车辆蓝牙返回信息
    NSString *downloadhttp;//固件升级包地址
    NSString *uuidstring;//要连接车辆的UUID
    NSString *editionname;//固件版本号
    BOOL chamberpot;//座桶是否打开
    BOOL fortification;//是否设防
    BOOL powerswitch;//电源是否打开
    BOOL riding;//是否骑行中
    BOOL keyInduction;//感应钥匙是否打开
    BOOL phoneInduction;//手机感应是否打开
    CustomProgress *custompro;//自定义固件升级界面
    NSInteger touchCount;//座桶锁点击频率限制
}
@property (nonatomic, strong) NSString          *latest_version;//最新的固件版本号
@property (nonatomic ,weak) UIWindow            *backView;//固件升级的背景窗口
@property(nonatomic, assign) NSInteger          bikeid;//车辆id
@property(nonatomic, strong) NSString           *mac;//车辆mac地址
@property(nonatomic, assign) NSInteger          ownerflag;//主与子用户分别
@property(nonatomic, weak) NSString             *password;//设备写入密码
@property(nonatomic, strong) MSWeakTimer        *queraTime;//0.5秒的计时器，用于查询数据
@property(nonatomic,strong)FaultModel           *faultmodel;//故障model
@property (nonatomic, strong) LrdOutputView     *outputView;//右上角弹出按钮
@property (nonatomic, weak) LrdCellModel        *Lrdmodel;//弹出界面model
@property (nonatomic, strong) NSArray           *chooseArray;//获取弹出界面model的数组
@property (strong, nonatomic)  WuPageControl    *pageControl;
@property (strong, nonatomic) CBPeripheral      *selectedPeripheral;//选中的固件升级的设备
@property (strong, nonatomic) DFUOperations     *dfuOperations;
@property (strong, nonatomic) DFUHelper         *dfuHelper;
@property (strong, nonatomic) NSString          *selectedFileType;

@property (nonatomic, strong)UIAlertView        *BluetoothUpgrateAlertView;
@property(nonatomic,strong)NSMutableArray       *customViewAry;// 主界面数组

@property BOOL isTransferring;
@property BOOL isTransfered;
@property BOOL isTransferCancelled;
@property BOOL isConnected;
@property BOOL isErrorKnown;

@property (nonatomic, strong) DroppyScrollView *droppy;
@property (nonatomic, assign) NSInteger index;

@end

@implementation BikeViewController

@synthesize selectedPeripheral;//选中的固件升级的设备
@synthesize dfuOperations;//
@synthesize selectedFileType;//升级包格式


- (FaultModel *)faultmodel {
    if (!_faultmodel) {
        _faultmodel = [[FaultModel alloc] init];
    }
    return _faultmodel;
}

- (NSMutableArray *)customViewAry {
    if (!_customViewAry) {
        _customViewAry = [NSMutableArray new];
    }
    return _customViewAry;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegate currentAppDelegate].device.scanDelete = self;
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.navigationController.navigationBar.barTintColor = [QFTools colorWithHexString:MainColor];
    NSString*deviceuuid=[USER_DEFAULTS stringForKey:Key_DeviceUUID];
    if ([AppDelegate currentAppDelegate].isPop && [QFTools isBlankString:deviceuuid] && [AppDelegate currentAppDelegate].device.blueToothOpen && [[QFTools currentViewController] isKindOfClass:[BikeViewController class]]) {
        
        [[AppDelegate currentAppDelegate].device startScan];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSString*deviceuuid=[USER_DEFAULTS stringForKey:Key_DeviceUUID];
    //if DFU peripheral is connected and user press Back button then disconnect it
    if ([AppDelegate currentAppDelegate].isPop && [QFTools isBlankString:deviceuuid]) {
        
        [[AppDelegate currentAppDelegate].device stopScan];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavView];
    
    PACKETS_NOTIFICATION_INTERVAL=10;
    
    dfuOperations = [[DFUOperations alloc] initWithDelegate:self];
    
    self.dfuHelper = [[DFUHelper alloc] initWithData:dfuOperations];
    
    rssiList=[[NSMutableArray alloc]init];
    
    uuidarray=[[NSMutableDictionary alloc]init];
    
    [NSNOTIC_CENTER addObserver:self selector:@selector(BikeViewquerySuccess:) name:KNotification_QueryData object:nil];
    
    [NSNOTIC_CENTER addObserver:self selector:@selector(remoteJpush:) name:KNotification_RemoteJPush object:nil];
    
    [NSNOTIC_CENTER addObserver:self selector:@selector(updatevalue:) name:KNotification_UpdateValue object:nil];
    
    [NSNOTIC_CENTER addObserver:self selector:@selector(queryInduction:) name:@"Inductionswitch" object:nil];
    
    [NSNOTIC_CENTER addObserver:self selector:@selector(updateDeviceStatusAction:) name:KNotification_UpdateDeviceStatus object:nil];
    
    [NSNOTIC_CENTER addObserver:self selector:@selector(editionData:) name:KNotification_UpdateeditionValue object:nil];
    
    [[[NSNOTIC_CENTER rac_addObserverForName:KNotification_BluetoothPowerOn object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSString*deviceuuid=[USER_DEFAULTS stringForKey:Key_DeviceUUID];
        if ([[QFTools currentViewController] isKindOfClass:[BikeViewController class]] && [QFTools isBlankString:deviceuuid]) {
            
            [[AppDelegate currentAppDelegate].device startScan];
        }
    }];
    
    [[[NSNOTIC_CENTER rac_addObserverForName:KNotification_BluetoothPowerOff object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSString*deviceuuid=[USER_DEFAULTS stringForKey:Key_DeviceUUID];
        if ([[QFTools currentViewController] isKindOfClass:[BikeViewController class]] && [QFTools isBlankString:deviceuuid]) {
            
            [[AppDelegate currentAppDelegate].device stopScan];
        }
    }];
    
    
    [self setupmenu];
    [self setupBikeMenu];
    
    UIWindow *backView = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    backView.windowLevel = UIWindowLevelAlert;
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    self.backView = backView;
    backView.hidden = YES;
    
    custompro = [[CustomProgress alloc] initWithFrame:CGRectMake(50, self.view.centerY - 10, self.view.frame.size.width-100, 20)];
    custompro.maxValue = 100;
    custompro.leftimg.image = [UIImage imageNamed:@"leftimg"];
    custompro.bgimg.image = [UIImage imageNamed:@"bgimg"];
    custompro.instruc.image = [UIImage imageNamed:@"bike"];
    [backView addSubview:custompro];
    
}

-(void)setupBikeMenu{
    
    self.queraTime = [MSWeakTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(queryFired:) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    [self performSelector:@selector(datatimeFired) withObject:nil  afterDelay:1.0];
    self.droppy = [[DroppyScrollView alloc] initWithFrame:CGRectMake(0, navHeight, ScreenWidth, ScreenHeight - navHeight)];
    [self.droppy setDefaultDropLocation:DroppyScrollViewDefaultDropLocationBottom];
    [self.view addSubview:self.droppy];
    @weakify(self);
    self.droppy.scrollViewIndex = ^(NSInteger index){
        @strongify(self);
        
        self.pageControl.currentPage = index;
        self.index = index;
        NSMutableArray *bikeAry = [LVFmdbTool queryBikeData:nil];
        BikeModel *bikemodel = bikeAry[index];
        [self switchingVehicle:bikemodel.bikeid];
        
    };
    
    [self.view addSubview:self.pageControl];
    
    [self setupScroview];
}

-(WuPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[WuPageControl alloc] initWithFrame:CGRectMake(40, ScreenHeight - 20, ScreenWidth - 80, 20)];
        [_pageControl setValue:[UIImage imageNamed:@"bike_select"] forKeyPath:@"_currentPageImage"];
        [_pageControl setValue:[UIImage imageNamed:@"bike_unselect"] forKeyPath:@"_pageImage"];
    }
    return _pageControl;
}

#pragma mark - 车辆的连接状态改变的通知
-(void)updateDeviceStatusAction:(NSNotification*)notification{
    CustomBike *custombike = [self.customViewAry objectAtIndex:self.index];
    if([AppDelegate currentAppDelegate].device.deviceStatus == 0){
        editionname = nil;
        [custombike viewReset];
        
    }else if([AppDelegate currentAppDelegate].device.deviceStatus>=2 &&[AppDelegate currentAppDelegate].device.deviceStatus<5){
        
        
    }else{
        editionname = nil;
        custombike.bikeHeadView.bikeLogo.image = [UIImage imageNamed:@"logo"];
        [self.navView.centerButton setTitle:@"车辆名称" forState:UIControlStateNormal];
        [custombike viewReset];
    }
}

- (void)setupNavView{
    [super setupNavView];
    self.navView.backgroundColor = [QFTools colorWithHexString:MainColor];
    self.navView.showBottomLabel = NO;
    [self.navView.centerButton setTitle:@"智能电动车" forState:UIControlStateNormal];
    @weakify(self);
    
    [self.navView.leftButton setImage:[UIImage imageNamed:@"open_slide_menu"] forState:UIControlStateNormal];
    self.navView.leftButtonBlock = ^{
        @strongify(self);
        [self XYSideOpenVC];
    };
    
    [self.navView.rightButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    self.navView.rightButtonBlock  = ^{
        @strongify(self);
        
        [self showaddView];
    };
}

#pragma mark -  LrdOutputView
-(void)showaddView{
    
    CGFloat x = ScreenWidth - 15;
    CGFloat y = navHeight +5;
    _outputView = [[LrdOutputView alloc] initWithDataArray:self.chooseArray origin:CGPointMake(x, y) width:100 height:44 direction:kLrdOutputViewDirectionRight];
    _outputView.delegate = self;
    _outputView.dismissOperation = ^(){
        _outputView = nil;
    };
    [_outputView pop];
}

#pragma mark - 收到远程jpush的逻辑处理
-(void)remoteJpush:(NSNotification *)data{

    NSNumber *bikeid = data.userInfo[@"bikeid"];
    NSNumber *type = data.userInfo[@"type"];
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM induction_modals WHERE bikeid LIKE '%zd'", bikeid.intValue];
    
    NSMutableArray *inducmodals = [LVFmdbTool queryInductionData:nil];
    if (inducmodals.count != 0) {
        [LVFmdbTool deleteInductionData:deleteSql];
    }
    
    if (type.intValue == 1 || type.intValue == 3) {
        
        for (int i = 0;i<self.customViewAry.count;i++) {
            if ([self.customViewAry[i] bikeid] == bikeid.integerValue) {
                
                [self.customViewAry removeObjectAtIndex:i];
                [self.droppy removeSubviewAtIndex:i];
            }
        }
        
        self.pageControl.numberOfPages = self.customViewAry.count;
        if (self.customViewAry.count <=1) {
            
            self.pageControl.hidden = YES;
        }else{
            
            self.pageControl.hidden = NO;
        }
        
        if (bikeid.intValue == self.bikeid) {
            [[AppDelegate currentAppDelegate].device remove];
            [USER_DEFAULTS removeObjectForKey:Key_DeviceUUID];
            [USER_DEFAULTS removeObjectForKey:Key_MacSTRING];
            [USER_DEFAULTS removeObjectForKey:SETRSSI];
            [USER_DEFAULTS removeObjectForKey:passwordDIC];
            [USER_DEFAULTS synchronize];
            [AppDelegate currentAppDelegate]. device.deviceStatus=0;
            
            self.pageControl.currentPage = 0;
            self.index = 0;
            self.droppy.selectIndex = 0;
            NSMutableArray *bikeAry = [LVFmdbTool queryBikeData:nil];
            BikeModel *bikemodel = bikeAry.firstObject;
            [self switchingVehicle:bikemodel.bikeid];//默认连接第一辆车
        }else{
            
            [self setupPagecontrolNumber];
        }
                
    }else if (type.intValue == 2){
        
        NSString *bikeQuerySql = [NSString stringWithFormat:@"SELECT * FROM bike_modals WHERE bikeid LIKE '%zd'", bikeid.intValue];
        NSMutableArray *bikemodals = [LVFmdbTool queryBikeData:bikeQuerySql];
        BikeModel *bikemodel = bikemodals.firstObject;
        
        CustomBike *custombike = [[CustomBike alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - navHeight)];
        custombike.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
        custombike.bikeid = bikeid.intValue;
        
        [self.droppy dropSubview:custombike atIndex:[self.droppy randomIndex]];
        [self.customViewAry addObject:custombike];
        
        self.pageControl.numberOfPages = self.customViewAry.count;
        if (self.customViewAry.count <=1) {
            self.pageControl.hidden = YES;
        }else{
            self.pageControl.hidden = NO;
        }
        
        @weakify(self);
        custombike.vehicleConfigurationView.bikeTestClickBlock = ^{
            @strongify(self);
            if (![[AppDelegate currentAppDelegate].device isConnected]) {
                
                [SVProgressHUD showSimpleText:@"蓝牙未连接"];
                return;
            }
            FaultViewController *faultVc = [FaultViewController new];
            faultVc.motorfaultNum = self.faultmodel.motorfault;
            faultVc.rotationfaultNum = self.faultmodel.rotationfault;
            faultVc.controllerfaultNum = self.faultmodel.controllerfault;
            faultVc.brakefaultNum = self.faultmodel.brakefault;
            faultVc.lackvoltageNum = self.faultmodel.lackvoltage;
            faultVc.motordefectNum = self.faultmodel.motordefectNum;
            [self.navigationController pushViewController:faultVc animated:YES];
        };
        
        custombike.vehicleConfigurationView.bikeSetUpClickBlock = ^{
            @strongify(self);
            SubmitViewController *submitVc = [SubmitViewController new];
            submitVc.delegate = self;
            submitVc.deviceNum = self.bikeid;
            [self.navigationController pushViewController:submitVc animated:YES];
        };
        
        custombike.vehicleConfigurationView.bikePartsManagClickBlock = ^{
            @strongify(self);
            if (![[AppDelegate currentAppDelegate].device isConnected]) {
                [SVProgressHUD showSimpleText:@"蓝牙未连接"];
                return;
            }
            
            AccessoriesViewController *accessVc = [AccessoriesViewController new];
            accessVc.deviceNum = self.bikeid;
            [self.navigationController pushViewController:accessVc animated:YES];
        };
        
        custombike.vehicleStateView.bikeLockBlock = ^(NSInteger tag){
            @strongify(self);
            [self controlerClick:tag];
        };
        
        custombike.vehicleStateView.bikeSwitchBlock = ^(NSInteger tag){
            @strongify(self);
            [self controlerClick:tag];
        };
        
        custombike.vehicleStateView.bikeSeatBlock = ^(NSInteger tag){
            @strongify(self);
            [self controlerClick:tag];
        };
        
        custombike.vehicleStateView.bikeMuteBlock = ^(NSInteger tag){
            @strongify(self);
            [self controlerClick:tag];
        };
        
        if (self.customViewAry.count <=1) {
            self.pageControl.hidden = YES;
        }else{
            self.pageControl.hidden = NO;
        }
        
        NSString *keyversion =bikemodel.keyversion;
        if (keyversion.intValue == 2 || keyversion.intValue == 6 || keyversion.intValue == 9) {
            chamberpot = YES;
            [custombike.vehicleStateView setupFootView:keyversion.intValue];
        }else{
            chamberpot = NO;
        }
        [self setupPagecontrolNumber];
        
    }else if (type.intValue == 4){
    
        if (bikeid.intValue == self.bikeid) {
            
            NSString *bikeQuerySql = [NSString stringWithFormat:@"SELECT * FROM bike_modals WHERE bikeid LIKE '%zd'", self.bikeid];
            NSMutableArray *bikemodals = [LVFmdbTool queryBikeData:bikeQuerySql];
            BikeModel *bikemodel = bikemodals.firstObject;
            [self.navView.centerButton setTitle:bikemodel.bikename forState:UIControlStateNormal];
        }
    }
}

#pragma mark -  手机感应距离调整通知
-(void)updatevalue:(NSNotification *)data{
    
    NSString *value = data.userInfo[@"value"];
    Inductionvalue = -value.integerValue;
    
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM induction_modals WHERE bikeid LIKE '%zd'", self.bikeid];
    NSMutableArray *inducmodals = [LVFmdbTool queryInductionData:nil];
    
    if (inducmodals.count != 0) {
        [LVFmdbTool deleteInductionData:deleteSql];
    }
    
    int induction = 0;
    if (phoneInduction) {

        induction = 0;

    }else {

        induction = 1;
    }
    
    InductionModel *inducmodel = [InductionModel modalWith:self.bikeid inductionValue:Inductionvalue induction:induction];
    [LVFmdbTool insertInductionModel:inducmodel];
}


#pragma mark -  获取报警器固件版本号的逻辑处理
-(void)editionData:(NSNotification *)data{
    
    NSString *passwordHEX = [NSString stringWithFormat:@"A5000007200300"];
    [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
    
    if ([AppDelegate currentAppDelegate].device.upgrate || [AppDelegate currentAppDelegate].device.binding ) {
        
        return;
    }
    
    NSString *editiontitle = data.userInfo[@"edition"];
    
    if ([editiontitle isEqualToString:editionname] && self.bikeid == 0) {
        NSLog(@"退出更新");
        return;
    }
    
    editionname = data.userInfo[@"edition"];
    NSString *token = [QFTools getdata:@"token"];
    NSNumber *bikeid = [NSNumber numberWithInteger:self.bikeid];
    NSString *URLString = [NSString stringWithFormat:@"%@%@",QGJURL,@"app/checkfirmupdate"];
    NSDictionary *parameters = @{@"token":token, @"bike_id": bikeid};
    
    [[HttpRequest sharedInstance] postWithURLString:URLString parameters:parameters success:^(id _Nullable dict) {
        
        if ([dict[@"status"] intValue] == 0) {
            
            NSDictionary *data = dict[@"data"];
            NSString *latest_version = data[@"latest_version"];
            NSNumber *upgrade = data[@"upgrade_flag"];
            downloadhttp = data[@"download"];
            self.latest_version = latest_version;
            if (latest_version.length == 0) {
                return ;
            }
            
            if ([[latest_version substringWithRange:NSMakeRange(0, latest_version.length - 6)] isEqualToString:[editiontitle substringWithRange:NSMakeRange(0, editiontitle.length - 6)]]) {
                
                NSString *NetworktVersion = [latest_version substringFromIndex:latest_version.length- 5];
                NSString *CurrentVersion = [editiontitle substringFromIndex:editiontitle.length- 5];
                CurrentVersion = [CurrentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                if (CurrentVersion.length==2) {
                    CurrentVersion  = [CurrentVersion stringByAppendingString:@"0"];
                }else if (CurrentVersion.length==1){
                    CurrentVersion  = [CurrentVersion stringByAppendingString:@"00"];
                }
                NetworktVersion = [NetworktVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                if (NetworktVersion.length==2) {
                    NetworktVersion  = [NetworktVersion stringByAppendingString:@"0"];
                }else if (NetworktVersion.length==1){
                    NetworktVersion  = [NetworktVersion stringByAppendingString:@"00"];
                }
                
                //当前版本号大于网络版本
                if([CurrentVersion intValue] >= [NetworktVersion intValue])
                {
                    if ([[QFTools currentViewController] isKindOfClass:[SubmitViewController class]]) {
                        [SVProgressHUD showSimpleText:@"已是最新固件"];
                    }
                    return;
                }
                
                if (![latest_version isEqualToString:editiontitle]){
                    
                    if (upgrade.intValue == 0) {
                        
                        self.BluetoothUpgrateAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到固件新版本(约60kb),立即更新吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
                        self.BluetoothUpgrateAlertView.tag = 54;
                        [self.BluetoothUpgrateAlertView show];
                        
                    }else if (upgrade.intValue == 1){
                        
                        self.BluetoothUpgrateAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到固件新版本(约60kb),立即更新吗" delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即更新", nil];
                        self.BluetoothUpgrateAlertView.tag = 55;
                        [self.BluetoothUpgrateAlertView show];
                    }
                }
            }
        }else if([dict[@"status"] intValue] == 1001){
            
            [SVProgressHUD showSimpleText:dict[@"status_info"]];
        }else{
            
            [SVProgressHUD showSimpleText:dict[@"status_info"]];
        }
        
    }failure:^(NSError *error) {
        NSLog(@"error :%@",error);
        
    }];
}

#pragma mark -  主页面alertview的回调
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (![[AppDelegate currentAppDelegate].device isConnected]) {
        
        [SVProgressHUD showSimpleText:@"蓝牙未连接"];
        return;
    }
    
    if (alertView.tag == 54) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            self.backView.hidden = NO;
            [custompro startAnimation];
            custompro.presentlab.text = @"车辆正在连接中...";
            
            DfuDownloadFile *downloadfile = [[DfuDownloadFile alloc] init];
            downloadfile.delegate = self;
            [downloadfile startDownload:downloadhttp];
            
            [AppDelegate currentAppDelegate].device.upgrate = YES;
            NSString *passwordHEX = @"A50000061004";
            [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
            
        }
    }else if (alertView.tag == 55){
    
        if (buttonIndex != [alertView cancelButtonIndex]) {
            self.backView.hidden = NO;
            [custompro startAnimation];
            custompro.presentlab.text = @"车辆正在连接中...";
            DfuDownloadFile *downloadfile = [[DfuDownloadFile alloc] init];
            downloadfile.delegate = self;
            [downloadfile startDownload:downloadhttp];
            
            [AppDelegate currentAppDelegate].device.upgrate = YES;
            NSString *passwordHEX = @"A50000061004";
            [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
        }
    }
}

#pragma mark -  手机感应开关的通知
-(void)queryInduction:(NSNotification *)data{
    
    NSString *result = data.userInfo[@"data"];
    int induction = 0;
    if ([result isEqualToString:@"on"]) {
        induction = 1;
        phoneInduction = YES;
    }else if ([result isEqualToString:@"off"]){
        induction = 0;
        phoneInduction = NO;
    }
    
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM induction_modals WHERE bikeid LIKE '%zd'", self.bikeid];
    
    NSMutableArray *inducmodals = [LVFmdbTool queryInductionData:nil];
    if (inducmodals.count != 0) {
        [LVFmdbTool deleteInductionData:deleteSql];
    }
    
    InductionModel *inducmodel = [InductionModel modalWith:self.bikeid inductionValue:Inductionvalue induction:induction];
    [LVFmdbTool insertInductionModel:inducmodel];
}

#pragma mark -  LrdOutputViewcell
- (void)setupmenu{
    
    LrdCellModel *one = [[LrdCellModel alloc] initWithTitle:@"添加车辆" imageName:@"menu_addbike"];
    LrdCellModel *two = [[LrdCellModel alloc] initWithTitle:@"分享车辆" imageName:@"menu_bindingUser"];
    LrdCellModel *three = [[LrdCellModel alloc] initWithTitle:@"扫一扫" imageName:@"menu_scan"];
    self.chooseArray = @[one,two,three];
}

#pragma mark -  LrdOutputViewDelegate的回调
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath {
    
        if (indexPath.row == 0) {
            
            AddBikeViewController *addVc = [AddBikeViewController new];
            addVc.delegate = self;
            editionname = nil;
            [self.navigationController pushViewController:addVc animated:YES];
            
        }else if (indexPath.row == 1){
            
            BindingUserViewController *bindingUserVc = [BindingUserViewController new];
            bindingUserVc.bikeid = self.bikeid;
            [self.navigationController pushViewController:bindingUserVc animated:YES];
            
        }else{
    
            if (![[AppDelegate currentAppDelegate].device isConnected]) {

                [SVProgressHUD showSimpleText:@"蓝牙未连接"];
                return;

            }
            
            NSString *bikeQuerySql = [NSString stringWithFormat:@"SELECT * FROM bike_modals WHERE bikeid LIKE '%zd'", self.bikeid];
            NSMutableArray *bikemodals = [LVFmdbTool queryBikeData:bikeQuerySql];
            BikeModel *bikemodel = bikemodals.firstObject;
            if (bikemodel.ownerflag == 0) {
                
                [SVProgressHUD showSimpleText:@"子用户无此权限"];
                return;
            }
            
            NSString *QuerykeySql = [NSString stringWithFormat:@"SELECT * FROM periphera_modals WHERE type LIKE '%zd' OR type LIKE '%zd' AND bikeid LIKE '%zd'", 2,5,self.bikeid];
            NSMutableArray *keymodals = [LVFmdbTool queryPeripheraData:QuerykeySql];
            
            if (keymodals.count >=2) {
                [SVProgressHUD showSimpleText:@"智能设备最多配两个"];
                return;
            }
            
//            TwoDimensionalCodecanViewController *scanVc = [TwoDimensionalCodecanViewController new];
//            scanVc.deviceNum = self.bikeid;
            [self.navigationController pushViewController:[BindingGPSViewController new] animated:YES];
        }
}
#pragma mark -  addBikeDelegate
-(void)bidingBikeSuccess:(NSDictionary *)bikeDic{
    
    if ([bikeDic[@"bikeid"] intValue] == self.bikeid) {
        return;
    }
    phoneInduction = NO;
    CustomBike *custombike = [[CustomBike alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - navHeight)];
    [self.navView.centerButton setTitle:bikeDic[@"bikename"] forState:UIControlStateNormal];
    NSURL *url2=[NSURL URLWithString:bikeDic[@"logo"]];
    [custombike.bikeHeadView.bikeLogo sd_setImageWithURL:url2];
    custombike.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    custombike.bikeid = [bikeDic[@"bikeid"] intValue];
    self.bikeid = [bikeDic[@"bikeid"] intValue];
    [self.droppy dropSubview:custombike atIndex:[self.droppy randomIndex]];
    [self.customViewAry addObject:custombike];
    self.pageControl.numberOfPages = self.customViewAry.count;
    if (self.customViewAry.count <=1) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
    }
    
    @weakify(self);
    custombike.vehicleConfigurationView.bikeTestClickBlock = ^{
        @strongify(self);
        if (![[AppDelegate currentAppDelegate].device isConnected]) {
            
            [SVProgressHUD showSimpleText:@"蓝牙未连接"];
            return;
        }
        FaultViewController *faultVc = [FaultViewController new];
        faultVc.motorfaultNum = self.faultmodel.motorfault;
        faultVc.rotationfaultNum = self.faultmodel.rotationfault;
        faultVc.controllerfaultNum = self.faultmodel.controllerfault;
        faultVc.brakefaultNum = self.faultmodel.brakefault;
        faultVc.lackvoltageNum = self.faultmodel.lackvoltage;
        faultVc.motordefectNum = self.faultmodel.motordefectNum;
        [self.navigationController pushViewController:faultVc animated:YES];
    };
    
    custombike.vehicleConfigurationView.bikeSetUpClickBlock = ^{
        @strongify(self);
        SubmitViewController *submitVc = [SubmitViewController new];
        submitVc.delegate = self;
        submitVc.deviceNum = self.bikeid;
        [self.navigationController pushViewController:submitVc animated:YES];
    };
    
    custombike.vehicleConfigurationView.bikePartsManagClickBlock = ^{
        @strongify(self);
        if (![[AppDelegate currentAppDelegate].device isConnected]) {
            [SVProgressHUD showSimpleText:@"蓝牙未连接"];
            return;
        }
        
        AccessoriesViewController *accessVc = [AccessoriesViewController new];
        accessVc.deviceNum = self.bikeid;
        [self.navigationController pushViewController:accessVc animated:YES];
    };
    
    custombike.vehicleStateView.bikeLockBlock = ^(NSInteger tag){
        @strongify(self);
        [self controlerClick:tag];
    };
    
    custombike.vehicleStateView.bikeSwitchBlock = ^(NSInteger tag){
        @strongify(self);
        [self controlerClick:tag];
    };
    
    custombike.vehicleStateView.bikeSeatBlock = ^(NSInteger tag){
        @strongify(self);
        [self controlerClick:tag];
    };
    
    custombike.vehicleStateView.bikeMuteBlock = ^(NSInteger tag){
        @strongify(self);
        [self controlerClick:tag];
    };
    
    if (self.customViewAry.count <=1) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
    }
    
    NSString *keyversion =bikeDic[@"keyversion"];
    if (keyversion.intValue == 2 || keyversion.intValue == 6 || keyversion.intValue == 9) {
        chamberpot = YES;
        [custombike.vehicleStateView setupFootView:keyversion.intValue];
    }else{
        chamberpot = NO;
    }
    [self setupPagecontrolNumber];
}



#pragma mark -  改变label中部分字体的颜色和字体大小
-(void)setTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    label.attributedText = str;
}



#pragma mark - 每0.6秒发送的查询码
-(void)queryFired:(MSWeakTimer *)timer{
    
    if (![[AppDelegate currentAppDelegate].device isConnected]) {
        //NSLog(@"time was invalite");
        return;
    }
    
    if (![AppDelegate currentAppDelegate].device.binding && ![AppDelegate currentAppDelegate].device.upgrate && ![AppDelegate currentAppDelegate].device.bindingaccessories) {
        
        NSString *passwordHEX = @"A50000061001";
        [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
    }
}

#pragma mark - 进入首页后的延时，连接报警器的延时机制，给蓝牙中控启动的时间（只执行一次）
-(void)datatimeFired{
    
    NSString*deviceuuid=[USER_DEFAULTS stringForKey:Key_DeviceUUID];
    if (deviceuuid) {
        [self connectDevice];
        return;
    }
    
    NSString *fuzzyQuerySql = [NSString stringWithFormat:@"SELECT * FROM bike_modals WHERE id LIKE '%zd'", 1];
    NSMutableArray *modals = [LVFmdbTool queryBikeData:fuzzyQuerySql];
    
    if (modals.count == 0) {
        return;
    }
    
        BikeModel *model = modals.firstObject;
    [self.navView.centerButton setTitle:model.bikename forState:UIControlStateNormal];
        self.mac = model.mac;
        
        [USER_DEFAULTS setObject: model.mac forKey:Key_MacSTRING];
        [USER_DEFAULTS synchronize];
        self.ownerflag = model.ownerflag;
        if (model.ownerflag == 1) {
        
            self.password = model.mainpass;
            NSString* masterpwd = [QFTools toHexString:(long)[self.password longLongValue]];
            
            if(masterpwd.length !=8){
                
                int masterpwdCount = 8 - (int)masterpwd.length;
                for (int i = 0; i<masterpwdCount; i++) {
                    masterpwd = [@"0" stringByAppendingFormat:@"%@",masterpwd];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:masterpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:masterpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                });
            }
            
        }else if (model.ownerflag == 0){
            
            self.password = model.password;
            NSString* childpwd = [QFTools toHexString:(long)[self.password longLongValue]];
            if(childpwd.length !=8){
                
                int childpwdCount = 8 - (int)childpwd.length;
                for (int i = 0; i<childpwdCount; i++) {
                    
                    childpwd = [@"0" stringByAppendingFormat:@"%@",childpwd];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:childpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:childpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                    
                });
            }
        }
        
        NSString *infoModalSql = [NSString stringWithFormat:@"SELECT * FROM info_modals WHERE bikeid LIKE '%zd'", model.bikeid];
        NSMutableArray *infomodals = [LVFmdbTool queryModelData:infoModalSql];
        ModelInfo *modelinfo = infomodals.firstObject;
        self.bikeid = modelinfo.bikeid;
        NSString *brandQuerySql = [NSString stringWithFormat:@"SELECT * FROM brand_modals WHERE bikeid LIKE '%zd'", model.bikeid];
        NSMutableArray *brandmodals = [LVFmdbTool queryBrandData:brandQuerySql];
        BrandModel *brandmodel = brandmodals.firstObject;
        if (brandmodals.count != 0) {
            NSURL *logurl=[NSURL URLWithString:brandmodel.logo];
            //图片缓存的基本代码，就是这么简单
            CustomBike *custombike = [self.customViewAry objectAtIndex:self.index];
            [custombike.bikeHeadView.bikeLogo sd_setImageWithURL:logurl];
        }
    
    NSString *QueryuuidSql = [NSString stringWithFormat:@"SELECT * FROM peripherauuid_modals WHERE mac LIKE '%@'", model.mac];
    NSMutableArray *uuidmodals = [LVFmdbTool queryPeripheraUUIDData:QueryuuidSql];
    PeripheralUUIDModel *peripheraluuidmodel = uuidmodals.firstObject;
    if (uuidmodals.count == 0) {
        
        [[AppDelegate currentAppDelegate].device startScan];
    }else{
        
        uuidstring = peripheraluuidmodel.uuid;
        [self showDeviceList];
    }
    
}

#pragma mark - 有记录的车辆，进行连接车辆
-(void)connectDevice{
    
    NSString*deviceuuid=[USER_DEFAULTS stringForKey:Key_DeviceUUID];
    NSString *uuidQuerySql = [NSString stringWithFormat:@"SELECT * FROM peripherauuid_modals WHERE uuid LIKE '%%%@%%'", deviceuuid];
    NSMutableArray *uuidmodals = [LVFmdbTool queryPeripheraUUIDData:uuidQuerySql];
    PeripheralUUIDModel *peripherauuidmodel = uuidmodals.firstObject;
    NSString *mac = peripherauuidmodel.mac;
    
    NSString *fuzzyQuerySql = [NSString stringWithFormat:@"SELECT * FROM bike_modals WHERE mac LIKE '%%%@%%'", mac];
    NSMutableArray *bikemodals = [LVFmdbTool queryBikeData:fuzzyQuerySql];
    BikeModel *bikemodel = bikemodals.firstObject;
    self.bikeid = bikemodel.bikeid;
    
    for(BikeModel *model in bikemodals){
        [self.navView.centerButton setTitle:model.bikename forState:UIControlStateNormal];
        self.mac = model.mac;
        
        self.ownerflag = model.ownerflag;
        if (model.ownerflag == 1) {
            
            self.password = model.mainpass;
            NSString* masterpwd = [QFTools toHexString:(long)[self.password longLongValue]];
            
            if(masterpwd.length != 8){
                
                int masterpwdCount = 8 - (int)masterpwd.length;
                for (int i = 0; i<masterpwdCount; i++) {
                    masterpwd = [@"0" stringByAppendingFormat:@"%@",masterpwd];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:masterpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:masterpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                });
            }
            
        }else if (model.ownerflag == 0){
            
            self.password = model.password;
            NSString* masterpwd = [QFTools toHexString:(long)[self.password longLongValue]];
            if(masterpwd.length != 8){
                
                int masterpwdCount = 8 - (int)masterpwd.length;
                for (int i = 0; i<masterpwdCount; i++) {
                    masterpwd = [@"0" stringByAppendingFormat:@"%@",masterpwd];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:masterpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:masterpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                });
            }
        }
        
        NSString *fuzzyinduSql = [NSString stringWithFormat:@"SELECT * FROM induction_modals WHERE bikeid LIKE '%zd'", self.bikeid];
        NSMutableArray *modals = [LVFmdbTool queryInductionData:fuzzyinduSql];
        InductionModel *indumodel = modals.firstObject;
        
        if (modals.count == 0) {
            phoneInduction = NO;
        }else if(indumodel.induction == 0){
            phoneInduction = NO;
        }else if (indumodel.induction == 1){
            phoneInduction = YES;
        }
        
        NSString *brandQuerySql = [NSString stringWithFormat:@"SELECT * FROM brand_modals WHERE bikeid LIKE '%zd'", model.bikeid];
        NSMutableArray *brandmodals = [LVFmdbTool queryBrandData:brandQuerySql];
        BrandModel *brandmodel = brandmodals.firstObject;
        
        if (brandmodals.count != 0) {
            NSURL *logurl=[NSURL URLWithString:brandmodel.logo];
            CustomBike *custombike = [self.customViewAry objectAtIndex:self.index];
            [custombike.bikeHeadView.bikeLogo sd_setImageWithURL:logurl];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        
        [USER_DEFAULTS setObject: self.mac forKey:Key_MacSTRING];
        [USER_DEFAULTS synchronize];
    });
}

-(void)setupScroview{
    [self.customViewAry removeAllObjects];
    NSMutableArray *bikeAry =[LVFmdbTool queryBikeData:nil];
    for (int i = 0; i < [LVFmdbTool queryBikeData:nil].count; i++) {
        
        CustomBike *custombike = [[CustomBike alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - navHeight)];
        custombike.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
        custombike.haveGPS = YES;
        
        CLLocationCoordinate2D coor;
        coor.latitude = 31.195343;
        coor.longitude = 121.570039;
        custombike.vehiclePositioningMapView.annotation.coordinate = coor;
        [custombike.vehiclePositioningMapView.mapView addAnnotation:custombike.vehiclePositioningMapView.annotation];
        custombike.vehiclePositioningMapView.mapView.centerCoordinate = coor;
        
        @weakify(self);
        custombike.vehicleConfigurationView.bikeTestClickBlock = ^{
            @strongify(self);
            if (![[AppDelegate currentAppDelegate].device isConnected]) {
                
                [SVProgressHUD showSimpleText:@"蓝牙未连接"];
                return;
            }
            FaultViewController *faultVc = [FaultViewController new];
            faultVc.motorfaultNum = self.faultmodel.motorfault;
            faultVc.rotationfaultNum = self.faultmodel.rotationfault;
            faultVc.controllerfaultNum = self.faultmodel.controllerfault;
            faultVc.brakefaultNum = self.faultmodel.brakefault;
            faultVc.lackvoltageNum = self.faultmodel.lackvoltage;
            faultVc.motordefectNum = self.faultmodel.motordefectNum;
            [self.navigationController pushViewController:faultVc animated:YES];
        };
        
        custombike.vehicleConfigurationView.bikeSetUpClickBlock = ^{
            @strongify(self);
            SubmitViewController *submitVc = [SubmitViewController new];
            submitVc.delegate = self;
            submitVc.deviceNum = self.bikeid;
            [self.navigationController pushViewController:submitVc animated:YES];
        };
        
        custombike.vehicleConfigurationView.bikePartsManagClickBlock = ^{
            @strongify(self);
            if (![[AppDelegate currentAppDelegate].device isConnected]) {
                [SVProgressHUD showSimpleText:@"蓝牙未连接"];
                return;
            }
            
            AccessoriesViewController *accessVc = [AccessoriesViewController new];
            accessVc.deviceNum = self.bikeid;
            [self.navigationController pushViewController:accessVc animated:YES];
        };
        
        custombike.vehicleStateView.bikeLockBlock = ^(NSInteger tag){
            @strongify(self);
            [self controlerClick:tag];
        };
        
        custombike.vehicleStateView.bikeSwitchBlock = ^(NSInteger tag){
            @strongify(self);
            [self controlerClick:tag];
        };
        
        custombike.vehicleStateView.bikeSeatBlock = ^(NSInteger tag){
            @strongify(self);
            [self controlerClick:tag];
        };
        
        custombike.vehicleStateView.bikeMuteBlock = ^(NSInteger tag){
            @strongify(self);
            [self controlerClick:tag];
        };
        
        [self.droppy dropSubview:custombike atIndex:[self.droppy randomIndex]];
        [self.customViewAry addObject:custombike];
        self.pageControl.numberOfPages = self.customViewAry.count;
        if (self.customViewAry.count <=1) {
            self.pageControl.hidden = YES;
        }else{
            self.pageControl.hidden = NO;
        }
        
        BikeModel *bikemodel = bikeAry[i];
        [custombike.vehicleStateView setupFootView:bikemodel.keyversion.intValue];
        custombike.bikeid = bikemodel.bikeid;
    }
    [self setupPagecontrolNumber];
}

-(void)setupPagecontrolNumber{
    
    NSMutableArray *bikeAry =[LVFmdbTool queryBikeData:nil];
    for (int i = 0; i< [LVFmdbTool queryBikeData:nil].count; i++) {
        BikeModel *bikemodel = bikeAry[i];
        if ([bikemodel.mac isEqualToString:[USER_DEFAULTS valueForKey:SETRSSI]]) {
            //通过匹配mac地址确定currentPage
            self.pageControl.currentPage = i;
            self.index = i;
            self.droppy.selectIndex = i;
            if (i > 0) {
                [self.droppy setContentOffset:CGPointMake(ScreenWidth * i, 0) animated:NO];
            }
            
            if (bikemodel.keyversion.intValue == 2 || bikemodel.keyversion.intValue == 6 || bikemodel.keyversion.intValue == 9) {
                chamberpot = YES;
                
            }else{
                chamberpot = NO;
            }
        }
    }
}

#pragma mark - 获取到车辆的UUID后的连接
-(void)showDeviceList
{
    [[AppDelegate currentAppDelegate].device stopScan];
    NSString *fuzzyinduSql = [NSString stringWithFormat:@"SELECT * FROM induction_modals WHERE bikeid LIKE '%zd'", self.bikeid];
    NSMutableArray *modals = [LVFmdbTool queryInductionData:fuzzyinduSql];
    InductionModel *indumodel = modals.firstObject;
    if (modals.count == 0) {
        
        phoneInduction = NO;
    }else if(indumodel.induction == 0){
        
        phoneInduction = NO;
    }else if (indumodel.induction == 1){
        
        phoneInduction = YES;
    }
    
    if (uuidstring) {
        [[AppDelegate currentAppDelegate].device retrievePeripheralWithUUID:uuidstring];//导入外设 根据UUID
        [[AppDelegate currentAppDelegate].device connect];
        [USER_DEFAULTS setObject: uuidstring forKey:Key_DeviceUUID];
        [USER_DEFAULTS synchronize];
        
        NSString *fuzzyQuerySql = [NSString stringWithFormat:@"SELECT * FROM peripherauuid_modals WHERE uuid LIKE '%@'",uuidstring];
        NSMutableArray *modals = [LVFmdbTool queryPeripheraUUIDData:fuzzyQuerySql];
        NSString *phonenum = [QFTools getdata:@"phone_num"];
        
        if (modals.count == 0) {
            PeripheralUUIDModel *peripheramodel = [PeripheralUUIDModel modalWith:phonenum bikeid:self.bikeid mac:self.mac uuid:uuidstring];
            [LVFmdbTool insertPeripheralUUIDModel:peripheramodel];
        }
    }
}

#pragma mark---主页车辆扫描的回调
-(void)didDiscoverPeripheral:(NSInteger)tag :(CBPeripheral *)peripheral scanData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"主页扫描电动车");
    if ([AppDelegate currentAppDelegate].device.upgrate) {
        
        if (peripheral.name.length == 7) {
            
        if([[peripheral.name substringWithRange:NSMakeRange(0, 7)]isEqualToString: @"Qgj-Ota"]){
            
            DeviceModel *model=[[DeviceModel alloc]init];
            model.peripher=peripheral;
            model.rssi = RSSI;
            [rssiList addObject:model];
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectDfuModel) object:nil];
            [self performSelector:@selector(connectDfuModel) withObject:nil afterDelay:2];
        }
        
        }else if (peripheral.name.length == 11){
        
            if([[peripheral.name substringWithRange:NSMakeRange(0, 11)]isEqualToString: @"Qgj-DfuTarg"]){
                
                DeviceModel *model=[[DeviceModel alloc]init];
                model.peripher=peripheral;
                model.rssi = RSSI;
                [rssiList addObject:model];
                
                [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectDfuModel) object:nil];
                [self performSelector:@selector(connectDfuModel) withObject:nil afterDelay:2];
            }
        }else if (peripheral.name.length == 8){
            
            if([[peripheral.name substringWithRange:NSMakeRange(0, 8)]isEqualToString: @"Qgj-DfuT"]){
                
                DeviceModel *model=[[DeviceModel alloc]init];
                model.peripher=peripheral;
                model.rssi = RSSI;
                [rssiList addObject:model];
                
                [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectDfuModel) object:nil];
                [self performSelector:@selector(connectDfuModel) withObject:nil afterDelay:2];
            }
        }
    }else if (![AppDelegate currentAppDelegate].device.upgrate){
    
        if (peripheral.name.length < 13) {
            
            return;
        }
        
    if([[peripheral.name substringWithRange:NSMakeRange(0, 13)]isEqualToString: @"Qgj-SmartBike"]){
        const char *valueString = [[[advertisementData objectForKey:@"kCBAdvDataManufacturerData"] description] cStringUsingEncoding: NSUTF8StringEncoding];
        
        if (valueString == NULL) {
            return;
        }
        
        NSString *title = [[NSString alloc] initWithUTF8String:valueString];
        
        if ([self.mac isEqualToString:[[title substringWithRange:NSMakeRange(5, 4)] stringByAppendingString:[title substringWithRange:NSMakeRange(10, 8)]].uppercaseString]){
            uuidstring = peripheral.identifier.UUIDString;
            [self showDeviceList];
        }
     }
   }
}


#pragma mark - 底部控制按钮，app主页底部的控制按钮逻辑
-(void)controlerClick:(NSInteger )tag{

    if (![[AppDelegate currentAppDelegate].device isConnected]) {
        
        [SVProgressHUD showSimpleText:@"蓝牙未连接"];
        return;
        
    }else if (querydate == nil){
    
        return;
    }
    
    NSString *binary = [QFTools getBinaryByhex:[querydate substringWithRange:NSMakeRange(12, 2)]];
    if (tag == 20) {
        if ([[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"0"]) {
            if (riding) {
                [SVProgressHUD showSimpleText:@"骑行状态不能设防"];
                return;
            }
            if (keyInduction) {
                [SVProgressHUD showSimpleText:@"感应优先，设防无效"];
                return;
            }
            NSString *passwordHEX = @"A5000007200102";
            [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
        }else if ([[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"]){
            NSString *passwordHEX = @"A5000007200101";
            [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
        }
    }else if (tag == 21){
        if ([[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"0"]) {
            
            if ([[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"]){
                [SVProgressHUD showSimpleText:@"请先解锁"];
                return;
            }
            NSString *passwordHEX = @"A5000007200103";
            [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
        }else if ([[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"]){
            NSString *passwordHEX = @"A5000007200104";
            [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
        }
    }else if (tag == 22){
    
        if (self->fortification) {
            [SVProgressHUD showSimpleText:@"请先解锁"];
            return;
        }
        
        if (chamberpot) {
            if(touchCount<1){
                touchCount++;
                NSString *passwordHEX = @"A5000007200107";
                [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];;//不是频繁操作执行对应点击事件
                [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeSetting) object:nil];
                [self performSelector:@selector(timeSetting) withObject:nil afterDelay:1.0];//1秒后点击次数清零
            }else{
                
                [SVProgressHUD showSimpleText:@"点击过于频繁"];
            }
            
        }else if (!chamberpot){
            
            if ([[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"0"]) {
                
                NSString *passwordHEX = @"A5000007200105";
                [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
                
            }else if ([[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"]) {
                
                NSString *passwordHEX = @"A5000007200106";
                [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
            }
        }
    }
    else if (tag == 23){
    
        if ([[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"0"]) {
            
            NSString *passwordHEX = @"A5000007200105";
            
            [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
            
        }else if ([[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"]){
            
            NSString *passwordHEX = @"A5000007200106";
            
            [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
        }
    }
}

#pragma mark - 避免重复开启电子锁，等待几秒后的操作
-(void)timeSetting{
    
    touchCount=0;
}


#pragma mark - 0.6循环秒查询蓝牙数据返回
-(void)BikeViewquerySuccess:(NSNotification *)data{
    
    CustomBike *custombike = [self.customViewAry objectAtIndex:self.index];
    UIButton*btn1= custombike.vehicleStateView.bikeLockBtn;
    UIButton*btn2= custombike.vehicleStateView.bikeSwitchBtn;
    UIButton*btn3= custombike.vehicleStateView.bikeSeatBtn;
    UIButton*btn4= custombike.vehicleStateView.bikeMuteBtn;
    UILabel* lab1= custombike.vehicleStateView.bikeLockLabel;
    NSString *date = data.userInfo[@"data"];
    NSData *datevalue = [ConverUtil parseHexStringToByteArray:date];
    
    Byte *byte=(Byte *)[datevalue bytes];
    
    if ([[date substringWithRange:NSMakeRange(8, 4)] isEqualToString:@"1001"]) {
        
        querydate = date;
        
        NSString *binary = [QFTools getBinaryByhex:[date substringWithRange:NSMakeRange(12, 2)]];
        
        NSString *bikestate = [QFTools getBinaryByhex:[date substringWithRange:NSMakeRange(28, 2)]];
        
        NSString *keystatenumber = [QFTools getBinaryByhex:[date substringWithRange:NSMakeRange(16, 2)]];
        
        [[QFTools getBinaryByhex:[date substringWithRange:NSMakeRange(22, 2)]] intValue];
        
        [[QFTools getBinaryByhex:[date substringWithRange:NSMakeRange(24, 2)]] intValue];
        
        if (byte[14] == 0) {
//            self.bikestatedetail.text = @"健康";
//            self.bikestatedetail.textColor = [UIColor whiteColor];
            
            self.faultmodel.motorfault = 0;
            self.faultmodel.rotationfault = 0;
            self.faultmodel.controllerfault = 0;
            self.faultmodel.brakefault = 0;
            self.faultmodel.lackvoltage = 0;
            self.faultmodel.motordefectNum = 0;
            
        }else{
        
//            self.bikestatedetail.text = @"故障";
//            self.bikestatedetail.textColor = [UIColor redColor];
            
            if([[bikestate substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"]){
                //电机故障
                self.faultmodel.motorfault = 1;
                
            }else if([[bikestate substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"0"]){
            
                self.faultmodel.motorfault = 0;
            }
            
            if([[bikestate substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"]){
                //转把故障
                self.faultmodel.rotationfault = 1;
                
            }else if([[bikestate substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"0"]){
                
                self.faultmodel.rotationfault = 0;
            }
            
            if([[bikestate substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"]){
                //控制器故障
                
                self.faultmodel.controllerfault = 1;
            }else if([[bikestate substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"0"]){
                
                self.faultmodel.controllerfault = 0;
            }
            
            if([[bikestate substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"]){
                //控制器故障
                
                self.faultmodel.motordefectNum = 1;
            }else if([[bikestate substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"0"]){
                
                self.faultmodel.motordefectNum = 0;
            }
            
            if([[bikestate substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"]){
                //刹车故障
                self.faultmodel.brakefault = 1;
                
            }else if([[bikestate substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"0"]){
                
                self.faultmodel.brakefault = 0;
            }
            
            if([[bikestate substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"]){
                //电池欠压故障
                self.faultmodel.lackvoltage = 1;
                
            }else if([[bikestate substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"0"]){
                
                self.faultmodel.lackvoltage = 0;
            }
        }
        
        if ([[keystatenumber substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"]) {
            [(SideMenuViewController *)self.sideViewController.sideVC inductionImg].image = [UIImage imageNamed:@"induckey_connect"];
            keyInduction = YES;
        }else if ([[keystatenumber substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"0"]){
            [(SideMenuViewController *)self.sideViewController.sideVC inductionImg].image = [UIImage imageNamed:@"induckey_break"];
            keyInduction = NO;
        }
        int value = byte[15];
        [(SideMenuViewController *)self.sideViewController.sideVC inductionElectricity].text = [NSString stringWithFormat:@"%d%%",value];
        float wendu = BUILD_UINT16(byte[12],byte[11]) * .1;
        float dianya = BUILD_UINT16(byte[10],byte[9]) * .1;
        custombike.vehicleConfigurationView.bikeVoltageLabel.text =[NSString stringWithFormat:@"%dv",(int)dianya];
        custombike.vehicleConfigurationView.bikeTemperatureLabel.text = [NSString stringWithFormat:@"%d°",(int)wendu];
        
        //[self setTextColor:self.biketemperature FontNumber:[UIFont systemFontOfSize:11] AndRange:NSMakeRange(self.biketemperature.text.length - 2, 2) AndColor:[QFTools colorWithHexString:@"#ffffff"]];
        
        //[self setTextColor:self.voltageLab FontNumber:[UIFont systemFontOfSize:11] AndRange:NSMakeRange(self.voltageLab.text.length - 1, 1) AndColor:[QFTools colorWithHexString:@"#ffffff"]];
        if ([[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"0"]) {
            
            [btn1 setImage:[UIImage imageNamed:@"icon_bike_lock_blue"] forState:UIControlStateNormal];
            fortification = NO;
            //self.Preparedness.text = @"已解锁";
            lab1.text = @"上锁";
            
        }else if ([[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"]){
            
            [btn1 setImage:[UIImage imageNamed:@"icon_bike_unlock_blue"] forState:UIControlStateNormal];
            fortification = YES;
            //self.Preparedness.text = @"已上锁";
            lab1.text = @"解锁";
        }
        
        if (!fortification && powerswitch) {
            
            if (custombike.bikeHeadView.haveGPS) {
                custombike.bikeHeadView.bikeStateImg.image = [UIImage imageNamed:@"riding_gps"];
                
            }else{
                custombike.vehicleControlView.bikeLockImge.image = [UIImage imageNamed:@"riding_no_gps"];
                custombike.vehicleControlView.bikeLockLabel.text = @"骑行中";
            }
            riding = YES;
        }else if (fortification && !powerswitch){
        
            if (custombike.bikeHeadView.haveGPS) {
                custombike.bikeHeadView.bikeStateImg.image = [UIImage imageNamed:@"lock_gps"];
                
            }else{
                custombike.vehicleControlView.bikeLockImge.image = [UIImage imageNamed:@"lock"];
                custombike.vehicleControlView.bikeLockLabel.text = @"已上锁";
            }
        }else if (!fortification && !powerswitch){
        
            if (custombike.bikeHeadView.haveGPS) {
                custombike.bikeHeadView.bikeStateImg.image = [UIImage imageNamed:@"unlock_gps"];
                
            }else{
                custombike.vehicleControlView.bikeLockImge.image = [UIImage imageNamed:@"unlock"];
                custombike.vehicleControlView.bikeLockLabel.text = @"已解锁";
            }
        }
        if ([[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"0"]) {
            
            [btn2 setImage:[UIImage imageNamed:@"open_the_switch"] forState:UIControlStateNormal];
            powerswitch = NO;
            riding = NO;
            
        }else{
            
            [btn2 setImage:[UIImage imageNamed:@"close_the_switch"] forState:UIControlStateNormal];
            powerswitch = YES;
        }
        
        if ([[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"0"]) {
            
            if (chamberpot) {
                
                [btn4 setImage:[UIImage imageNamed:@"bike_nomute_icon"] forState:UIControlStateNormal];
                
            }else{
            
                [btn3 setImage:[UIImage imageNamed:@"bike_nomute_icon"] forState:UIControlStateNormal];
            }
            
        }else{
            
            if (chamberpot) {
                
                [btn4 setImage:[UIImage imageNamed:@"bike_mute_icon"] forState:UIControlStateNormal];
                
            }else{
            
                [btn3 setImage:[UIImage imageNamed:@"bike_mute_icon"] forState:UIControlStateNormal];
            }
        }
        
        int rssi = byte[13] - 255;
        if (phoneInduction) {
            NSString *fuzzyinduSql = [NSString stringWithFormat:@"SELECT * FROM induction_modals WHERE bikeid LIKE '%zd'", self.bikeid];
            NSMutableArray *modals = [LVFmdbTool queryInductionData:fuzzyinduSql];
            InductionModel *indumodel = modals.firstObject;
            NSInteger rssivalue;

            if (modals == 0 || indumodel.inductionValue == 0) {
                rssivalue = -67;
            }else{
                rssivalue = indumodel.inductionValue;
            }

            if (rssi >= rssivalue && fortification) {

                if (riding) {
                    return;
                }

                NSString *passwordHEX = @"A5000007200101";
                [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];

            }else if (rssi < rssivalue - 8 && !fortification){

                if (riding) {
                    return;
                }

                NSString *passwordHEX = @"A5000007200102";
                [[AppDelegate currentAppDelegate].device sendKeyValue:[ConverUtil parseHexStringToByteArray:passwordHEX]];
            }
        }
        
    }else if([[date substringWithRange:NSMakeRange(8, 4)] isEqualToString:@"6002"]){
    
       // self.bikestatedetail.text = @"车辆状态:异常";
    }else if([[date substringWithRange:NSMakeRange(8, 4)] isEqualToString:@"1002"]){
        
        if ([[date substringWithRange:NSMakeRange(12, 2)] isEqualToString:@"00"]) {
            [SVProgressHUD showSimpleText:@"连接失效，请重新绑定"];
            [[AppDelegate currentAppDelegate].device remove];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                
                if (custombike.haveGPS) {
                    custombike.vehicleConfigurationView.bikeTestLabel.text = @"未连接";
                    custombike.vehicleConfigurationView.bikeTestLabel.textColor = [UIColor redColor];
                }else{
                    
                    custombike.vehicleControlView.bikeIsConnectLabel.text = @"未连接";
                    custombike.vehicleControlView.bikeIsConnectLabel.textColor = [UIColor redColor];
                }
            });
            
        }else if ([[date substringWithRange:NSMakeRange(12, 2)] isEqualToString:@"01"]){
        
            [[AppDelegate currentAppDelegate].device readDiviceInformation];
            
            if (custombike.haveGPS) {
                
                custombike.vehicleConfigurationView.bikeTestLabel.text = @"车辆体检";
                custombike.vehicleConfigurationView.bikeTestLabel.textColor = [UIColor blackColor];
            }else{
                
                custombike.vehicleControlView.bikeIsConnectLabel.text = @"已连接";
                custombike.vehicleControlView.bikeIsConnectLabel.textColor = [QFTools colorWithHexString:MainColor];
            }
            custombike.vehicleConfigurationView.bikeTestImge.image = [UIImage imageNamed:@"vehicle_physical_examination"];
        }
    }else if ([[date substringWithRange:NSMakeRange(8, 4)] isEqualToString:@"1004"]) {
        
        if ([[date substringWithRange:NSMakeRange(12, 2)] isEqualToString:@"00"]) {
            
            [SVProgressHUD showSimpleText:@"进入固件升级失败"];
        }else if([[date substringWithRange:NSMakeRange(12, 2)] isEqualToString:@"01"]){
            
            [AppDelegate currentAppDelegate].device.deviceStatus=0;
            [self updateDeviceStatusAction:nil];
            [rssiList removeAllObjects];//清空设备model数组
            [[AppDelegate currentAppDelegate].device remove];
            [self performSelector:@selector(breakconnect) withObject:nil afterDelay:2];
        }
        
        [self performSelector:@selector(connectDefaultModel) withObject:nil afterDelay:30];
    }
    
}

#pragma mark - 进入固件升级先主动断开再连接
- (void)breakconnect{

    [AppDelegate currentAppDelegate]. device.deviceStatus=0;
    //self.bikestateimage.image = [UIImage imageNamed:@"icon_blu_show_off"];
    [[AppDelegate currentAppDelegate].device startScan];
}

-(void)connectDefaultModel{

    if (!self.isTransferring){
        [SVProgressHUD showSimpleText:@"固件升级失败"];
        [[AppDelegate currentAppDelegate].device stopScan];
        [custompro stopAnimation];
        self.backView.hidden = YES;
        [AppDelegate currentAppDelegate].device.centralManager.delegate=[AppDelegate currentAppDelegate].device;
        [AppDelegate currentAppDelegate].device.peripheral.delegate=[AppDelegate currentAppDelegate].device;
        [self performSelector:@selector(connectBle) withObject:nil afterDelay:2];
    }

}

#pragma mark - 进入升级模式后连接车辆
- (void)connectDfuModel{
    
    [[AppDelegate currentAppDelegate].device stopScan];
    [custompro stopAnimation];
    if(rssiList.count>0){
        custompro.presentlab.text = @"车辆正在升级中...";
        //self.backView.hidden = NO;
        NSArray *ascendArray = [rssiList sortedArrayUsingComparator:^NSComparisonResult(DeviceModel* obj1, DeviceModel* obj2){
                                    float f1 = fabsf([obj1.rssi floatValue]);
                                    float f2 = fabsf([obj2.rssi floatValue]);
                                    if (f1 > f2)
                                    {
                                        return (NSComparisonResult)NSOrderedDescending;
                                    }
                                    if (f1 < f2)
                                    {
                                        return (NSComparisonResult)NSOrderedAscending;
                                    }
                                    return (NSComparisonResult)NSOrderedSame;
                                }];
        
        selectedPeripheral = [[ascendArray objectAtIndex:0] peripher];
        [dfuOperations setCentralManager:[AppDelegate currentAppDelegate].device.centralManager];
        [dfuOperations connectDevice:[[ascendArray objectAtIndex:0] peripher]];
        [self performSelector:@selector(connectDfuSuccess) withObject:nil afterDelay:2];
        
    }else{
        [AppDelegate currentAppDelegate].device.upgrate = NO;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:NSLocalizedString( @"请确认设备是否断电", @"") delegate:nil cancelButtonTitle:NSLocalizedString( @"确定", @"") otherButtonTitles:nil, nil];
        [alert show];
        self.backView.hidden = YES;
        [AppDelegate currentAppDelegate].device.centralManager.delegate=[AppDelegate currentAppDelegate].device;
        [AppDelegate currentAppDelegate].device.peripheral.delegate=[AppDelegate currentAppDelegate].device;
        [self performSelector:@selector(connectBle) withObject:nil afterDelay:2];
    }


}

#pragma mark - 主页面车辆点击
- (void)bikeImageClick{
    
    SubmitViewController *submitVc = [SubmitViewController new];
    submitVc.delegate = self;
    submitVc.deviceNum = self.bikeid;
    [self.navigationController pushViewController:submitVc animated:YES];
}

#pragma mark - 修改车名
-(void) addViewControllerdidAddString:(NSString *)nameText deviceTag:(NSInteger)deviceNum
{
    if (self.bikeid == deviceNum) {
        
        [self.navView.centerButton setTitle:nameText forState:UIControlStateNormal];
    }
}

#pragma mark - 固件升级处理
-(void)submitBegainUpgrate{
    
    if (![[AppDelegate currentAppDelegate].device isConnected]) {

        [SVProgressHUD showSimpleText:@"蓝牙未连接"];
        return;
    }
    [[AppDelegate currentAppDelegate].device readDiviceInformation];
}

-(void)submitUnbundDevice:(NSInteger)bikeid{
    
    [self.customViewAry removeObjectAtIndex:self.index];
    [self.droppy removeSubviewAtIndex:self.index];
    self.pageControl.numberOfPages = self.customViewAry.count;
    self.pageControl.currentPage = self.customViewAry.count-1;
    if (self.customViewAry.count <=1) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
        self.pageControl.currentPage = 0;
    }
    self.index = 0;
    self.droppy.selectIndex = 0;
    
    NSMutableArray *bikeAry = [LVFmdbTool queryBikeData:nil];
    BikeModel *bikemodel = bikeAry.firstObject;
    [self switchingVehicle:bikemodel.bikeid];//默认连接第一辆车
}

#pragma mark - 切换车辆处理
- (void)switchingVehicle:(NSInteger)bikeid{
    
    CustomBike *custombike = [self.customViewAry objectAtIndex:self.index];
    [[AppDelegate currentAppDelegate].device stopScan];
    NSString *QueryBikeSql = [NSString stringWithFormat:@"SELECT * FROM bike_modals WHERE bikeid LIKE '%zd'", bikeid];
    NSMutableArray *bikemodals = [LVFmdbTool queryBikeData:QueryBikeSql];
    BikeModel *model = bikemodals.firstObject;
    [self.navView.centerButton setTitle:model.bikename forState:UIControlStateNormal];
    self.mac = model.mac;
    [USER_DEFAULTS setValue:model.mac forKey:SETRSSI];
    [USER_DEFAULTS setObject: model.mac forKey:Key_MacSTRING];
    [USER_DEFAULTS synchronize];
        if (self.bikeid == model.bikeid && [[AppDelegate currentAppDelegate].device isConnected]) {
            
            [SVProgressHUD showSimpleText:@"设备已连接"];
            
            return;
        }else{
        
            [[AppDelegate currentAppDelegate].device remove];
            [custombike viewReset];
        }
        uuidstring = nil;
        editionname = nil;
        self.ownerflag = model.ownerflag;
        if (model.ownerflag == 1) {
            
            self.password = model.mainpass;
            NSString* masterpwd = [QFTools toHexString:(long)[self.password longLongValue]];
            
            if(masterpwd.length !=8){
                int masterpwdCount = 8 - (int)masterpwd.length;
                for (int i = 0; i<masterpwdCount; i++) {
                    masterpwd = [@"0" stringByAppendingFormat:@"%@",masterpwd];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:masterpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:masterpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                });
            }
            
        }else if (model.ownerflag == 0){
            
            self.password = model.password;
            NSString* masterpwd = [QFTools toHexString:(long)[self.password longLongValue]];
            
            if(masterpwd.length !=8){
                
                int masterpwdCount = 8 - (int)masterpwd.length;
                for (int i = 0; i<masterpwdCount; i++) {
                    masterpwd = [@"0" stringByAppendingFormat:@"%@",masterpwd];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:masterpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:masterpwd,@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                });
            }
        }
    
        NSString *fuzzyQuerySql = [NSString stringWithFormat:@"SELECT * FROM info_modals WHERE bikeid LIKE '%zd'", model.bikeid];
        NSMutableArray *modals = [LVFmdbTool queryModelData:fuzzyQuerySql];
        ModelInfo *modelinfo = modals.firstObject;
        self.bikeid = modelinfo.bikeid;
        NSString *brandQuerySql = [NSString stringWithFormat:@"SELECT * FROM brand_modals WHERE bikeid LIKE '%zd'", model.bikeid];
        NSMutableArray *brandmodals = [LVFmdbTool queryBrandData:brandQuerySql];
        BrandModel *brandmodel = brandmodals.firstObject;
        
        if (brandmodals.count != 0) {
            NSURL *logurl=[NSURL URLWithString:brandmodel.logo];
            //图片缓存的基本代码，就是这么简单
            
            [custombike.bikeHeadView.bikeLogo sd_setImageWithURL:logurl];
        }
    NSString *QueryuuidSql = [NSString stringWithFormat:@"SELECT * FROM peripherauuid_modals WHERE mac LIKE '%@'", model.mac];
    NSMutableArray *uuidmodals = [LVFmdbTool queryPeripheraUUIDData:QueryuuidSql];
    PeripheralUUIDModel *peripheraluuidmodel = uuidmodals.firstObject;
    if (uuidmodals.count == 0) {
        
        [[AppDelegate currentAppDelegate].device startScan];
    }else{
    
        uuidstring = peripheraluuidmodel.uuid;
        [self showDeviceList];
    }
    
}


//******************????升级文件下载代码??*******************//


#pragma mark - DfuDownloadFileDelegate
-(void)DownloadOver{


}

-(void)DownloadBreak{

    [SVProgressHUD showSimpleText:@"下载中断"];
}

//*******************???固件升级????*******************//

- (void)connectDfuSuccess{
    [rssiList removeAllObjects];
    
    self.isConnected = YES;
    self.dfuHelper.isDfuVersionExist = YES;
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/test.zip", pathDocuments];
    
    NSURL *URL = [NSURL URLWithString:filePath];
    
    [self onFileTypeNotSelected];
    
    // Save the URL in DFU helper
    self.dfuHelper.selectedFileURL = URL;
    
    //if (self.dfuHelper.selectedFileURL) {
    NSMutableArray *availableTypes = [[NSMutableArray alloc] initWithCapacity:4];
    
    // Read file name and size
    NSString *selectedFileName = [[URL path] lastPathComponent];
    NSData *fileData = [NSData dataWithContentsOfURL:URL];
    self.dfuHelper.selectedFileSize = fileData.length;
    
    // Get last three characters for file extension
    NSString *extension = [[selectedFileName substringFromIndex: [selectedFileName length] - 3] lowercaseString];
    if ([extension isEqualToString:@"zip"])
    {
        self.dfuHelper.isSelectedFileZipped = YES;
        self.dfuHelper.isManifestExist = NO;
        // Unzip the file. It will parse the Manifest file, if such exist, and assign firmware URLs
        [self.dfuHelper unzipFiles:URL];
        
        // Manifest file has been parsed, we can now determine the file type based on its content
        // If a type is clear (only one bin/hex file) - just select it. Otherwise give user a change to select
        NSString* type = nil;
        if (((self.dfuHelper.softdevice_bootloaderURL && !self.dfuHelper.softdeviceURL && !self.dfuHelper.bootloaderURL) ||
             (self.dfuHelper.softdeviceURL && self.dfuHelper.bootloaderURL && !self.dfuHelper.softdevice_bootloaderURL)) &&
            !self.dfuHelper.applicationURL)
        {
            type = FIRMWARE_TYPE_BOTH_SOFTDEVICE_BOOTLOADER;
        }
        else if (self.dfuHelper.softdeviceURL && !self.dfuHelper.bootloaderURL && !self.dfuHelper.applicationURL && !self.dfuHelper.softdevice_bootloaderURL)
        {
            type = FIRMWARE_TYPE_SOFTDEVICE;
        }
        else if (self.dfuHelper.bootloaderURL && !self.dfuHelper.softdeviceURL && !self.dfuHelper.applicationURL && !self.dfuHelper.softdevice_bootloaderURL)
        {
            type = FIRMWARE_TYPE_BOOTLOADER;
        }
        else if (self.dfuHelper.applicationURL && !self.dfuHelper.softdeviceURL && !self.dfuHelper.bootloaderURL && !self.dfuHelper.softdevice_bootloaderURL)
        {
            type = FIRMWARE_TYPE_APPLICATION;
        }
        
        // The type has been established?
        if (type)
        {
            // This will set the selectedFileType property
            [self onFileTypeSelected:type];
        }
        else
        {
            if (self.dfuHelper.softdeviceURL)
            {
                [availableTypes addObject:FIRMWARE_TYPE_SOFTDEVICE];
            }
            if (self.dfuHelper.bootloaderURL)
            {
                [availableTypes addObject:FIRMWARE_TYPE_BOOTLOADER];
            }
            if (self.dfuHelper.applicationURL)
            {
                [availableTypes addObject:FIRMWARE_TYPE_APPLICATION];
            }
            if (self.dfuHelper.softdevice_bootloaderURL)
            {
                [availableTypes addObject:FIRMWARE_TYPE_BOTH_SOFTDEVICE_BOOTLOADER];
            }
        }
    }
    else
    {
        // If a HEX/BIN file has been selected user needs to choose the type manually
        self.dfuHelper.isSelectedFileZipped = NO;
        [availableTypes addObjectsFromArray:@[FIRMWARE_TYPE_SOFTDEVICE, FIRMWARE_TYPE_BOOTLOADER, FIRMWARE_TYPE_APPLICATION, FIRMWARE_TYPE_BOTH_SOFTDEVICE_BOOTLOADER]];
    }
    
    [self performDFU];
}

-(void)performDFU
{
    
    [self.dfuHelper checkAndPerformDFU];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // The 'scan' or 'select' seque will be performed only if DFU process has not been started or was completed.
    //return !self.isTransferring;
    return YES;
}


- (void) clearUI
{
    selectedPeripheral = nil;
}

-(void)enableUploadButton
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (selectedFileType && self.dfuHelper.selectedFileSize > 0)
        {
            if ([self.dfuHelper isValidFileSelected])
            {
                NSLog(@"Valid file selected");
            }
            else
            {
                NSLog(@"Valid file not available in zip file");
                [Utility showAlert:[self.dfuHelper getFileValidationMessage]];
                return;
            }
        }
        
        if (self.dfuHelper.isDfuVersionExist)
        {
            if (selectedPeripheral && selectedFileType && self.dfuHelper.selectedFileSize > 0 && self.isConnected && self.dfuHelper.dfuVersion > 1)
            {
                if ([self.dfuHelper isInitPacketFileExist])
                {
                    // uploadButton.enabled = YES;
                }
                else
                {
                    [Utility showAlert:[self.dfuHelper getInitPacketFileValidationMessage]];
                }
            }
            else
            {
                if (selectedPeripheral && self.isConnected && self.dfuHelper.dfuVersion < 1)
                {
                    // uploadStatus.text = [NSString stringWithFormat:@"Unsupported DFU version: %d", self.dfuHelper.dfuVersion];
                }
                NSLog(@"Can't enable Upload button");
            }
        }
        else
        {
            if (selectedPeripheral && selectedFileType && self.dfuHelper.selectedFileSize > 0 && self.isConnected)
            {
                // uploadButton.enabled = YES;
            }
            else
            {
                NSLog(@"Can't enable Upload button");
            }
        }
        
    });
}


-(void)appDidEnterBackground:(NSNotification *)_notification
{
    if (self.isConnected && self.isTransferring)
    {
        [Utility showBackgroundNotification:[self.dfuHelper getUploadStatusMessage]];
    }
}

-(void)appDidEnterForeground:(NSNotification *)_notification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}



#pragma mark File Selection Delegate
-(void)onFileTypeSelected:(NSString *)type
{
    selectedFileType = type;
    //fileType.text = selectedFileType;
    if (type)
    {
        [self.dfuHelper setFirmwareType:selectedFileType];
        [self enableUploadButton];
    }
}

-(void)onFileTypeNotSelected
{
    self.dfuHelper.selectedFileURL = nil;
    //    fileName.text = nil;
    //    fileSize.text = nil;
    [self onFileTypeSelected:nil];
}

#pragma mark DFUOperations delegate methods
-(void)onDeviceConnected:(CBPeripheral *)peripheral
{
    self.isConnected = YES;
    self.dfuHelper.isDfuVersionExist = NO;
    [self enableUploadButton];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // uploadStatus.text = @"Device ready";
    });
    
    //Following if condition display user permission alert for background notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    [NSNOTIC_CENTER addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [NSNOTIC_CENTER addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)onDeviceConnectedWithVersion:(CBPeripheral *)peripheral
{
    self.isConnected = YES;
    self.dfuHelper.isDfuVersionExist = YES;
    [self enableUploadButton];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // uploadStatus.text = @"Reading DFU version...";
    });
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    [NSNOTIC_CENTER addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [NSNOTIC_CENTER addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - 固件升级中蓝牙断开回调
-(void)onDeviceDisconnected:(CBPeripheral *)peripheral
{   [BikeViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectDefaultModel) object:nil];
    self.isTransferring = NO;
    self.isConnected = NO;
    [self connectDfuModel];
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dfuHelper.dfuVersion != 1)
        {
            self.isTransferCancelled = NO;
            self.isTransfered = NO;
            self.isErrorKnown = NO;
        }
        else
        {
            double delayInSeconds = 3.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [dfuOperations connectDevice:peripheral];
            });
        }
    });
}

-(void)onReadDFUVersion:(int)version
{
    self.dfuHelper.dfuVersion = version;
    NSLog(@"DFU Version: %d",self.dfuHelper.dfuVersion);
    if (self.dfuHelper.dfuVersion == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        [dfuOperations setAppToBootloaderMode];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        [self enableUploadButton];
    }
}

-(void)onDFUStarted
{
    NSLog(@"DFU Started");
    self.isTransferring = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *uploadStatusMessage = [self.dfuHelper getUploadStatusMessage];
        if ([Utility isApplicationStateInactiveORBackground])
        {
            [Utility showBackgroundNotification:uploadStatusMessage];
        }
        else
        {
            
        }
    });
}

#pragma mark - 固件升级取消回调
-(void)onDFUCancelled
{
    NSLog(@"DFU Cancelled");
    self.isTransferring = NO;
    self.isTransferCancelled = YES;
    
    [SVProgressHUD showSimpleText:@"固件升级失败"];
    [[AppDelegate currentAppDelegate].device stopScan];
    [custompro stopAnimation];
    self.backView.hidden = YES;
    [AppDelegate currentAppDelegate].device.centralManager.delegate=[AppDelegate currentAppDelegate].device;
    [AppDelegate currentAppDelegate].device.peripheral.delegate=[AppDelegate currentAppDelegate].device;
    [self performSelector:@selector(connectBle) withObject:nil afterDelay:2];
}

-(void)onSoftDeviceUploadStarted
{
    NSLog(@"SoftDevice Upload Started");
}

-(void)onSoftDeviceUploadCompleted
{
    NSLog(@"SoftDevice Upload Completed");
}

-(void)onBootloaderUploadStarted
{
    NSLog(@"Bootloader Upload Started");
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([Utility isApplicationStateInactiveORBackground])
        {
            [Utility showBackgroundNotification:@"Uploading bootloader..."];
        }
        else
        {
            
        }
    });
}

#pragma mark - Bootloader Upload Completed
-(void)onBootloaderUploadCompleted
{
    NSLog(@"Bootloader Upload Completed");
}

#pragma mark - 固件升级中当前的进度值
-(void)onTransferPercentage:(int)percentage
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [custompro setPresent:(int)percentage];
        
    });
}

#pragma mark - 成功进入固件升级的回调
-(void)onSuccessfulFileTranferred
{
    NSLog(@"File Transferred");
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isTransferring = NO;
        self.isTransfered = YES;
        NSString* message = [NSString stringWithFormat:@"%lu bytes transfered in %lu seconds", (unsigned long)dfuOperations.binFileSize, (unsigned long)dfuOperations.uploadTimeInSeconds];
        
        if ([Utility isApplicationStateInactiveORBackground])
        {
            [Utility showBackgroundNotification:message];
        }
        else
        {
            //[Utility showAlert:message];
            
            [AppDelegate currentAppDelegate].device.centralManager.delegate=[AppDelegate currentAppDelegate].device;
            [AppDelegate currentAppDelegate].device.peripheral.delegate=[AppDelegate currentAppDelegate].device;
            [self performSelector:@selector(connectBle) withObject:nil afterDelay:2];
            
            NSString *updateSql = [NSString stringWithFormat:@"UPDATE bike_modals SET firmversion = '%@' WHERE bikeid = '%zd'", self.latest_version,self.bikeid];
            [LVFmdbTool modifyData:updateSql];
            [self updateDeviceInfo];
        }
    });
    
}

#pragma mark - 升级完成后更新车辆版本号
- (void)updateDeviceInfo{
    
    NSMutableArray *deviceAry = [[NSMutableArray alloc] init];
    NSString *fuzzyQuerySql = [NSString stringWithFormat:@"SELECT * FROM info_modals WHERE bikeid LIKE '%zd'", self.bikeid];
    NSMutableArray *modals = [LVFmdbTool queryModelData:fuzzyQuerySql];
    ModelInfo *modelinfo = modals.firstObject;
    
    NSNumber *batttype = [NSNumber numberWithInt:(int)modelinfo.batttype];
    NSNumber *battvol = [NSNumber numberWithInt:(int)modelinfo.battvol];
    NSNumber *brandid = [NSNumber numberWithInt:(int)modelinfo.brandid];
    NSNumber *modelid = [NSNumber numberWithInt:(int)modelinfo.modelid];
    NSString *modelname = modelinfo.modelname;
    NSString *pictures = modelinfo.pictures;
    NSString *pictureb = modelinfo.pictureb;
    NSNumber *wheelsize = [NSNumber numberWithInt:(int)modelinfo.wheelsize];
    NSDictionary *model_info = [NSDictionary dictionaryWithObjectsAndKeys:batttype,@"batt_type",battvol,@"batt_vol",brandid,@"brand_id",modelid,@"model_id",modelname,@"model_name",pictures,@"picture_s",pictureb,@"picture_b",wheelsize,@"wheel_size",nil];
    
    NSString *bikeQuerySql = [NSString stringWithFormat:@"SELECT * FROM bike_modals WHERE bikeid LIKE '%zd'", self.bikeid];
    NSMutableArray *bikemodals = [LVFmdbTool queryBikeData:bikeQuerySql];
    BikeModel *bikemodel = bikemodals.firstObject;
    NSNumber *bikeid = [NSNumber numberWithInteger:bikemodel.bikeid];
    NSString *bikename = bikemodel.bikename;
    NSNumber *bindedcount = [NSNumber numberWithInteger:bikemodel.bindedcount];
    NSNumber *ownerflag = [NSNumber numberWithInteger:bikemodel.ownerflag];
    NSString *hwversion = bikemodel.hwversion;
    NSString *firversion = self.latest_version;
    NSString *mac = bikemodel.mac;
    
    NSString *brandQuerySql = [NSString stringWithFormat:@"SELECT * FROM brand_modals WHERE bikeid LIKE '%zd'", self.bikeid];
    NSMutableArray *brandmodals = [LVFmdbTool queryBrandData:brandQuerySql];
    BrandModel *brandmodel = brandmodals.firstObject;
    NSNumber *brandid2 = [NSNumber numberWithInt:(int)brandmodel.brandid];
    NSString *brandname = brandmodel.brandname;
    NSString *logo = brandmodel.logo;
    NSDictionary *brand_info = [NSDictionary dictionaryWithObjectsAndKeys:brandid2,@"brand_id",brandname,@"brand_name",logo,@"logo",nil];
    
    NSString *peripheraQuerySql = [NSString stringWithFormat:@"SELECT * FROM periphera_modals WHERE bikeid LIKE '%zd'", self.bikeid];
    NSMutableArray *peripheramodals = [LVFmdbTool queryPeripheraData:peripheraQuerySql];
    for (PeripheralModel *peripheramodel in peripheramodals) {
        
        NSNumber *deviceId = [NSNumber numberWithInt:(int)peripheramodel.deviceid];
        NSString *firversion;
        NSString *mac ;
        NSNumber *seq = [NSNumber numberWithInt:(int)peripheramodel.seq];
        NSString *sn = peripheramodel.sn;
        NSNumber *type = [NSNumber numberWithInt:(int)peripheramodel.type];
        
        if (firversion == nil) {
            firversion = @"";
        }else{
            
            firversion = peripheramodel.firmversion;
        }
        
        if (mac == nil) {
            mac = @"";
        }else{
            
            mac = peripheramodel.mac;
        }
        
        NSDictionary *device_info=[NSDictionary dictionaryWithObjectsAndKeys:deviceId,@"device_id",seq,@"seq",sn,@"sn",type,@"type",mac,@"mac",firversion,@"firm_version",nil];
        [deviceAry addObject:device_info];
    }
    
        NSDictionary *passwd_info;
        
        if (ownerflag.intValue == 1) {
            
            NSString *main = bikemodel.mainpass;
            NSString *children = @"";
            
            NSMutableArray *childrenAry = [NSMutableArray array];
            [childrenAry addObject:children];
            passwd_info = [NSDictionary dictionaryWithObjectsAndKeys:childrenAry,@"children",main,@"main",nil];
        }else if (ownerflag.intValue == 0){
            
            NSString *children = bikemodel.password;
            NSString *main = @"";
            NSMutableArray *childrenAry = [NSMutableArray array];
            [childrenAry addObject:children];
            passwd_info = [NSDictionary dictionaryWithObjectsAndKeys:childrenAry,@"children",main,@"main",nil];
        }
        
        NSDictionary *bike_info = [NSDictionary dictionaryWithObjectsAndKeys:bikeid,@"bike_id",bikename,@"bike_name",bindedcount,@"binded_count",firversion,@"firm_version",mac,@"mac",ownerflag,@"owner_flag",hwversion,@"hwversion",brand_info,@"brand_info",model_info,@"model_info",passwd_info,@"passwd_info",deviceAry,@"device_info",nil];
        
        NSString *token = [QFTools getdata:@"token"];
        
        NSString *URLString = [NSString stringWithFormat:@"%@%@",QGJURL,@"app/updatebikeinfo"];
        NSDictionary *parameters = @{@"token": token, @"bike_info": bike_info};
    
    [[HttpRequest sharedInstance] postWithURLString:URLString parameters:parameters success:^(id _Nullable dict) {
        
        if ([dict[@"status"] intValue] == 0) {
            
            [SVProgressHUD showSimpleText:@"升级完成"];
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:firversion,@"data", nil];
            [NSNOTIC_CENTER postNotification:[NSNotification notificationWithName:KNotification_FirmwareUpgradeCompleted object:nil userInfo:dict]];
        }else {
            
            [SVProgressHUD showSimpleText:dict[@"status_info"]];
        }
        
    }failure:^(NSError *error) {
        
        NSLog(@"error :%@",error);
        
    }];
}
#pragma mark - 升级完成后连接车辆
-(void)connectBle{
    self.backView.hidden = YES;
    [AppDelegate currentAppDelegate].device.upgrate = NO;
    NSString*deviceuuid=[USER_DEFAULTS stringForKey:Key_DeviceUUID];
    [[AppDelegate currentAppDelegate].device retrievePeripheralWithUUID:deviceuuid];//导入外设 根据UUID
    [[AppDelegate currentAppDelegate].device connect];
    int present = 0;
    [custompro setPresent:present];
    
}
#pragma mark - 固件升级出现错误的回调
-(void)onError:(NSString *)errorMessage
{
    NSLog(@"Error: %@", errorMessage);
    self.isErrorKnown = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        //[Utility showAlert:errorMessage];
        [self clearUI];
        
        [SVProgressHUD showSimpleText:@"固件升级失败"];
        [[AppDelegate currentAppDelegate].device stopScan];
        [custompro stopAnimation];
        self.backView.hidden = YES;
        [AppDelegate currentAppDelegate].device.centralManager.delegate=[AppDelegate currentAppDelegate].device;
        [AppDelegate currentAppDelegate].device.peripheral.delegate=[AppDelegate currentAppDelegate].device;
        [self performSelector:@selector(connectBle) withObject:nil afterDelay:2];
        
    });
}

#pragma mark - 控制器释放
- (void)dealloc {
    
    [[AppDelegate currentAppDelegate].device stopScan];
    [self unObserveAllNotifications];
    [self.queraTime invalidate];
    self.queraTime = nil;
    [self.BluetoothUpgrateAlertView dismissWithClickedButtonIndex:0 animated:YES];
    NSLog(@"bikeview被释放了");
}

- (void)unObserveAllNotifications {
    
    [NSNOTIC_CENTER removeObserver:self name:KNotification_QueryData object:nil];
    [NSNOTIC_CENTER removeObserver:self name:@"Inductionswitch" object:nil];
    [NSNOTIC_CENTER removeObserver:self name:KNotification_RemoteJPush object:nil];
    [NSNOTIC_CENTER removeObserver:self name:KNotification_UpdateValue object:nil];
    [NSNOTIC_CENTER removeObserver:self name:KNotification_SwitchingVehicle object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
