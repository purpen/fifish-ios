//
//  FSImageTools.h
//  Fifish
//
//  Created by macpro on 16/9/10.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "avformat.h"

@interface FSImageTools : NSObject
+ (UIImage *)decodeIdrData:(NSData *)data data_size:(int)size;

+ (void)imageFromAVPicture:(AVPicture)pict withWidth:(int)width height:(int)height;


@end
