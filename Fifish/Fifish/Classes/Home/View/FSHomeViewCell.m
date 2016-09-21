//
//  FSHomeViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/8/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeViewCell.h"
#import "FSZuoPin.h"
#import "FSHomePictuerView.h"
#import "UIView+FSExtension.h"
#import "FSHomeVideoView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface FSHomeViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commendBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *neiRongView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;


/** FSHomePictuerView */
@property (nonatomic, strong) FSHomePictuerView *pictuerView;
/**  */
@property (nonatomic, strong) FSHomeVideoView *videoView;

@end

@implementation FSHomeViewCell

-(FSHomePictuerView *)pictuerView{
    if (!_pictuerView) {
        _pictuerView = [FSHomePictuerView viewFromXib];
    }
    return _pictuerView;
}

-(FSHomeVideoView *)videoView{
    if (!_videoView) {
        _videoView = [FSHomeVideoView viewFromXib];
    }
    return _videoView;
}

-(void)setModel:(FSZuoPin *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil];
    self.nameLabel.text = model.username;
    self.timeLabel.text = @"";
    self.addressLabel.text = @"";
    self.contentLabel.text = model.content;
    if ([model.kind intValue] == 1) {
        [self.videoView removeFromSuperview];
        [self.contentView addSubview:self.pictuerView];
        [_pictuerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).offset(59);
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            make.height.mas_equalTo(model.cellHeight);
        }];
        [self.contentView layoutIfNeeded];
        self.pictuerView.model = model;
    }else if ([model.kind intValue] == 2){
        [self.pictuerView removeFromSuperview];
        [self.contentView addSubview:self.videoView];
        self.videoView.model = model;
    }
    
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [self.contentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
    if ((int)textH == 46) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"展开" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.neiRongView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(3);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(28);
            make.right.mas_equalTo(self.neiRongView.mas_right).offset(-10);
        }];
        self.bottomSpace.constant = 30;
        [self layoutIfNeeded];
    }
}

@end
