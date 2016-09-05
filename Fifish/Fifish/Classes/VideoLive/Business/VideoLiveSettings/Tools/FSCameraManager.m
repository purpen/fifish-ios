//
//  FSCameraManager.m
//  Fifish
//
//  Created by macpro on 16/9/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSCameraManager.h"
#import "FBRequest.h"

@interface FSCameraManager ()

@property (nonatomic,strong) FBRequest * cameraManger;

@end

@implementation FSCameraManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
//- (FBRequest *)cameraManger{
//    if (!_cameraManger) {
//        _cameraManger = [FBRequest requestWithUrlString:@""
//                                  requestDictionary:params
//                                           delegate:delegate
//                                    timeoutInterval:nil
//                                               flag:nil
//                                      requestMethod:POST_METHOD
//                                        requestType:HTTPRequestType
//                                       responseType:JSONResponseType];
//    }
//}
@end
