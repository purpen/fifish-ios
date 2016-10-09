//
//  FSMediaBrowseViewController.h
//  Fifish
//
//  Created by macpro on 16/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FishBlackNavViewController.h"

@interface FSMediaBrowseViewController : FishBlackNavViewController
/**
 model数组
 */
@property (assign, nonatomic)NSMutableArray * modelArr;

/**
 进入页面时的下标
 */
@property                    NSInteger       seletedIndex;

@end
