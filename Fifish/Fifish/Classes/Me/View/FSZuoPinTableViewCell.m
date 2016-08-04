//
//  FSZuoPinTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/8/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSZuoPinTableViewCell.h"
#import "FSZuoPin.h"
#import "FSPictuerView.h"
#import "UIView+FSExtension.h"
#import "FSVideoView.h"

@interface FSZuoPinTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**  */
@property (nonatomic, strong) FSPictuerView *pictuerView;
/**  */
@property (nonatomic, strong) FSVideoView *videoView;

@end


@implementation FSZuoPinTableViewCell

-(FSPictuerView *)pictuerView{
    if (!_pictuerView) {
        _pictuerView = [FSPictuerView viewFromXib];
        [self.contentView addSubview:_pictuerView];
    }
    return _pictuerView;
}

-(FSVideoView *)videoView{
    if (!_videoView) {
        _videoView = [FSVideoView viewFromXib];
        [self.contentView addSubview:_videoView];
    }
    return _videoView;
}

-(void)setZuopin:(FSZuoPin *)zuopin{
    _zuopin = zuopin;
    self.timeLabel.text = @"2015-12-31";
    // 根据模型类型添加对应的内容到cell的中间
    if (zuopin.type == FSZuoPinTypePicture) { // 图片
        self.pictuerView.hidden = NO;
        self.pictuerView.zuoPin = _zuopin;
        self.pictuerView.frame = _zuopin.pictureF;
        
        self.videoView.hidden = YES;
    } else if (zuopin.type == FSZuoPinTypeVideo) { // 视频
        self.videoView.hidden = NO;
        self.videoView.zuoPin = zuopin;
        self.videoView.frame = zuopin.videoF;
        
        self.pictuerView.hidden = YES;
    }
}

@end
