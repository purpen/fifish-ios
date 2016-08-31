//
//  FSBorswerImageCell.h
//  Fifish
//
//  Created by macpro on 16/8/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
static NSString  * const  FSBorswerImageCelliden = @"FSBorswerImageCellIden";

@interface FSBorswerImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *borswerImageView;

@property (nonatomic , assign) AVURLAsset * videoAsset;

@property (weak, nonatomic) IBOutlet UILabel *durationLab;
@end
