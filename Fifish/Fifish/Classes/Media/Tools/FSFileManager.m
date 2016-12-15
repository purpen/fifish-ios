//
//  FSFileManager.m
//  Fifish
//
//  Created by macpro on 16/8/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFileManager.h"
#import "SVProgressHUD.h"
#import <Photos/Photos.h>
@implementation FSFileManager
+ (instancetype)defaultManager{
    
    static FSFileManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (NSMutableArray *)GetMp4AndPngFileArr{
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
        if([[file pathExtension] isEqualToString:@"mp4"]||[[file pathExtension] isEqualToString:@"png"]||[[file pathExtension] isEqualToString:@"jpg"]||[[file pathExtension] isEqualToString:@"MOV"])   //取得后缀名这.mp4的文件名
        {
            [filePathArray addObject:[docPath stringByAppendingPathComponent:file]]; //存到数组
            NSLog(@"%@",file);
            //NSLog(@"%@",filePathArray);
        }
    }
    
    return filePathArray;
}
#pragma mark 拷贝文件
- (void)CopyFilePath:(NSString *)path ToPath:(NSString *)toPath{
    NSError * error;
    NSFileManager*fileManager =[NSFileManager defaultManager];
    [fileManager copyItemAtPath:path toPath:toPath error:&error];
    
    NSLog(@"%@",error);
}
//获得项目中当前文件名里的内容
-(NSString *)bundlePath:(NSString *)fileName {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    
    //[NSBundle mainBundle] resourcePath
}

-(NSString *)SaveImageWithImage:(UIImage *)image{
//    NSData *imgData = UIImagePNGRepresentation(image);
    NSString* ImageSavePath=[NSString stringWithFormat:@"%@.png",[self getFileName]];
    BOOL isok =   [UIImagePNGRepresentation(image) writeToFile:ImageSavePath atomically:YES];
    
    NSLog(@"%d",isok);
    return ImageSavePath;
}
-(void)SaveVideoWithFilePath:(NSString *)filePath{
    NSString* SavePathstr=[NSString stringWithFormat:@"%@.%@",[self getFileName],[NSURL fileURLWithPath:filePath].pathExtension];
    [self CopyFilePath:filePath  ToPath:SavePathstr];
}
//获取当前时间
- (NSString *)getFileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* path = [paths objectAtIndex:0];
    NSLog(@"MP4 PATH: %@",path);
    
    NSDateFormatter *dateFormatter0 = [[NSDateFormatter alloc] init];
    [dateFormatter0 setDateFormat:@"yy-MM-dd HH:mm:ss:AA"];
    NSString *currentDateStr = [dateFormatter0 stringFromDate:[NSDate date]];

    NSString *SavePath=[path stringByAppendingPathComponent:currentDateStr];
    return SavePath;
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

#pragma mark 系统
- (void)SaveMediaToSysLabWithFilePath:(NSString *)filePath WithMediaType:(FSmediaType)type{
    
    //判断是否授权了
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            //未授权
            if (status == PHAuthorizationStatusDenied) {
                
                [SVProgressHUD showErrorWithStatus:@"请在设置中打开相册授权"];
                return ;
            }
            
            //已授权
            if (status == PHAuthorizationStatusAuthorized) {
                // 已经创建的自定义相册
                PHAssetCollection *createdCollection = nil;
                NSString * title = @"Fifish";
                // 获得所有的自定义相册
                PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
                for (PHAssetCollection *collection in collections) {
                    if ([collection.localizedTitle isEqualToString:title]) {
                        createdCollection = collection;
                        break;
                    }
                }
                
                if (!createdCollection) { // 没有创建过相册
                    __block NSString *createdCollectionId = nil;
                    // 创建一个新的相册
                    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
                    } error:nil];
                    
                    // 创建完毕后再取出相册
                    createdCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
                }
                
                if ( createdCollection == nil) {
                    NSLog(@"失败");
                    return;
                }
                // 将刚才添加到【相机胶卷】的图片，引用（添加）到【自定义相册】
                NSError *error = nil;
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
                    // 自定义相册封面默认保存第一张图,所以使用以下方法把最新保存照片设为封面
                    PHAssetChangeRequest * assetRequest;
                    if (type == ImageType) {
                        assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL fileURLWithPath:filePath]];
                    }
                    else{
                        assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:filePath]];
                    }
                    [request addAssets:@[assetRequest.placeholderForCreatedAsset]];
                    
                    //        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
                } error:&error];
                
                
                // 保存结果
                if (error) {
                    NSLog(@"保存失败！");
                    NSLog(@"%@",error.localizedDescription);
                } else {
                    NSLog(@"成功！");
                }
            }
        }];
    }
    
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
//        // 自定义相册封面默认保存第一张图,所以使用以下方法把最新保存照片设为封面
//        PHAssetChangeRequest * assetRequest;
//        if (type == ImageType) {
//            assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL fileURLWithPath:filePath]];
//        }
//        else{
//            assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:filePath]];
//        }
//        [request addAssets:@[assetRequest.placeholderForCreatedAsset]];
//    } completionHandler:^(BOOL success, NSError * _Nullable error) {
//        if (success) {
//            NSLog(@"存入系统成功");
//        }
//        else{
//            NSLog(@"%@",error.localizedDescription);
//        }
//    }];
}
@end
