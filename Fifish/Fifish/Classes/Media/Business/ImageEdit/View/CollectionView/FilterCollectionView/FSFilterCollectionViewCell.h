//
//  FSFilterCollectionViewCell.h
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBaseCollectionViewCell.h"

static NSString * const FilterCellIden = @"FSFilterCollectionViewCellIedn";


@interface FSFilterCollectionViewCell : FSBaseCollectionViewCell
@property (nonatomic,assign) NSInteger  index;
@end
