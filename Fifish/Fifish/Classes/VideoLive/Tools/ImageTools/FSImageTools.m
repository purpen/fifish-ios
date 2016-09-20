//
//  FSImageTools.m
//  Fifish
//
//  Created by macpro on 16/9/10.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageTools.h"
#import "libavformat/avformat.h"
#import "libswscale/swscale.h"
#import "libavcodec/avcodec.h"


#import <Photos/Photos.h>

@implementation FSImageTools
+(UIImage *)decodeIdrData:(NSData *)data data_size:(int)size

{
    
    AVCodec         *pCodec;
    
    AVCodecContext  *pCodecCtx;
    
    AVFrame         *pFrame;
    
    AVPacket        packet;
    
    AVPicture       picture;
    
    avcodec_register_all();
    
    av_register_all();
    
    avformat_network_init();
    
    pCodec = avcodec_find_decoder(AV_CODEC_ID_H264);
    
    if (pCodec == NULL) {
        
        av_log(NULL, AV_LOG_ERROR, "Unsupported codec!\n");
        
    }
    
    
    
    pCodecCtx = avcodec_alloc_context3(pCodec);
    
    // Open codec
    
    if (avcodec_open2(pCodecCtx, pCodec, NULL) < 0) {
        
        av_log(NULL, AV_LOG_ERROR, "Cannot open video decoder\n");
        
    }
    
    pFrame = av_frame_alloc();
    
    av_init_packet(&(packet));
    
    packet.data = (uint8_t *)[data bytes];
    
    packet.size = size;
    
    
    
    // AVPacket packet;
    
    int frameFinished=0;
    
    while (!frameFinished) {
        
        avcodec_decode_video2(pCodecCtx, pFrame, &frameFinished, &packet);
        
    }
    
    if (!pFrame->data[0])
        
        return nil;
    
    int outputWidth = 440;
    
    int outputHeight = 220;
    
    struct SwsContext *img_convert_ctx;
    
    // Allocate RGB picture
    
    avpicture_alloc(&picture, AV_PIX_FMT_YUV420P, outputWidth, outputHeight);
    
    // Setup scaler
    
    static int sws_flags =  SWS_FAST_BILINEAR;
    
    img_convert_ctx = sws_getContext(pCodecCtx->width,
                                     
                                     pCodecCtx->height,
                                     
                                     pCodecCtx->pix_fmt,
                                     
                                     outputWidth,
                                     
                                     outputHeight,
                                     
                                     AV_PIX_FMT_YUV420P,
                                     
                                     sws_flags, NULL, NULL, NULL);
    
    
    
    sws_scale(img_convert_ctx,
              
              (const uint8_t *const *)pFrame->data,
              
              pFrame->linesize,
              
              0,
              
              pCodecCtx->height,
              
              picture.data,
              
              picture.linesize);
    
    
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    
    CFDataRef tData = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, picture.data[0], picture.linesize[0]*outputHeight,kCFAllocatorNull);
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(tData);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef cgImage = CGImageCreate(outputWidth,
                                       
                                       outputHeight,
                                       
                                       8,
                                       
                                       24,
                                       
                                       picture.linesize[0],
                                       
                                       colorSpace,
                                       
                                       bitmapInfo,
                                       
                                       provider,
                                       
                                       NULL,
                                       
                                       NO,
                                       
                                       kCGRenderingIntentDefault);
    
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    
    CGImageRelease(cgImage);
    
    CGDataProviderRelease(provider);
    
    CFRelease(tData);
    
    
    
    // Free the packet that was allocated by av_read_frame
    
    av_free_packet(&packet);
    
    // Free the YUV frame
    
    av_free(pFrame);
    
    // Close the codec
    
    if (pCodecCtx) avcodec_close(pCodecCtx);
    
    // Close the video file
    
    
    
    //    avpicture_free(&picture);
    
    
    
    sws_freeContext(img_convert_ctx);
    
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
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        // 自定义相册封面默认保存第一张图,所以使用以下方法把最新保存照片设为封面
        
        PHAssetChangeRequest * assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        [request addAssets:@[assetRequest.placeholderForCreatedAsset]];
        
        //        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:nil];
    
    
    
    return image;
    
}

+(void)imageFromAVPicture:(AVPicture)pict withWidth:(int)width height:(int)height{
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pict.data[0], pict.linesize[0]*height, kCFAllocatorNull);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(width,
                                       height,
                                       8,
                                       24,
                                       pict.linesize[0],
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       NO,
                                       kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CFRelease(data);
    
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
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        // 自定义相册封面默认保存第一张图,所以使用以下方法把最新保存照片设为封面
        
        PHAssetChangeRequest * assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        [request addAssets:@[assetRequest.placeholderForCreatedAsset]];
        
        //        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:nil];
}
@end
