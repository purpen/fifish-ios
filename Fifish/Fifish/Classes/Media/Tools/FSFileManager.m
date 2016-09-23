//
//  FSFileManager.m
//  Fifish
//
//  Created by macpro on 16/8/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFileManager.h"

@implementation FSFileManager
+ (instancetype)defaultManager{
    static FSFileManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (NSMutableArray *)GetMp4FileArr{
    NSDirectoryEnumerator *myDirectoryEnumerator;
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:[self documentsPath]];
    
    NSString *docPath;
    docPath = [self documentsPath];   //得到文件的路径
    NSLog(@"%@", docPath);
    NSMutableArray * filePathArray = [[NSMutableArray alloc]init];   //用来存目录名字的数组
    NSString *file;
    
    while((file=[myDirectoryEnumerator nextObject]))     //遍历当前目录
    {
        if([[file pathExtension] isEqualToString:@"mp4"])   //取得后缀名这.mp4的文件名
        {
            [filePathArray addObject:[docPath stringByAppendingPathComponent:file]]; //存到数组
            NSLog(@"%@",file);
            //NSLog(@"%@",filePathArray);
        }
    }
    
    return filePathArray;
}

//获得项目中当前文件名里的内容
-(NSString *)bundlePath:(NSString *)fileName {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    
    //[NSBundle mainBundle] resourcePath
}


//获得项目中同一级文件中目录名字
-(NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

-(NSString *)documentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
- (BOOL)RemoveFilePath:(NSString *)path{
    BOOL bRet = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (bRet) {
        NSError *err;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&err];
        if (!err) {
            bRet =  YES;
        }
        else{
            bRet =  NO;
        }
    }
    return bRet;
}
@end
