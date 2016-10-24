//
//  FSFileManager.h
//  Fifish
//
//  Created by macpro on 16/8/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    ImageType,
    VideoType,
} FSmediaType;

@interface FSFileManager : NSObject
+ (instancetype)defaultManager;

//获取Document里mp4文件数组
- (NSMutableArray *)GetMp4AndPngFileArr;


//删除文件
- (BOOL)RemoveFilePath:(NSString *)path;

//存储照片
- (NSString *)SaveImageWithImage:(UIImage *)image;

//存储视频
- (void)SaveVideoWithFilePath:(NSString *)filePath;

//拷贝文件
- (void)CopyFilePath:(NSString *)path ToPath:(NSString *)toPath;

//存入系统相册
- (void)SaveMediaToSysLabWithFilePath:(NSString *)filePath WithMediaType:(FSmediaType)type;

//从系统相册里面的fish
//- (NSMutableArray *)GetMediaWithFishSystemLibiary;

@end
