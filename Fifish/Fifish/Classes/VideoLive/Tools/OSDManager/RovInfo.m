//
//  RovInfo.m
//  scoketDemo
//
//  Created by macpro on 16/8/30.
//  Copyright © 2016年 M-C_mac. All rights reserved.
//

#import "RovInfo.h"

@implementation RovInfo

+ (RovInfo *)sharedManager
{
    static RovInfo *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)updataWithRovDataInfo:(NSData *)rovDataInfo{
    struct RovinfoStruct info;
        unsigned char *dataBytes = (unsigned char*)rovDataInfo.bytes;
    if (*dataBytes==0xaa) {
        memcpy(&info, dataBytes, sizeof(info));
        //strcpy(&info,dataBytes);
        if ([self.delegate respondsToSelector:@selector(UpdataNewInfoWithRovInfo:)]) {
            [self.delegate UpdataNewInfoWithRovInfo:info];
        }
        
        self.Temp = [NSString stringWithFormat:@"%.1f",(((info.temp[0]&0xff)<<8)|(info.temp[1]&0xff))/10.0];
        self.Depth= (((info.depth[0]&0xff)<<8)|(info.depth[1]&0xff))/100.0;
        self.Heading_angle = ((((info.heading_angle[0]&0xff)<<8)|(info.heading_angle[1]&0xff))/100.0);
        self.Pitch_angle = ((((info.pitch_angle[0]&0xff)<<8)|(info.pitch_angle[1]&0xff))/100.0)-90.0;
        self.Roll_angle  = ((((info.roll_angle[0]&0xff)<<8)|(info.roll_angle[1]&0xff))/100.0)-90;
        self.Remain_battery = (info.battery&0xff)/100.0;
        self.distence = (info.Distance&0xff)/100.0;
        
        self.isFixedDepth = ((info.I_O&(1))==1);
        self.isFixedCruise = ((info.I_O&(1<<1))==2);
        self.isRecored = ((info.I_O&(1<<2))==4);
        self.isTakeAPicture = ((info.I_O&(1<<3))==8);
        
        if (self.isTakeAPicture) {
            NSLog(@"拍照");
        }
        
        
        NSNotification * notice = [NSNotification notificationWithName:@"RovInfoChange" object:nil userInfo:@{@"RVOINFO":self}];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    }
    else{
        NSLog(@"%@",[[NSString alloc] initWithData:rovDataInfo encoding:NSUTF8StringEncoding]);
    }
}
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%02x", (dataBytes[i]) & 0xff];
            //            if ([hexStr length] == 2) {
            [string appendString:hexStr];
            //            } else {
            //                [string appendFormat:@"0x%@ ", hexStr];
            //            }
        }
    }];
    
    return string;
}

@end
