//
//  FBAPI.m
//  parrot
//
//  Created by xiaoyi on 15/11/15.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "FBAPI.h"
#import "FSConst.h"
#import "NSString+FBMD5.h"



@implementation FBAPI

#pragma mark - Private Methods

// 获取UUID
- (NSString *)uuid {
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalKeyUUID];
    if (uuid) {
        return uuid;
    }
    // 创建新UUID
    NSString *new_uuid = [self genUid];
    [self saveUUIDToLocal:new_uuid];
    
    return new_uuid;
}

// 本地化存储
- (void)saveUUIDToLocal:(NSString *)uuid {
    NSString *k = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalKeyUUID];
    if (!k) {
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:kLocalKeyUUID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// 创建uuid
- (NSString *)genUid {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidStr = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidStr));
    CFRelease(puuid);
    CFRelease(uuidStr);
    
    return result;
}

- (NSString *)time {
//    NSDate *sendDate = [NSDate date];
//    NSCalendar  *cal = [NSCalendar  currentCalendar];
//    NSUInteger  unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
//    NSDateComponents *conponent = [cal components:unitFlags fromDate:sendDate];
//    NSInteger year = [conponent year];
//    NSInteger month = [conponent month];
//    NSInteger day = [conponent day];
//    NSString *nsDateString = [NSString stringWithFormat:@"%4ld-%2ld-%2ld", (long)year, (long)month, (long)day];
    
    NSString * nsDateString = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    return nsDateString;
}

- (NSString *)apptype {
    return KAppType;
}

- (NSString *)channel {
    return kChannel;
}

- (NSString *)clientId {
    return kClientID;
}

- (NSString *)clientSecret {
    return kClientSecret;
}

// 获取签名
- (NSString *)getSign:(NSDictionary *)params {

    NSMutableArray * keys = [NSMutableArray arrayWithArray:[params allKeys]];
    //过滤上传相关参数（tmp等）
    if ([keys containsObject:@"tmp"]) {
        [keys removeObject:@"tmp"];
    }
    if ([keys containsObject:@"id_card_a_tmp"]) {
        [keys removeObject:@"id_card_a_tmp"];
    }
    if ([keys containsObject:@"business_card_tmp"]) {
        [keys removeObject:@"business_card_tmp"];
    }
    if ([keys containsObject:@"link"]) {
        [keys removeObject:@"link"];
    }
    if ([keys containsObject:@"cover_url"]) {
        [keys removeObject:@"cover_url"];
    }
    if ([keys containsObject:@"banners_url"]) {
        [keys removeObject:@"banners_url"];
    }
    
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        int tmp = 0; // 比到第几位
        NSNumber *key1;
        NSNumber *key2;
        do {
            if (tmp > ([(NSString *)obj1 length]-1)) {
                NSAssert((tmp <= ([(NSString *)obj2 length]-1)), @"传入了两个完全相同的参数！");
                key1 = [NSNumber numberWithShort:0];
                key2 = [NSNumber numberWithShort:[(NSString *)obj2 characterAtIndex:tmp]];
                break;
            }
            
            if (tmp > ([(NSString *)obj2 length]-1)) {
                NSAssert((tmp <= ([(NSString *)obj1 length]-1)), @"传入了两个完全相同的参数！");
                key2 = [NSNumber numberWithShort:0];
                key1 = [NSNumber numberWithShort:[(NSString *)obj1 characterAtIndex:tmp]];
                break;
            }
            key1 = [NSNumber numberWithShort:[(NSString *)obj1 characterAtIndex:tmp]];
            key2 = [NSNumber numberWithShort:[(NSString *)obj2 characterAtIndex:tmp]];
            tmp++;
        } while ([key1 intValue] == [key2 intValue]);
        
        
        NSComparisonResult result = [key1 compare:key2];
        //  error
        //  return result == NSOrderedDescending;
        return result;
    }];
    
    NSMutableString *paraStr = [NSMutableString stringWithCapacity:0];
    int i = 0;
    for (NSString *key in sortedKeys) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            [paraStr appendString:[NSString stringWithFormat:@"%@=%@", key, value]];
        }else{
            [paraStr appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
        }
        i++;
    }
    
    [paraStr appendString:[self clientSecret]];
    [paraStr appendString:[self clientId]];
    
    // 两次MD5
    NSString *signStrTmp = [paraStr FBMD5Hash32];
    NSString *signStr = [signStrTmp FBMD5Hash32];
    
    return signStr;
}

