//
//  FSVideoModel.h
//  Fifish
//
//  Created by macpro on 16/9/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMediaModel.h"
#import <Photos/Photos.h>
@interface FSVideoModel : FSMediaModel
//@property (nonatomic , strong)
@property (nonatomic , strong) UIImage * VideoPicture;

@property (nonatomic , strong) AVURLAsset * videoAsset;


@end
