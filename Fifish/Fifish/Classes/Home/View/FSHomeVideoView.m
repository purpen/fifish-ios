//
//  FSHomeVideoView.m
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeVideoView.h"
#import "FSHomeModel.h"
#import "UIImageView+WebCache.h"

@interface FSHomeVideoView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;


@end

@implementation FSHomeVideoView

-(void)setModel:(FSHomeModel *)model{
    _model = model;
    self.timeBtn.layer.masksToBounds = YES;
    self.timeBtn.layer.cornerRadius = 5;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil];
}

@end
