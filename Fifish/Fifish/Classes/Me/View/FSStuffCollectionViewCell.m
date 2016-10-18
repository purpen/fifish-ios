//
//  FSStuffCollectionViewCell.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/18.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSStuffCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface FSStuffCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *playImagView;


@end

@implementation FSStuffCollectionViewCell

-(void)setModel:(FSZuoPin *)model{
    _model = model;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.file_large] placeholderImage:nil];
    if ([model.kind intValue] == 1) {
        self.playImagView.hidden = YES;
    } else if ([model.kind intValue] == 2) {
        self.playImagView.hidden = NO;
    }
}

@end
