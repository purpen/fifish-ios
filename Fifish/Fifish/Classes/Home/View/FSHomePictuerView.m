//
//  FSHomePictuerView.m
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomePictuerView.h"
#import "UIImageView+WebCache.h"
#import "FSZuoPin.h"

@interface FSHomePictuerView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation FSHomePictuerView

-(void)setModel:(FSZuoPin *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.file_large] placeholderImage:nil];
}

@end
