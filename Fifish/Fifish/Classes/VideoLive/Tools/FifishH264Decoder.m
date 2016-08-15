//
//  FifishH264Decoder.m
//  FFNativeDemo
//
//  Created by macpro on 16/8/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FifishH264Decoder.h"



#include <libavcodec/avcodec.h>
#import <libavformat/avformat.h>
#import <libswscale/swscale.h>
@interface FifishH264Decoder()
{

    AVFormatContext * _pFormatContext;//封装格式上下文
    AVCodec         * _pCodec;//解码器
    AVCodecContext  * _pCodecContext;//解码上下文
    AVPacket        * _pAvpacket;//帧包
    AVFrame         * _pFrame;
    
    
    
}


//url
@property (nonatomic ,strong)NSString * FileUrl;

@property (nonatomic ,assign)NSInteger  pictureWidth;//图片宽度，放置视频大小突然改变

@property (nonatomic ,assign)NSInteger  videoIndex;//视频流在文件流中的位置


@end

@implementation FifishH264Decoder
- (instancetype)initWithUrl:(NSString *)Url{
    if (self= [super init]) {
        self.FileUrl = Url;
        if ([self initWithInputUrl]==0) {
            [self initDecodec];
        }
    }
    return self;
}

//根据连接地址初始化
- (NSInteger)initWithInputUrl{
    
    //初始化所有组件
    av_register_all();
    
    //初始化网络
    avformat_network_init();
    
    //封装格式山下文
    _pFormatContext = avformat_alloc_context();
    if (avformat_open_input(&_pFormatContext,[self.FileUrl UTF8String],NULL,NULL)!=0) {
        NSLog(@"打开文件失败");
        return -1;
    }
    
    //查看地址中是否有流信息
    if (avformat_find_stream_info(_pFormatContext,NULL)<0) {
        NSLog(@"找不到视频中的流信息，或者封装格式不支持解码");
        return -1;
    }
    
    return 0;
}

//初始化解码器
- (NSInteger) initDecodec{
    _pCodec = NULL;
    _pCodecContext = NULL;
    _pFrame = NULL;
    
    
    self.pictureWidth = 0;
    
    
    avcodec_register_all();
    
    _videoIndex = -1;
    
    //查找视频流
    for (int i = 0; i<_pFormatContext->nb_streams; i++) {
        if (_pFormatContext->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
            //记录视频位置
            _videoIndex = i;
            break;
        }
    }
    
    if (_videoIndex==-1) {
        NSLog(@"没有找到视频流");
        return -1;
    }
    
    
    //取出解码上下文
    _pCodecContext = _pFormatContext->streams[_videoIndex]->codec;
    if (!_pCodecContext) {
        NSLog(@"获取解码上下文失败");
        return -1;
    }
    
    
    //视频宽高
    self.width = _pCodecContext->width;
    self.height= _pCodecContext->height;
    
    //查找解码器
    _pCodec = avcodec_find_decoder(_pCodecContext->codec_id);
    if (!_pCodec) {
        NSLog(@"查找解码器失败");
        return -1;
    }
    
    
    
    //打开解码器
    avcodec_open2(_pCodecContext,_pCodec,NULL);
    
    //实例化frame
    _pFrame = av_frame_alloc();
    if (!_pFrame) {
        NSLog(@"初始化帧失败");
        return -1;
    }
    
    
    return 0;
    
    
}

- (void)StardecodeFrame{
    //开辟线程去解码
    [NSThread detachNewThreadSelector:@selector(decodeFrame) toTarget:self withObject:nil];
    self.isRunningDecode = YES;
}

