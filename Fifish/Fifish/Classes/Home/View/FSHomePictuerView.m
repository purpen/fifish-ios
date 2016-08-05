//
//  FSHomePictuerView.m
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomePictuerView.h"
#import "UIImageView+WebCache.h"

@interface FSHomePictuerView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation FSHomePictuerView

-(void)setModel:(FSHomeModel *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil];
}

@end
