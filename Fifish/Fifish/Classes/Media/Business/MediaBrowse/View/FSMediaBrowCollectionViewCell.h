//
//  FSMediaBrowCollectionViewCell.h
//  Fifish
//
//  Created by macpro on 16/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBaseCollectionViewCell.h"
#import "FSMediaModel.h"

static NSString * const BrowCellIden = @"FSMediaBrowCollectionViewCellIedn";



@interface FSMediaBrowCollectionViewCell : FSBaseCollectionViewCell


@property (nonatomic ,assign)FSMediaModel * model;

@end
