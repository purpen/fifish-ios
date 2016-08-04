//
//  FSVideoView.m
//  Fifish
//
//  Created by THN-Dong on 16/8/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoView.h"
#import "UIImageView+WebCache.h"

@interface FSVideoView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation FSVideoView

-(void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
}

-(void)setZuoPin:(FSZuoPin *)zuoPin{
    _zuoPin = zuoPin;
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@""]];
    // 时长
//    NSInteger minute = topic.videotime / 60;
//    NSInteger second = topic.videotime % 60;
//    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

@end
