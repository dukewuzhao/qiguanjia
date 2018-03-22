//
//  SideMenuViewController.m
//  RideHousekeeper
//
//  Created by Apple on 2017/8/22.
//  Copyright © 2017年 Duke Wu. All rights reserved.
//

#import "SideMenuViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PersonalViewController.h"
#import "MapViewController.h"
#import "IdeaViewController.h"
#import "HelpViewController.h"
#import "MyGarageViewController.h"
#import "SetUpViewController.h"
#import "SideMenuTableViewCell.h"
#import "BikeMessageViewController.h"
#import "GPSServicesViewController.h"

@interface SideMenuViewController ()<UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic, strong) NSString* cityname;//定位到的当前城市名称
@property (nonatomic, weak) UIImageView *userImage;
//天气属性
@property(nonatomic, weak) UIImageView *weathericon;
@property(nonatomic, weak) UILabel *weatherLab;
@property(nonatomic, weak) UILabel *temperatureLab;
@property(nonatomic, weak) UILabel *environmentLab;
@property(nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, strong)UIAlertView *LocationAlertView;

@end

@implementation SideMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //059a8b;
    _imageArray = @[@"bike_message",@"garage", @"gps_service", @"riding_map", @"user_feedback",@"course"];
    _titleArray = @[@"消息通知",@"我的车库", @"GPS服务", @"骑行导航", @"用户反馈",@"帮助中心"];
    [self setupHead];
    [self setupTableview];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, ScreenHeight - 50, 80, 30);
    [button setTitleColor:[QFTools colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    [button setTitle:@"设置" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"set_up"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(setupClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.view addSubview:button];
    
    [NSNOTIC_CENTER addObserver:self selector:@selector(updateUserIcon:) name:@"update_user_icon" object:nil];
    
    
    _inductionElectricity = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*.75  - 100, button.y - 20, 100, 20)];
    _inductionElectricity.textColor = [QFTools colorWithHexString:@"#0043b3"];
    _inductionElectricity.text = @"90%";
    _inductionElectricity.font = [UIFont systemFontOfSize:17];
    _inductionElectricity.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_inductionElectricity];
    
    _inductionImg = [[UIImageView alloc] initWithFrame:CGRectMake(_inductionElectricity.x, button.y+4, 25, 22)];
    _inductionImg.image = [UIImage imageNamed:@"induckey_break"];
    [self.view addSubview:_inductionImg];
    
    UILabel *inductionLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_inductionImg.frame), _inductionImg.y, 75, 20)];
    inductionLab.textColor = [QFTools colorWithHexString:@"555555"];
    inductionLab.text = @"感应钥匙";
    inductionLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:inductionLab];
    
}

-(void)setupHead{

    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, ScreenHeight*.337)];
    headview.layer.contents = (id)[UIImage imageNamed:@"sideMenu_head_bg"].CGImage;
    [self.view addSubview:headview];
    
    UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth *.12, headview.height *.275, headview.height *.311, headview.height *.311)];
    userIcon.backgroundColor = [QFTools colorWithHexString:MainColor];
    userIcon.layer.masksToBounds = YES;
    userIcon.layer.cornerRadius = userIcon.height/2;
    [headview addSubview:userIcon];
    
    UIImageView *userImage = [UIImageView new];
    //如果为空，从网络请求图片，否则从类存直接取
    if (![QFTools getphoto]) {
        
        NSURL *url=[NSURL URLWithString:[QFTools getuserInfo:@"icon"]];
        [userImage sd_setImageWithURL:url];
        [self performSelector:@selector(saveImage) withObject:nil afterDelay:2];
    }else{
        
        userImage.image = [QFTools getphoto];
    }
    userImage.frame = CGRectMake(0, 0, userIcon.width- 5, userIcon.height- 5);
    userImage.center = userIcon.center;
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = userImage.width/2;
    [headview addSubview:userImage];
    self.userImage = userImage;
    
    userImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *accessoriesTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userIconClicked)];
    accessoriesTap.numberOfTapsRequired = 1;
    [userImage addGestureRecognizer:accessoriesTap];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 0.066, CGRectGetMaxY(userIcon.frame) + headview.height * .066, self.view.size.width - ScreenWidth * 0.066, headview.height *.1)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:18];
    if ([QFTools getuserInfo:@"nick_name"].length == 0) {
        nameLabel.text = [QFTools getdata:@"phone_num"];
    }else{
        nameLabel.text = [QFTools getuserInfo:@"nick_name"];
    }
    [headview addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIImageView *weatherIcon = [UIImageView new];
    weatherIcon.x = CGRectGetMaxX(userIcon.frame) + ScreenWidth * 0.08;
    weatherIcon.y = userIcon.centerY - headview.height * .05;
    weatherIcon.width = headview.height * .0812;
    weatherIcon.height = headview.height * .1;
    weatherIcon.image = [UIImage imageNamed:@"duoyun"];
    [headview addSubview:weatherIcon];
    self.weathericon = weatherIcon;
    
    UIView *lineView = [UIView new];
    lineView.x = CGRectGetMaxX(weatherIcon.frame) + 10;
    lineView.y = userIcon.centerY - headview.height * .111;
    lineView.width = 0.5;
    lineView.height = headview.height * .222;
    lineView.backgroundColor = [UIColor whiteColor];
    [headview addSubview:lineView];
    
    UILabel *weatherLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+10, lineView.y + lineView.height/2 - 10, ScreenWidth*3/4 - lineView.x - 5, 20)];
    weatherLab.textColor = [UIColor whiteColor];
    weatherLab.font = [UIFont systemFontOfSize:13];
    weatherLab.text = @"天气";
    [headview addSubview:weatherLab];
    self.weatherLab = weatherLab;
    
    UILabel *temperatureLab = [[UILabel alloc] initWithFrame:CGRectMake(weatherLab.x,weatherLab.y-25, weatherLab.width, 20)];
    temperatureLab.textColor = [UIColor whiteColor];
    temperatureLab.text = @"温度";
    temperatureLab.font = [UIFont systemFontOfSize:17];
    [headview addSubview:temperatureLab];
    self.temperatureLab = temperatureLab;
    
    UILabel *environmentLab = [[UILabel alloc] initWithFrame:CGRectMake(temperatureLab.x, CGRectGetMaxY(weatherLab.frame)+5, temperatureLab.width, 20)];
    environmentLab.textColor = [UIColor whiteColor];
    environmentLab.font = [UIFont systemFontOfSize:13];
    environmentLab.text = @"空气";
    [headview addSubview:environmentLab];
    self.environmentLab = environmentLab;
    
    [self locate];
}

