//
//  FSReleasePictureViewController.h
//  Fifish
//
//  Created by THN-Dong on 2016/10/8.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSImageModel.h"
#import "FSVideoModel.h"

@interface FSReleasePictureViewController : UIViewController

/**
 媒体模型
 */
@property (nonatomic,strong) FSMediaModel * mediaModel;
/**
 1 图片
 2 视频
 */
@property (nonatomic, strong) NSNumber *type;

/**  */
@property (nonatomic, strong) UIImage *bigImage;


@end
