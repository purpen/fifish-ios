//
//  FSImageFilterManager.h
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FSFilterType) {
    FSLOMOFilterType,
    FSMovieFilterType,
    FSBlackAndWhiteType,
};
@interface FSImageFilterManager : NSObject

//滤镜数组
@property (nonatomic,strong) NSArray * fsFilterArr;


- (UIImage *)randerImageWithFilter:(FSFilterType)filtertype WithImage:(UIImage *)image;
//TUDO: 改成枚举
- (UIImage *)randerImageWithIndex:(NSString *)filterName WithImage:(UIImage *)image;

/**
 调整亮度

 @param progressValue 亮度值

 @return 渲染完图片
 */
- (UIImage *)randerImageWithLightProgress:(CGFloat)progressValue WithImage:(UIImage *)image;

@end
