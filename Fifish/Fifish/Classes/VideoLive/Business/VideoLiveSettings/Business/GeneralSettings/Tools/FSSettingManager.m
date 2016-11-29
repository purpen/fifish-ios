//
//  FSSettingManager.m
//  Fifish
//
//  Created by macpro on 16/11/29.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSSettingManager.h"

@implementation FSSettingManager

+ (NSInteger)getDeepUnit{
   NSMutableDictionary *data = [self GetParamsDictory];
    return [data[@"deep_unit"] integerValue];
}

+(NSInteger)GetTemperatureUnit{
    NSMutableDictionary *data = [self GetParamsDictory];
    return [data[@"temperature_unit"] integerValue];
}

+(void)setDeepUnit:(NSInteger)unit{
    
   NSMutableDictionary *data = [self GetParamsDictory];
    
    [data setValue:[NSString stringWithFormat:@"%zd",unit] forKey:@"deep_unit"];
    
    [data writeToFile:[self GetPlistPath] atomically:YES];
    
}

+(void)setTemperatureUnit:(NSInteger)unit{
    
    NSMutableDictionary *data = [self GetParamsDictory];
    
    [data setValue:[NSString stringWithFormat:@"%zd",unit] forKey:@"temperature_unit"];
    
   NSLog(@"%d",[data writeToFile:[self GetPlistPath] atomically:YES]);
    
    NSLog(@"%@",[self GetParamsDictory]);
}

+ (NSMutableDictionary * )GetParamsDictory{
    NSString *plistPath = [self GetPlistPath];
    
    NSMutableDictionary * mudic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (!mudic) {
        mudic = [NSMutableDictionary dictionary];
        [mudic setObject:@"1" forKey:@"deep_unit"];
        [mudic setObject:@"0" forKey:@"temperature_unit"];
        [mudic writeToFile:[self GetPlistPath] atomically:YES];
    }
    return mudic;
}

+ (NSString *)GetPlistPath{
    
    //获取路径对象
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePatch = [path stringByAppendingPathComponent:@"FifishSetting.plist"];
    
    return  filePatch;
    
}

@end
