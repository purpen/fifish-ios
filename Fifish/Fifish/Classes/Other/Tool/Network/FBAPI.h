//
//  FBAPI.h
//  parrot
//
//  Created by xiaoyi on 15/11/15.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "FBRequest.h"

@interface FBAPI : FBRequest

- (NSString *)uuid;
- (NSString *)time;
- (NSString *)apptype;

+ (instancetype)getWithUrlString:(NSString *)urlString
               requestDictionary:(NSDictionary *)requestDictionary
                        delegate:(id)delegate;

+ (instancetype)postWithUrlString:(NSString *)urlString
                requestDictionary:(NSDictionary *)requestDictionary
                         delegate:(id)delegate;

+ (instancetype)deleteWithUrlString:(NSString *)urlString
                requestDictionary:(NSDictionary *)requestDictionary
                         delegate:(id)delegate;

+ (instancetype)uploadWithUrlString:(NSString *)urlString
                  requestDictionary:(NSDictionary *)requestDictionary
                           delegate:(id)delegate;


/**
 上传文件

 @param uploadUrl     上传地址
 @param token         token
 @param fileUrl       文件地址
 @param progressblock 上传进度（上传过程中会循环调用这个block，progress值是进度,值范围：0-1）
 @param success       成功block
 @param failure       失败block
 */
+ (void)uploadFileWithURL:(NSString *)uploadUrl
                WithToken:(NSString *)token
                WithFileUrl:(NSURL *)fileUrl
                WihtProgressBlock:(void (^)(CGFloat progress))progressblock
                WithSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                WithFailureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 判断是否能连接ROV

 @return YES为成功，NO为失败
 */
+ (void)isExistenceROVwithBlock:(void(^)(BOOL isconnect))requestBlock;

@end
