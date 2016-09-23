//
//  FSBorswerImageCell.h
//  Fifish
//
//  Created by macpro on 16/8/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class FSMediaModel;
static NSString  * const  FSBorswerImageCelliden = @"FSBorswerImageCellIden";

@interface FSBorswerImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *borswerImageView;
/**
资源模型
 */
@property (nonatomic, assign) FSMediaModel   * mediaModel;

@property (weak, nonatomic) IBOutlet UIImageView *videoIcon;

@property (weak, nonatomic) IBOutlet UILabel *durationLab;
@end
