//
//  FSCameraInfoModel.h
//  Fifish
//
//  Created by macpro on 16/9/10.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseModel.h"

@interface FSCameraInfoModel : FSBaseModel
/**
 *  @author MC
 *
 *  背光
 */
@property (nonatomic,assign)BOOL * LowLumEnable;

/**
 *  @author MC
 *
 *  低照度
 */
@property (nonatomic,assign)BOOL * BackLight;

/**
 *  @author MC
 *
 *  日夜模式 指令，0 自动，1 彩色， 2 黑白
 */
@property (nonatomic,assign)NSInteger  DayToNightModel;

@end
