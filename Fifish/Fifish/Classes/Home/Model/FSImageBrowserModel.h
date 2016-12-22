//
//  FSImageBrowserModel.h
//  Fifish
//
//  Created by THN-Dong on 2016/12/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSImageBrowserModel : NSObject

/** 占位图 */
@property (nonatomic, strong) UIImage *placeholder;
/** 缩略图的URL */
@property (nonatomic, strong) NSURL *thumbnailURL;
/** 缩略图 */
@property (nonatomic, strong) UIImage *thumbnailImage;
/** 高清图的URL */
@property (nonatomic, strong) NSURL *HDURL;
/** 高清图是否已经下载 */
@property (nonatomic, assign, readonly) BOOL isDownload;
/** 原始位置（点击时，该图片位于uiwindow坐标系中的位置） */
@property (nonatomic, assign) CGRect originPosition;
/** 动画的目的地位置 */
@property (nonatomic, assign, readonly) CGRect destinationFrame;
/** 标号 */
@property (nonatomic, assign) NSInteger index;

/**
 *  创建FSImageBrowserModel实例对象
 *
 *  
 *
 *
 *
 */
-(instancetype)initWithplaceholder:(UIImage *)placholder
                      thumbnailURL:(NSURL *)thumbnailURL
                             HDURL:(NSURL *)HDURL
                     containerView:(UIView *)containerView
               positionInContainer:(CGRect)positionInContainer
                             index:(NSInteger)index;

@end
