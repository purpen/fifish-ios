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

@property (nonatomic,strong)NSMutableDictionary  * HeaderParams;


@end

@implementation FSCameraManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self HeaderParams];
    }
    return self;
}


#pragma mark camera校准
- (void)RovSetTimeZoneSuccess:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock{
    
   NSDictionary * params =  [self getTimeParams];
    [self RovControlRequestWithAction:setTimeApi WithParams:params WithSuccessBlock:successblock WithErrorBlock:failBlock];
    
}
- (NSDictionary *)getTimeParams{
    NSMutableDictionary * dateParams = [NSMutableDictionary dictionary];
    //两个固定参数
    [dateParams setObject:@"clock.isc.org" forKey:@"NtpAddress"];
    [dateParams setObject:@0 forKey:@"NtpEnable"];
    
    NSArray * keyArr = @[@"Year",@"Month",@"Day",@"Hours",@"Minute",@"Seconds"];
    
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY:MM:dd:HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSArray * timeArr = [dateString componentsSeparatedByString:@":"];
    for (int idx = 0; idx<timeArr.count; idx++) {
        
        NSString* keyStr = keyArr[idx];
        NSInteger timeNumber= [timeArr[idx] integerValue];
        
        
        if ([keyStr isEqualToString:@"Year"]) {
            //camera的起始时间为1900
            timeNumber = timeNumber-1900;
        }
        
        [dateParams setObject:[NSNumber numberWithInteger:timeNumber] forKey:keyArr[idx]];
    }
    return dateParams;
}
#pragma make 录制

- (void)RovStarRecordSuccess:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock{
    //type==1开始录制
    [self RovControlRequestWithAction:RecordAPI WithParams:@{@"ChannelID":@0,@"Type":@1} WithSuccessBlock:successblock WithErrorBlock:failBlock];
}

- (void)RovstopRecordSuccess:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock{
    //type==0停止录制
    [self RovControlRequestWithAction:RecordAPI WithParams:@{@"ChannelID":@0,@"Type":@0} WithSuccessBlock:successblock WithErrorBlock:failBlock];
}

- (void)RovTakePhotoSuccess:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock{
    [self RovControlRequestWithAction:TakePhotoAPI WithParams:@{@"SnapPicCount":@1,@"ChannelID":@0,@"SnapPicFrequency":@1} WithSuccessBlock:successblock WithErrorBlock:failBlock];
}


#pragma mark 编码相关
- (void)getVideoEncordeInfoWithSuccessBlock:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock{
    [self RovControlRequestWithAction:GetRecordInfoAPI WithParams:@{@"StreamTypeId":@7,@"ChannelID":@0,@"VideoSize":@1,@"VideoQuality":@1,@"VideoFramerate":@1,@"VideoBitrate":@1,@"VideoEncodeFormat":@1,@"H264Profiles":@1} WithSuccessBlock:successblock WithErrorBlock:failBlock];
}

- (void)RovSetEncodeingInfo:(NSDictionary *)endcodingInfo Success:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock{
    
    [self RovControlRequestWithAction:SetRecordInfoAPI WithParams:endcodingInfo WithSuccessBlock:successblock WithErrorBlock:failBlock];
}

#pragma mark camera相关
- (void)RovGetCameraSuccess:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock
{
    [self RovControlRequestWithAction:GetVideoInfoAPI WithParams:@{@"ChannelID":@0,@"BackLight":@1,@"LowLumEnable":@1,@"DayToNightModel":@1} WithSuccessBlock:successblock WithErrorBlock:failBlock];
}

-(void)RovSetCameraLowLumEnableWithON:(BOOL)isOn Success:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock{
    
    [self RovControlRequestWithAction:SetVideoInfoAPI WithParams:@{@"ChannelID":@0,@"LowLumEnable":isOn?@1:@0} WithSuccessBlock:successblock WithErrorBlock:failBlock];
}

-(void)RovSetCameraBackLightWithON:(BOOL)isOn Success:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock{
    [self RovControlRequestWithAction:SetVideoInfoAPI WithParams:@{@"BackLight":@0,@"LowLumEnable":isOn?@1:@0} WithSuccessBlock:successblock WithErrorBlock:failBlock];
}
#pragma mark SD 卡相关
- (void)RovGetSDCardInfoSuccess:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock{
    [self RovControlRequestWithAction:GetSDcardInfoAPI WithParams:@{@"ChannelID":@0,@"FileType":@1,@"FileFormat":@1} WithSuccessBlock:successblock WithErrorBlock:failBlock];
}


- (NSMutableDictionary *)HeaderParams{
    if (!_HeaderParams) {
        _HeaderParams = [@{@"message_id":@"",@"type":@"request",@"token":@"",@"version":@"1.0"} mutableCopy];
    }
    return _HeaderParams;
}






#pragma mark 基础相关
//与Camera交互
- (void)RovControlRequestWithAction:(NSString *)action WithParams:(NSDictionary *)params WithSuccessBlock:(RequestSuccessBlock)successblock WithErrorBlock:(RequestFailureBlock)failBlock{
    
    [self.HeaderParams setObject:action forKey:@"action"];
    NSString * paramsStr = [self dictoryBecomeToStrWith:@{@"head":self.HeaderParams,@"body":params}];
    
    NSLog(@"%@",paramsStr);
    [FBRequest GET:CameraUrlStr parameters:@{@"CWPCmd":paramsStr} timeoutInterval:@10 requestType:HTTPRequestType responseType:HTTPResponseType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString * responseStr =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (successblock) {
            NSDictionary * dic =[self GetTureDic:responseStr];
            NSLog(@"%@",dic);
            successblock(dic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
    
}

//字典变成字符串
- (NSString *)dictoryBecomeToStrWith:(NSDictionary *)dict{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return str;
}

//截取真正返回的字典，返回格式为：CWP124@{"body":null,"head":{"action":"CW_JSON_ManualRecord","code":0,"message_id":"","token":"","type":"response","version":"1.0"}}。删除前面的二比字符串
- (NSDictionary *)GetTureDic:(NSString*)str{
    NSArray * comArr = [str componentsSeparatedByString:@"@"];
    if (comArr.count>1&&[comArr[1] isKindOfClass:[NSString class]]) {
        return  [self dictionaryWithJsonString:comArr[1]];
    }
    else{
        return nil;
    }
}

//字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
