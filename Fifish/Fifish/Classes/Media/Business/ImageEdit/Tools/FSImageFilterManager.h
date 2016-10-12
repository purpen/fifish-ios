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

- (UIImage *)randerImageWithIndex:(NSString *)filterName WithImage:(UIImage *)image;

@end