//解码
- (void)decodeFrame{
    _pAvpacket = (AVPacket *)av_malloc(sizeof(AVPacket));
    int  GotPicPtr = 0;
    while (self.isRunningDecode) {
        
        if (av_read_frame(_pFormatContext,_pAvpacket)==0) {
            
            if (_pAvpacket->stream_index == _videoIndex) {
                
                if (avcodec_decode_video2(_pCodecContext,_pFrame,&GotPicPtr,_pAvpacket)<0) {
                    NSLog(@"解码失败");
                    return;
                }
                
                
                if (GotPicPtr) {
                    
                    
                    unsigned int lumaLength = (_pCodecContext->height) * (MIN(_pFrame->linesize[0], _pCodecContext->width));
                    unsigned int chroBLength= (_pCodecContext->height)/2 * (MIN(_pFrame->linesize[1], (_pCodecContext->width)/2));
                    unsigned int chroRLength= (_pCodecContext->height)/2 * (MIN(_pFrame->linesize[2], (_pCodecContext->width)/2));
                    
                    
                    
                    YUV420Frame   yuvFrame;
                    memset(&yuvFrame, 0, sizeof(YUV420Frame));

                    yuvFrame.luma.length = lumaLength;
                    yuvFrame.chromaB.length = chroBLength;
                    yuvFrame.chromaR.length = chroRLength;
                    
                    yuvFrame.luma.dataBuffer =(unsigned char *) malloc(lumaLength);
                    yuvFrame.chromaB.dataBuffer =(unsigned char *) malloc(chroBLength);
                    yuvFrame.chromaR.dataBuffer =(unsigned char *) malloc(chroRLength);
                    
                    
                    
                    copyDecodeFrame(_pFrame->data[0], yuvFrame.luma.dataBuffer, _pFrame->linesize[0],_pCodecContext->width , _pCodecContext->height);
                    copyDecodeFrame(_pFrame->data[1], yuvFrame.chromaB.dataBuffer, _pFrame->linesize[1],_pCodecContext->width/2 , _pCodecContext->height/2);
                    copyDecodeFrame(_pFrame->data[2], yuvFrame.chromaR.dataBuffer, _pFrame->linesize[2],_pCodecContext->width/2 , _pCodecContext->height/2);
                    
                 
                    yuvFrame.width = _pCodecContext->width;
                    yuvFrame.height = _pCodecContext->height;
                    
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self updataYUVFrameOnMainThread:(YUV420Frame *)&yuvFrame];
                    });
                    
                    free(yuvFrame.luma.dataBuffer);
                    free(yuvFrame.chromaB.dataBuffer);
                    free(yuvFrame.chromaR.dataBuffer);
                }
                
                av_free_packet(_pAvpacket);
            }
            
        }
    }
}



void copyDecodeFrame(unsigned char * src, unsigned char * dist, int linesize, int width, int height)
{
//    NSLog(@"src---->%s\ndist---->%s\n%d\n%d\n%d\n",src,dist,linesize,width,height);
    width = MIN(linesize, width);
    for (NSUInteger i = 0; i < height; ++i) {
        memcpy(dist, src, width);
        dist += width;
        src +=linesize;
    }
}
//static NSData * copyFrameData(UInt8 * scr ,int linesize ,int width, int height){
//    width = MIN(linesize, width);
//    NSMutableData * md =[NSMutableData dataWithLength:width*height];
//    Byte * dst = md.mutableBytes;
//    for (NSInteger i ; i<height; ++i) {
//        memcpy(dst, scr, width);
//        dst += width;
//        scr += linesize;
//    }
//    return  md;
//}

- (void)updataYUVFrameOnMainThread:(YUV420Frame *)yuvFrame{
    if (yuvFrame) {
        if ([self.UpdataDelegate respondsToSelector:@selector(updateH264FrameData:)]) {
            [self.UpdataDelegate updateH264FrameData:yuvFrame];
        }
    }
}
- (void)dealloc
{
    
    if(_pCodecContext){
        avcodec_close(_pCodecContext);
        _pCodecContext=NULL;
    }
    
    if(_pFormatContext){
       avformat_close_input(&_pFormatContext);
        _pFormatContext=NULL;
    }
    
    if (_pAvpacket) {
        av_free(_pAvpacket);
        _pAvpacket = NULL;
    }
    
    if (_pFrame) {
        av_frame_free(&_pFrame);
        _pFrame = NULL;
    }
}
@end