-(void)userIconClicked{

    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    [self XYSidePushViewController:personalVC animated:YES];
}

- (void)saveImage{
    
    NSData *fileData = [[NSData alloc] init];
    NSString *imageName = @"currentImage.png";
    fileData = UIImageJPEGRepresentation(self.userImage.image, 0.5);
    //此文件提前放在可读写区域
    // 获取沙盒目
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [fileData writeToFile:fullPath atomically:NO];
    
}


-(void)setupTableview{
    
    UITableView *rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenHeight *.374 , self.view.size.width, 300) style:UITableViewStylePlain];
    rootTableView.delegate = self;
    rootTableView.dataSource = self;
    rootTableView.scrollEnabled = NO;
    rootTableView.separatorStyle = NO;
    [self.view addSubview:rootTableView];
}

#pragma mark --- tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SideMenuTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"sideMenuCell"];
    if (!cell) {
        cell = [[SideMenuTableViewCell alloc] initWithStyle:0 reuseIdentifier:@"sideMenuCell"];
    }
    UIImageView *icon = cell.IMG;
    icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _imageArray[indexPath.row]]];
    [[cell contentView] addSubview:icon];
    
    UILabel *textLab = cell.TITLE;
    textLab.text = [NSString stringWithFormat:@"%@", _titleArray[indexPath.row]];
    textLab.font = [UIFont systemFontOfSize:18];
    [[cell contentView] addSubview:textLab];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        [self XYSidePushViewController:[BikeMessageViewController new] animated:YES];
        
    }else if (indexPath.row == 1){
    
        MyGarageViewController *MyGarageVC = [[MyGarageViewController alloc] init];
        [self XYSidePushViewController:MyGarageVC animated:YES];
        
    }else if (indexPath.row == 2){
        
        [self XYSidePushViewController:[GPSServicesViewController new] animated:YES];
        
    }else if (indexPath.row == 3){
        
        MapViewController *mapVC = [[MapViewController alloc] init];
        [self XYSidePushViewController:mapVC animated:YES];
        
    }else if (indexPath.row == 4){
        
        IdeaViewController *ideaVC = [[IdeaViewController alloc] init];
        [self XYSidePushViewController:ideaVC animated:YES];
    }else if (indexPath.row == 5){
        
        HelpViewController *helpVC = [[HelpViewController alloc] init];
        [self XYSidePushViewController:helpVC animated:YES];
    }
    
}

-(void)updateUserIcon:(NSNotification*)notification{

    NSString *NIKENAME = notification.userInfo[@"userName"];
    self.userImage.image = [QFTools getphoto];
    self.nameLabel.text = NIKENAME;
}

-(void)setupClick{

    SetUpViewController *setupVc = [SetUpViewController new];
    [self XYSidePushViewController:setupVc animated:YES];
}

