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
#import "FSHomeVideoView.h"
#import "Masonry.h"

@interface FSZuoPinTableViewCell ()

/**  */
@property (nonatomic, strong) FSPictuerView *pictuerView;
/**  */
@property (nonatomic, strong) FSHomeVideoView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation FSZuoPinTableViewCell

-(FSPictuerView *)pictuerView{
    if (!_pictuerView) {
        _pictuerView = [FSPictuerView viewFromXib];
    }
    return _pictuerView;
}

-(FSHomeVideoView *)videoView{
    if (!_videoView) {
        _videoView = [FSHomeVideoView viewFromXib];
        _videoView.tapBtn.enabled = NO;
    }
    return _videoView;
}

-(void)setZuopin:(FSZuoPin *)zuopin{
    _zuopin = zuopin;
    self.timeLabel.text = zuopin.created_at;
    if ([zuopin.kind intValue] == 1) {
        [self.videoView removeFromSuperview];
        [self.contentView addSubview:self.pictuerView];
        [_pictuerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).offset(40);
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
        }];
        [self.contentView layoutIfNeeded];
        self.pictuerView.zuoPin = zuopin;
    }else if ([zuopin.kind intValue] == 2){
        [self.pictuerView removeFromSuperview];
        [self.contentView addSubview:self.videoView];
        [_videoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).offset(40);
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
        }];
        [self.contentView layoutIfNeeded];
        self.videoView.model = zuopin;
    }

}

@end
