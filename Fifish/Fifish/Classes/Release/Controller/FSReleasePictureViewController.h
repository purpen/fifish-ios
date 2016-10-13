//
//  FSReleasePictureViewController.h
//  Fifish
//
//  Created by THN-Dong on 2016/10/8.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseViewController.h"
#import "FSMediaModel.h"

@interface FSReleasePictureViewController : FSBaseViewController



/**
 媒体模型
 */
@property (nonatomic,assign) FSMediaModel * mediaModel;
/**
 1 图片
 2 视频
 */
@property (nonatomic, strong) NSNumber *type;

/**  */
@property (nonatomic, strong) UIImage *bigImage;

@end
