//
//  AppDelegate+Login.m
//  RideHousekeeper
//
//  Created by Apple on 2018/1/5.
//  Copyright © 2018年 Duke Wu. All rights reserved.
//

#import "AppDelegate+Login.h"

@implementation AppDelegate (Login)


- (void)logindata{
    
    NSString *password= [QFTools getdata:@"password"];
    NSString *phonenum= [QFTools getdata:@"phone_num"];
    
    if ([QFTools isBlankString:phonenum]) {
        return;
    }
    
    NSString *pwd = [NSString stringWithFormat:@"%@%@%@",@"QGJ",password,@"BLE"];
    NSString * md5=[QFTools md5:pwd];
    NSString *URLString = [NSString stringWithFormat:@"%@%@",QGJURL,@"app/login"];
    NSDictionary *parameters = @{@"account": phonenum, @"passwd": md5.uppercaseString};
    
    AFHTTPSessionManager *manager = [QFTools sharedManager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/x-gzip"];
    
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable dict) {
        if ([dict[@"status"] intValue] == 0) {
            
            NSDictionary *data = dict[@"data"];
            LoginDataModel *loginModel = [LoginDataModel yy_modelWithDictionary:data];
            NSString * token=loginModel.token;
            NSString * defaultlogo = loginModel.default_brand_logo;
            NSString * defaultimage = loginModel.default_model_picture;
            UserInfoModel *userinfo = loginModel.user_info;
            NSString * birthday=userinfo.birthday;
            NSString * nick_name=userinfo.nick_name;
            NSNumber * gender = [NSNumber numberWithInteger:userinfo.gender];
            NSString * icon = userinfo.icon;
            NSString * realName = userinfo.real_name;
            NSString *idcard = userinfo.id_card_no;
            NSNumber *userId = [NSNumber numberWithInteger:userinfo.user_id];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",phonenum,@"phone_num",password,@"password",defaultlogo,@"defaultlogo",defaultimage,@"defaultimage",userId,@"userid",nil];
            [userDefaults setObject:userDic forKey:logInUSERDIC];
            [userDefaults synchronize];
            
            NSDictionary *userDic2 = [NSDictionary dictionaryWithObjectsAndKeys:phonenum,@"username",birthday,@"birthday",nick_name,@"nick_name",gender,@"gender",icon,@"icon",realName,@"realname",idcard,@"idcard",nil];
            [userDefaults setObject:userDic2 forKey:userInfoDic];
            [userDefaults synchronize];
            
            [LVFmdbTool deleteBrandData:nil];
            [LVFmdbTool deleteBikeData:nil];
            [LVFmdbTool deleteModelData:nil];
            [LVFmdbTool deletePeripheraData:nil];
            [LVFmdbTool deleteFingerprintData:nil];
            [AppDelegate currentAppDelegate].macArrM2 = [NSMutableArray new];
            [AppDelegate currentAppDelegate].passwordArrM2 = [NSMutableArray new];
            
            for (BikeInfoModel *bikeInfo in loginModel.bike_info) {
                
                [[AppDelegate currentAppDelegate].macArrM2 addObject:bikeInfo.mac];
                if (bikeInfo.owner_flag == 1) {
                    [AppDelegate currentAppDelegate].child2 = @"0";
                    [AppDelegate currentAppDelegate].main2 = bikeInfo.passwd_info.main;
                    NSString* masterpwd = [QFTools toHexString:(long)[[AppDelegate currentAppDelegate].main2 longLongValue]];
                    int masterpwdCount = 8 - (int)masterpwd.length;
                    
                    for (int i = 0; i<masterpwdCount; i++) {
                        masterpwd = [@"0" stringByAppendingFormat:@"%@",masterpwd];
                    }
                    [[AppDelegate currentAppDelegate].passwordArrM2 addObject:masterpwd];
                }else if (bikeInfo.owner_flag == 0){
                    
                    [AppDelegate currentAppDelegate].child2 = bikeInfo.passwd_info.children.firstObject;
                    [AppDelegate currentAppDelegate].main2 = @"0";
                    
                    NSString* childpwd = [QFTools toHexString:(long)[[AppDelegate currentAppDelegate].child2 longLongValue]];
                    int childpwdCount = 8 - (int)childpwd.length;
                    
                    for (int i = 0; i<childpwdCount; i++) {
                        childpwd = [@"0" stringByAppendingFormat:@"%@",childpwd];
                    }
                    [[AppDelegate currentAppDelegate].passwordArrM2 addObject:childpwd];
                }
                
                NSString *logo = bikeInfo.brand_info.logo;
                NSString *picture_b = bikeInfo.model_info.picture_b;
                
                BikeModel *pmodel = [BikeModel modalWith:bikeInfo.bike_id bikename:bikeInfo.bike_name ownerflag:bikeInfo.owner_flag hwversion:bikeInfo.hw_version firmversion:bikeInfo.firm_version keyversion:bikeInfo.key_version mac:bikeInfo.mac mainpass:[AppDelegate currentAppDelegate].main2 password:[AppDelegate currentAppDelegate].child2 bindedcount:bikeInfo.binded_count ownerphone:bikeInfo.owner_phone];
                [LVFmdbTool insertBikeModel:pmodel];
                
                if (bikeInfo.brand_info.brand_id == 0) {
                    logo = defaultlogo;
                }
                
                BrandModel *bmodel = [BrandModel modalWith:bikeInfo.bike_id brandid:bikeInfo.brand_info.brand_id brandname:bikeInfo.brand_info.brand_name logo:logo];
                [LVFmdbTool insertBrandModel:bmodel];
                
                if (bikeInfo.model_info.model_id == 0) {
                    picture_b = defaultimage;
                }
                
                ModelInfo *Infomodel = [ModelInfo modalWith:bikeInfo.bike_id modelid:bikeInfo.model_info.model_id modelname:bikeInfo.model_info.model_name batttype:bikeInfo.model_info.batt_type battvol:bikeInfo.model_info.batt_vol wheelsize:bikeInfo.model_info.wheel_size brandid:bikeInfo.model_info.brand_id pictures:bikeInfo.model_info.picture_s pictureb:bikeInfo.model_info.picture_b];
                [LVFmdbTool insertModelInfo:Infomodel];
                
                for (DeviceInfoModel *device in bikeInfo.device_info){
                    
                    PeripheralModel *permodel = [PeripheralModel modalWith:bikeInfo.bike_id deviceid:device.device_id type:device.type seq:device.seq mac:device.mac sn:device.sn firmversion:device.firm_version];
                    [LVFmdbTool insertDeviceModel:permodel];
                }
                
                for (FingerModel *finger in bikeInfo.fps){
                    FingerprintModel *fingermodel = [FingerprintModel modalWith:bikeInfo.bike_id fp_id:finger.fp_id pos:finger.pos name:finger.name added_time:finger.added_time];
                    [LVFmdbTool insertFingerprintModel:fingermodel];
                }
            }
            
            NSString*macstring = [[NSUserDefaults standardUserDefaults] stringForKey:Key_MacSTRING];
            NSDictionary *passwordDic = [[NSUserDefaults standardUserDefaults] objectForKey:passwordDIC];
            NSMutableArray *bikeAry = [LVFmdbTool queryBikeData:nil];
            
            NSLog(@"%@----%@",[AppDelegate currentAppDelegate].macArrM2,macstring);
            
            if (![[AppDelegate currentAppDelegate].macArrM2 containsObject:macstring]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:SETRSSI];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_DeviceUUID];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_MacSTRING];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:passwordDIC];
                if (bikeAry.count > 0) {
                    BikeModel *firstbikeinfo = bikeAry[0];
                    [[NSUserDefaults standardUserDefaults]setValue:firstbikeinfo.mac.uppercaseString forKey:SETRSSI];
                }
                
                [self.device remove];
                
            }else{
                //在检测密码是否一致
                NSLog(@"mima%@ ---- %@",[AppDelegate currentAppDelegate].passwordArrM2,passwordDic[@"main"]);
                if (![[AppDelegate currentAppDelegate].passwordArrM2 containsObject:passwordDic[@"main"]]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_DeviceUUID];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:passwordDIC];
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:[[AppDelegate currentAppDelegate].passwordArrM2 firstObject],@"main",nil];
                    [USER_DEFAULTS setObject:userDic forKey:passwordDIC];
                    [USER_DEFAULTS synchronize];
                }
                
                [[NSUserDefaults standardUserDefaults]setValue:macstring forKey:SETRSSI];
            }
            
            if ([LVFmdbTool queryBikeData:nil].count == 0) {
                
                if ([[AppDelegate currentAppDelegate].mainController isKindOfClass:[BikeViewController class]]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
                }
            }else{
                
                if ([[AppDelegate currentAppDelegate].mainController isKindOfClass:[ViewController class]]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
                }
            }
            
            NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
            NSString* phoneModel = [[UIDevice currentDevice] model];
            NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString] ;
            NSString*modelname =[NSString stringWithFormat:@"%@|%@|%@",phoneModel,phoneVersion,identifierNumber];
            NSString *regid = [JPUSHService registrationID];
            NSNumber *chanel = [NSNumber numberWithInt:1];
            
            if (regid == nil) {
                regid = @"";
            }
            
            NSString *URLString = [NSString stringWithFormat:@"%@%@",QGJURL,@"app/pushonline"];
            NSDictionary *parameters = @{@"token": token, @"device_name": modelname,@"channel": chanel,@"reg_id": regid};
            
            AFHTTPSessionManager *manager = [QFTools sharedManager];
            manager.requestSerializer=[AFJSONRequestSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/x-gzip"];
            [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable dict) {
                
                NSLog(@"手机型号上传: %@",dict[@"status_info"] );
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error :%@",error);
                
                [SVProgressHUD showSimpleText:TIP_OF_NO_NETWORK];
            }];
        }
        else if([dict[@"status"] intValue] == 1001){
            
            [SVProgressHUD showSimpleText:dict[@"status_info"]];
            
        }else if([dict[@"status"] intValue] == 1002){
            [SVProgressHUD showSimpleText:@"用户名或密码错误,请重新登录"];
            [self individuaBtnClick];
            
        }else{
            [SVProgressHUD showSimpleText:dict[@"status_info"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error :%@",error);
        [SVProgressHUD showSimpleText:TIP_OF_NO_NETWORK];
    }];
}

- (void)individuaBtnClick
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
        [userDefatluts removeObjectForKey:logInUSERDIC];
        [userDefatluts synchronize];
        [self.device remove];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_DeviceUUID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_MacSTRING];
        [userDefatluts removeObjectForKey:passwordDIC];
        [userDefatluts synchronize];
        
        self. device.deviceStatus=5;
        [NSNOTIC_CENTER postNotification:[NSNotification notificationWithName:KNotification_UpdateDeviceStatus object:nil]];
        
        NSFileManager * fileManager = [[NSFileManager alloc]init];
        NSString *imageName = @"currentImage.png";
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
        [fileManager removeItemAtPath:fullPath error:nil];
        // [self deleteFile];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        
    });
}

@end
