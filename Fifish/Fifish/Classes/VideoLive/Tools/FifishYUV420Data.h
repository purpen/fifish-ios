//
//  FifishYUV420Data.h
//  FFNativeDemo
//
//  Created by macpro on 16/8/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#ifndef FifishYUV420Data_h
#define FifishYUV420Data_h

#pragma pack(push,1)

typedef struct H264FrameDef{
    unsigned int    length;
    unsigned char * dataBuffer;
    
}H264Frame;

typedef struct YUV420Def{
    unsigned int    width;
    unsigned int     height;
    H264Frame       luma;
    H264Frame       chromaB;
    H264Frame       chromaR;
}YUV420Frame;

#pragma pack(pop)
#endif /* FifishYUV420Data_h */
