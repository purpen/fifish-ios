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

/**
 图片参数值

 - FSImageParamOfLight:            亮度
 - FSImageParamOfcontrast:         对比度
 - FSImageParamOfstauration:       饱和度
 - FSImageParamOfsharpness:        锐度
 - FSImageParamOfcolorTemperature: 色温
 */
typedef NS_ENUM(NSInteger,FSImageParamType) {
    FSImageParamOfLight,
    FSImageParamOfcontrast,
    FSImageParamOfstauration,
    FSImageParamOfsharpness,
    FSImageParamOfcolorTemperature,
};
@interface FSImageFilterManager : NSObject

//滤镜数组
@property (nonatomic,strong) NSArray * fsFilterArr;

//滤镜名字数组
@property (nonatomic,strong) NSArray * fsFilterNameArr;

- (UIImage *)randerImageWithFilter:(FSFilterType)filtertype WithImage:(UIImage *)image;
// TUDO: 改成枚举
- (UIImage *)randerImageWithIndex:(NSString *)filterName WithImage:(UIImage *)image;

/**
 调整亮度

 @param progressValue 亮度值调整

 @return 渲染完图片
 */
- (UIImage *)randerImageWithProgress:(CGFloat)progressValue WithImage:(UIImage *)image WithImageParamType:(FSImageParamType)paramType;


@end
