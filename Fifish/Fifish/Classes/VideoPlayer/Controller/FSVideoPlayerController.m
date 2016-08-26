//
//  FSVideoPlayerController.m
//  Fifish
//
//  Created by macpro on 16/8/19.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoPlayerController.h"

#import <Photos/Photos.h>


@implementation FSVideoPlayerController
- (void)viewDidLoad{
    [super viewDidLoad];
    UIButton * playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setTitle:@"play" forState:UIControlStateNormal];
    playBtn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:playBtn];
    [playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"%@",self.fileUrl);
}
- (void)play:(UIButton *)btn{
//    NSURL *playerURL = [NSURL URLWithString:self.fileUrl];
//    
//    UIWebView * web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
//    [self.view addSubview:web];
//    
//    [web loadRequest:[NSURLRequest requestWithURL:playerURL]];

    /*存储到系统相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL URLWithString:self.fileUrl]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"%@",success?@"成功":@"失败");
    }];
 */

    
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
        
        PHAssetChangeRequest * assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL URLWithString:self.fileUrl]];
        [request addAssets:@[assetRequest.placeholderForCreatedAsset]];

//        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    

    // 保存结果
    if (error) {
        NSLog(@"保存失败！");
    } else {
        NSLog(@"成功！");
    }
    
    PHFetchResult * getDataRequest = [PHAsset fetchAssetsInAssetCollection:createdCollection options:nil];
    [getDataRequest enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[PHImageManager defaultManager] requestAVAssetForVideo:obj options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            if ([asset isKindOfClass:[AVURLAsset class]]) {
                NSLog(@"%@",((AVURLAsset*)asset).URL);
//                NSLog(@"%lld",((AVURLAsset*)asset).duration);
                CMTimeShow(((AVURLAsset*)asset).duration);
                AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                [generator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:CMTimeMakeWithSeconds(0,2)]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
                    UIImage *thumbImg = [UIImage imageWithCGImage:image];
                    NSLog(@"%@",thumbImg);
                    
                    //回调主线程
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
                        imv.image = thumbImg;
                        [self.view addSubview:imv];
                    });
                }];
                
            }
            else{
                NSLog(@"%@",asset.accessibilityAssistiveTechnologyFocusedIdentifiers);
            }
           
        }];
        
    }];
}

@end
