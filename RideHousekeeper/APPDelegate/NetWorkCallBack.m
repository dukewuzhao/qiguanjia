//
//  NetWorkCallBack.m
//  RideHousekeeper
//
//  Created by Apple on 2017/12/26.
//  Copyright © 2017年 Duke Wu. All rights reserved.
//

#import "NetWorkCallBack.h"

@implementation NetWorkCallBack

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSMutableURLRequest *)urlRequest completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))originalCompletionHandler{
    
         //create a completion block that wraps the original
         void (^authFailBlock)(NSURLResponse *response, id responseObject, NSError *error) = ^(NSURLResponse *response, id responseObject, NSError *error)
         {
                 NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                 if([httpResponse statusCode] == 1001){

//                         //如果access token过期，返回错误，调用此block
//                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//
//                                 //调用refreshAccesstoken方法，刷新access token。
//                                 [self refreshAccessToken:^(AFHTTPRequestOperation *operation) {
//                                         //存取新的access token，此处我使用了KeyChain存取
//                                         NSDictionary *headerInfo = operation.response.allHeaderFields;
//                                         NSString *newAccessToken = [headerInfo objectForKey:@"access-token"];
//                                         NSString *newRefreshToken = [headerInfo objectForKey:@"refresh-token"];
//
//
//                                         //将新的access token加入到原来的请求体中，重新发送请求。
//                                         [urlRequest setValue:newAccessToken forHTTPHeaderField:@"access-token"];
//
//                                         NSURLSessionDataTask *originalTask = [super dataTaskWithRequest:urlRequest completionHandler:originalCompletionHandler];
//                                         [originalTask resume];
//                                     }];
//                             });
                     }else{
                             NSLog(@"no auth error");
                             originalCompletionHandler(response, responseObject, error);
                         }
             };
    
         NSURLSessionDataTask *stask = [super dataTaskWithRequest:urlRequest completionHandler:authFailBlock];
    
         return stask;
    
     };


 /*
      *获取新的token的方法。如何获取可以自定义，我这里用了AFNetWorking的AFHTTPRequestOperation类
      */
// -(void)refreshAccessToken:(void(^)(AFHTTPRequestOperation *responseObject))refresh{
//         NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:@"<yourURL>"];
//
//         [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//
//         //将原来的access token和refresh token发送给服务器，以获取新的token
//         //NSString *accessToken = [SSKeychain passwordForService:@"<key>" account:@"access-token"];
//         //NSString *refreshToken = [SSKeychain passwordForService:@"<key>" account:@"refresh-token"];
//
//         //[request setValue:accessToken forHTTPHeaderField:@"access-token"];
//         //[request setValue:refreshToken forHTTPHeaderField:@"refresh-token"];
//
//         //执行网络方法
//         AFHTTPRequestOperation *httpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//         [httpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation, id responseObject) {
//                 refresh(operation);
//             } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
//                     refresh(operation);
//                 }];
//         [httpRequestOperation start];
//     }

@end
