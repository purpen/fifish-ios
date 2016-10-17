//
//  FSFoundStuffTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/9/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFoundStuffTableViewCell.h"
#import "FSZuoPin.h"

#import "UIView+FSExtension.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "FSHomePageViewController.h"

@interface FSFoundStuffTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelLabel;

@property (weak, nonatomic) IBOutlet UIButton *headTapBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *neiRongView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@end


@implementation FSFoundStuffTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 22;
    self.fucosBtn.layer.masksToBounds = YES;
    self.fucosBtn.layer.cornerRadius = 13;
    self.fucosBtn.layer.borderWidth = 1;
    self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"0995f8"].CGColor;
}

- (IBAction)headTapClick:(UIButton *)sender {
    FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
    [self.navi pushViewController:vc animated:YES];
}


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
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_large] placeholderImage:[UIImage imageNamed:@"me_defult"]];
    self.nameLabel.text = model.username;
    self.timeLabel.text = model.created_at;
    self.addressLabel.text = model.address;
    self.contentLabel.text = model.content;
    if ([model.kind intValue] == 1) {
        [self.videoView removeFromSuperview];
        [self.contentView addSubview:self.pictuerView];
        [_pictuerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).offset(59);
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            make.height.mas_equalTo(210);
        }];
        [self.contentView layoutIfNeeded];
        self.pictuerView.model = model;
    }else if ([model.kind intValue] == 2){
        [self.pictuerView removeFromSuperview];
        [self.contentView addSubview:self.videoView];
        [_videoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).offset(59);
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            make.height.mas_equalTo(210);
        }];
        [self.contentView layoutIfNeeded];
        self.videoView.model = model;
    }
    
    if (model.is_follow == 0) {
        self.fucosBtn.backgroundColor = [UIColor whiteColor];
        self.fucosBtn.selected = NO;
    } else {
        self.fucosBtn.backgroundColor = [UIColor colorWithHexString:@"0995f8"];
        self.fucosBtn.selected = YES;
    }
    
    if (model.is_love == 0) {
        self.likeBtn.selected = NO;
    } else {
        self.likeBtn.selected = YES;
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
