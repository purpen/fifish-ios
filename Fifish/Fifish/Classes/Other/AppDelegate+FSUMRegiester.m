//
//  AppDelegate+FSUMRegiester.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "AppDelegate+FSUMRegiester.h"

@implementation AppDelegate (FSUMRegiester)

-(void)regiesterUM{
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"580dbf76717c1916cb0043ed"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"322451778141956" appSecret:@"b19add61ab759d5b1886ff26ccd133a8" redirectURL:@"http://api.qysea.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Instagram appKey:@"1c54a1a8da6b4b5e939501d1cfdb3a93" appSecret:@"ce739bb3302c4261a39e29d623428317" redirectURL:@"http://api.qysea.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx5d74f772a28a33a4" appSecret:@"f3fdb3d58250d0444924076b168ba492" redirectURL:@"http://api.qysea.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105793308"  appSecret:@"z8o0wfxhufrXDCgn" redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3236371468"  appSecret:@"79aa38f5e760446d9fe28c92976322ed" redirectURL:@"http://api.qysea.com"];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:@"http://api.qysea.com"];
}

@end
