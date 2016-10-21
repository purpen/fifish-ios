//
//  FSMediaModel.h
//  Fifish
//
//  Created by macpro on 16/9/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseModel.h"

@interface FSMediaModel : FSBaseModel
/**
 文件地址
 */
@property (nonatomic , strong) NSString * fileUrl;


/**
 处理完的图片
 */
@property (nonatomic ,strong ) UIImage  * flietrImage;

/**
 缩略图
 */
@property (nonatomic , strong) UIImage * defaultImage;

//初始化文件
- (instancetype)initWithFilePath:(NSString *)filePath;
@end