- (void)locate

{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways)
        {
            
            
        }else
        {
            //用户拒绝开启用户权限
            self.LocationAlertView =[[UIAlertView alloc]initWithTitle:@"打开[定位服务权限]来允许[骑管家]确定您的位置" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            self.LocationAlertView.tag=999;
            [self.LocationAlertView show];
        }
        
    }else {
        
        //提示用户无法进行定位操作
        self.LocationAlertView = [[UIAlertView alloc]initWithTitle:@"打开[定位服务权限]来允许[骑管家]确定您的位置" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.LocationAlertView.tag = 999;
        [self.LocationAlertView show];
        
    }
    
    //用户允许获取位置权限
    self.locationManager = [[CLLocationManager alloc] init] ;
    self.locationManager.distanceFilter=1000.0f;
    self.locationManager.delegate = self;
    // 开始定位
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark -  主页面alertview的回调
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999){
        
        if (buttonIndex != [alertView cancelButtonIndex]) {
            
            NSString * urlString = @"prefs:root=LOCATION_SERVICES";
                if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
                    NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:options completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                }
        }
    }
}


//5.实现定位协议回调方法
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    //[manager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在的城市名
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     
     {
         
         if (array.count > 0)
             
         {
             
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //获取城市
             NSString *city = placemark.locality;
             
             if (!city) {
                 
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 
                 city = placemark.administrativeArea;
                 
             }
             
             if ([self.cityname isEqualToString:city]) {
                 
                 return ;
             }
             
             self.cityname = city;
             
             [self setupWeather];
         }
         
         else if (error == nil && [array count] == 0)
             
         {
             
             NSLog(@"No results were returned.");
             
         }
         
         else if (error != nil)
             
         {
             
             NSLog(@"An error occurred = %@", error);
             
         }
         
     }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        
    }
    
}


//天气接口处理
- (void)setupWeather{
    NSLog(@"请求天气了");
    if (self.cityname == nil) {
        self.cityname = @"上海";
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@?location=%@&output=json&ak=u7aBHig996uKKfHf4kzhpzq7LvVhn2dl", baidu,self.cityname];
    NSString *newStr = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newStr];
    NSURLRequest *requst = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //异步链接(形式1,较少用)
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // self.imageView.image = [UIImage imageWithData:data];
        // 解析
        
        if (response == nil) {
            [SVProgressHUD showSimpleText:TIP_OF_NO_NETWORK];
            return ;
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *weatherDict = dic[@"results"];
        NSDictionary *userinfo = weatherDict[0];
        NSMutableArray *dataDict = userinfo[@"weather_data"];
        NSString *pm25 = userinfo[@"pm25"];
        
        NSDictionary *datawe = dataDict[0];
        NSString *weather = datawe[@"weather"];
        
        NSString *dayPictureUrl = datawe[@"dayPictureUrl"];
        NSString *nightPictureUrl = datawe[@"nightPictureUrl"];
        
        self.weatherLab.text = weather;
        self.temperatureLab.text = datawe[@"temperature"];;
        
        NSString *timeStr=[QFTools replyDataAndTime];
        NSString*hourStr=[timeStr substringWithRange:NSMakeRange(11, 2)];
        
        if ([hourStr intValue] <= 17 && [hourStr intValue] >= 5) {
            NSString *weatherName = [dayPictureUrl substringFromIndex:44];
            self.weathericon.image = [UIImage imageNamed:weatherName];
            
        }else{
            
            NSString *weatherName = [nightPictureUrl substringFromIndex:46];
            self.weathericon.image = [UIImage imageNamed:weatherName];
        }
        
        if (pm25.intValue <50) {
            self.environmentLab.text = @"空气：优";
        }else if (pm25.intValue >=50 && pm25.intValue<100){
            self.environmentLab.text = @"空气：良";
        }else if (pm25.intValue >=100 && pm25.intValue<150){
            
            self.environmentLab.text = @"轻度污染";
        }else if (pm25.intValue >=150 && pm25.intValue<200){
            
            self.environmentLab.text = @"中度污染";
        }else if (pm25.intValue >=200 && pm25.intValue<250){
            
            self.environmentLab.text = @"重度污染";
        }else if (pm25.intValue >=250){
            
            self.environmentLab.text = @"橙色预警";
        }
        
    }];
    
}

-(void)dealloc{
    NSLog(@"侧边栏被释放了");
    // 停止定位
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    self.locationManager.delegate = nil;
    [NSNOTIC_CENTER removeObserver:self name:@"update_user_icon" object:nil];
    [self.LocationAlertView dismissWithClickedButtonIndex:0 animated:YES];
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