- (NSDictionary *)transformRequestDictionary {
    NSMutableDictionary *fullDictionary = [[NSMutableDictionary alloc] initWithDictionary:self.requestDictionary];
    
    // 添加共用参数
    [fullDictionary setValue:[self channel] forKey:@"channel"];
    [fullDictionary setValue:[self clientId] forKey:@"client_id"];
    [fullDictionary setValue:[self uuid] forKey:@"uuid"];
    [fullDictionary setValue:[self time] forKey:@"time"];
    [fullDictionary setValue:[self apptype] forKey:@"app_type"];
    
    // 添加签名参数
    NSString *sign = [self getSign:fullDictionary];
    [fullDictionary setValue:sign forKey:@"sign"];
    
    return fullDictionary;
}

- (id)transformRequestData:(id)data {
    return data;
}

+ (instancetype)getWithUrlString:(NSString *)urlString
               requestDictionary:(NSDictionary *)requestDictionary
                        delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:requestDictionary];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    params[@"token"] = token;
    NSLog(@"字典 %@",params);
    return [FBAPI requestWithUrlString:[kDomainBaseUrl stringByAppendingString:urlString]
                     requestDictionary:params
                              delegate:delegate
                       timeoutInterval:nil
                                  flag:nil
                         requestMethod:GET_METHOD
                           requestType:HTTPRequestType
                          responseType:JSONResponseType];
}

+(instancetype)deleteWithUrlString:(NSString *)urlString requestDictionary:(NSDictionary *)requestDictionary delegate:(id)delegate{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:requestDictionary];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    params[@"token"] = token;
    return [FBAPI requestWithUrlString:[kDomainBaseUrl stringByAppendingString:urlString]
                     requestDictionary:requestDictionary
                              delegate:delegate
                       timeoutInterval:nil
                                  flag:nil
                         requestMethod:DELETE_METHOD
                           requestType:HTTPRequestType
                          responseType:JSONResponseType];
}

+ (instancetype)postWithUrlString:(NSString *)urlString
                requestDictionary:(NSDictionary *)requestDictionary
                         delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:requestDictionary];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    params[@"token"] = token;
    return [FBAPI requestWithUrlString:[kDomainBaseUrl stringByAppendingString:urlString]
                     requestDictionary:requestDictionary
                              delegate:delegate
                       timeoutInterval:nil
                                  flag:nil
                         requestMethod:POST_METHOD
                           requestType:HTTPRequestType
                          responseType:JSONResponseType];
}

+ (instancetype)uploadWithUrlString:(NSString *)urlString
                  requestDictionary:(NSDictionary *)requestDictionary
                           delegate:(id)delegate {
    
    return [FBAPI requestWithUrlString:[kDomainBaseUrl stringByAppendingString:urlString]
                     requestDictionary:requestDictionary
                              delegate:delegate
                       timeoutInterval:nil
                                  flag:nil
                         requestMethod:UPLOAD_DATA
                           requestType:HTTPRequestType
                          responseType:JSONResponseType];
}


+ (void)uploadFileWithURL:(NSString *)uploadUrl WithToken:(NSString *)token WithFileUrl:(NSURL *)fileUrl WihtProgressBlock:(void (^)(CGFloat progress))progressblock WithSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success WithFailureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    #warning afn3.0不能这么用
    AFHTTPRequestOperation * uploadOperation =[FBRequest UploadDataWithUrlString:uploadUrl parameters:@{@"token":token} timeoutInterval:@60 requestType:HTTPRequestType responseType:JSONResponseType constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:fileUrl name:@"file" error:nil];
    } success:success failure:failure];
    
    if (progressblock) {
        [uploadOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            CGFloat progress = (float)totalBytesWritten/totalBytesExpectedToWrite;
            progressblock(progress);
        }];
    }
    
}
// 从返回的URL中读取参数
+ (NSString *)getParamValueFromUrl:(NSString *)url paramName:(NSString *)paramName {
    if (![paramName hasSuffix:@"="]) {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString *str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound) {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0) {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#') {
            NSRange end = [[url substringFromIndex:start.location + start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location + start.length;
            str = end.location == NSNotFound ? [url substringFromIndex:offset] : [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    return str;
}
+ (void)isExistenceROVwithBlock:(void (^)(BOOL))requestBlock{
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ROVAddress]];
    [request setHTTPMethod:@"HEAD"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    request.timeoutInterval = 0.5;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"error %@",error);
        if (error) {
            if (requestBlock) {
                requestBlock(NO);
            }
            NSLog(@"ROV未连接");
            
        }else{
            NSLog(@"ROV已连接");
            if (requestBlock) {
                requestBlock(YES);
            }
        }
    }];
    
    [task resume];
    
}
@end
