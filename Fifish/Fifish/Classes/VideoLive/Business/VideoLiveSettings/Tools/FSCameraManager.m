//
//  FSCameraManager.m
//  Fifish
//
//  Created by macpro on 16/9/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSCameraManager.h"
#import "FBRequest.h"
static NSString * const CameraUrlStr = @"http://192.168.2.158/cmd";

@interface FSCameraManager ()



@end

@implementation FSCameraManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)getCameraInfoWithSuccessBlock:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock{
    NSString * sttt = @"\"body\":\"null\",\"head\":{\"action\":\"CW_JSON_SnapPic\",\"code\":\"0\",\"message_id\":,\"token\":\"11\",\"type\":\"response\",\"version\":\"1.0\"}";
    NSLog(@"%lu",(unsigned long)sttt.length);
    
    NSDictionary * paams = @{@"head":@{@"action":@"CW_JSON_SnapPic",@"message_id":@"",@"type":@"request",@"token":@"11",@"version":@"1.0"},@"body":@{@"SnapPicCount":@"1",@"ChannelID":@"0",@"SnapPicFrequency":@"1"}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [FBRequest GET:CameraUrlStr parameters:@{@"CWPCmd":str} timeoutInterval:@10 requestType:HTTPRequestType responseType:HTTPResponseType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
