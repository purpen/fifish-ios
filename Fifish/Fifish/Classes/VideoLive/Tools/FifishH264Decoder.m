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
    
    
    AVFormatContext * _mp4outFormatContext;//输出
    AVOutputFormat  *_mp4outFmt;//输出格式
    AVStream        *_out_stream;//输出视频流
    
    long  frame_index;
}


//url
@property (nonatomic ,strong)NSString * FileUrl;

//输出地址
@property (nonatomic ,strong)NSString * OutputFileUrl;

@property (nonatomic ,assign)NSInteger  pictureWidth;//图片宽度，放置视频大小突然改变

@property (nonatomic ,assign)NSInteger  videoIndex;//视频流在文件流中的位置

//是否保存
@property (nonatomic ,assign) BOOL      IsSaveMp4File;

@end

@implementation FifishH264Decoder
- (instancetype)initWithUrl:(NSString *)Url{
    if (self= [super init]) {
        self.FileUrl = Url;
        if ([self initWithInputUrl]==0) {
            [self initDecodec];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Mp4fileNotice:) name:@"SaveMp4File" object:nil];
    }
    return self;
}

- (void)Mp4fileNotice:(NSNotification *)text{
    if ([text.userInfo[@"saveStatus"] integerValue]==1) {
        [self MakeOutFileUrl];
        [self starRecVideo];
        self.IsSaveMp4File = YES;
    }
    else{
        self.IsSaveMp4File = NO;
        [self closeMp4File];
    }
    
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
    self.width = _pCodecContext->width = SCREEN_WIDTH;
    self.height= _pCodecContext->height= SCREEN_HEIGHT;
    
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
                    if (self.IsSaveMp4File&&_pAvpacket) {
                        [self saveMp4File:_pAvpacket IsKeyFlag:_pFrame->pict_type==AV_PICTURE_TYPE_I?YES:NO];
                        
                    }
                    free(yuvFrame.luma.dataBuffer);
                    free(yuvFrame.chromaB.dataBuffer);
                    free(yuvFrame.chromaR.dataBuffer);
                }
                
                av_free_packet(_pAvpacket);
            }
            
        }
    }
}


- (void)saveMp4File:(AVPacket *)packet IsKeyFlag:(BOOL)key{
    if (packet&&_mp4outFormatContext) {
//        AVStream *in_stream = _pFormatContext->streams[0];
//        AVStream *out_stream = _mp4outFormatContext->streams[0];
//        packet->pts = av_rescale_q_rnd(packet->pts, in_stream->time_base, out_stream->time_base, AV_ROUND_NEAR_INF);
//        packet->dts = av_rescale_q_rnd(packet->dts, in_stream->time_base, out_stream->time_base, AV_ROUND_NEAR_INF);
//        packet->duration = av_rescale_q(packet->duration, in_stream->time_base, out_stream->time_base);
//        packet->pos = -1;
        packet->pts = frame_index*512;
        packet->dts = packet->pts;
        packet->duration = 512;
        packet->pos = -1;
        if (key)
        packet->flags =AV_PKT_FLAG_KEY;
        
        NSLog(@"--------->pts%lld\n-------------dts%lld\n-------------->duration%lld\n",packet->pts,packet->dts,packet->duration);
        av_interleaved_write_frame(_mp4outFormatContext, packet);
        frame_index++;
    }
}
- (void)closeMp4File{
    if (_mp4outFormatContext&&self.IsSaveMp4File == NO) {
        av_write_trailer( _mp4outFormatContext );
        frame_index = 0;
        av_dump_format(_mp4outFormatContext, 0,[self.OutputFileUrl UTF8String], 1);
    }
    
    NSFileManager * man = [NSFileManager defaultManager];
    NSLog(@"%llu",[[man attributesOfItemAtPath:self.OutputFileUrl error:nil] fileSize]);
    
}
- (void)starRecVideo{
    _mp4outFormatContext = NULL;
    _mp4outFmt = NULL;
    if (avformat_alloc_output_context2(&_mp4outFormatContext, NULL, NULL, [self.OutputFileUrl UTF8String]) < 0)
    {
        return;
    }
    
    _mp4outFmt = _mp4outFormatContext->oformat;
    if (avio_open(&(_mp4outFormatContext->pb), [self.OutputFileUrl UTF8String], AVIO_FLAG_READ_WRITE) < 0)
    {
        return ;
    }
    
    
    //视频流
    _out_stream = avformat_new_stream(_mp4outFormatContext, _pFormatContext->streams[0]->codec->codec);
    
    
    if (!_out_stream) {
        return ;
    }
    
    if(avcodec_copy_context(_out_stream->codec, _pFormatContext->streams[0]->codec)<0){
        fprintf(stderr, "Failed to copy context from input to output stream codec context\n");
        return ;
    }
    
    _out_stream->codec->codec_tag = 0;
    
    _out_stream->r_frame_rate.num=25;
    _out_stream->r_frame_rate.den=1;
    if (_mp4outFormatContext->oformat->flags & AVFMT_GLOBALHEADER)
        _out_stream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
    
    
    av_dump_format(_mp4outFormatContext, 0,[self.OutputFileUrl UTF8String], 1);
    if (avformat_write_header(_mp4outFormatContext, NULL) < 0)
    {
        fprintf(stderr, "Failed to Mp4Header");
        return ;
    }
    
}
//文件地址
- (void)MakeOutFileUrl{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* path = [paths objectAtIndex:0];
    NSLog(@"MP4 PATH: %@",path);
    
    NSDateFormatter *dateFormatter0 = [[NSDateFormatter alloc] init];
    [dateFormatter0 setDateFormat:@"yy-MM-dd HH:mm:ss:AA"];
    NSString *currentDateStr = [dateFormatter0 stringFromDate:[NSDate date]];
    //NSLog(@"Current DateFormat MP4 %@\n",currentDateStr);
    
    
    NSString* outputVideoName=[NSString stringWithFormat:@"%@.mp4",currentDateStr];
    NSString *videoOutputPath=[path stringByAppendingPathComponent:outputVideoName];
    
    self.OutputFileUrl = videoOutputPath;
    //赋值给外部只读属性
    [self setOutputMp4FileUrl:self.OutputFileUrl];

    
    
}
- (void)setOutputMp4FileUrl:(NSString *)OutputMp4FileUrl{
    _OutputMp4FileUrl = OutputMp4FileUrl;
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
