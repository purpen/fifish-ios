//
//  FSCommentTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSCommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FSHomePageViewController.h"

@interface FSCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoFlag;


@end

@implementation FSCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 16;
}

-(void)setModel:(FSRecivedPrasiedModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_large] placeholderImage:[UIImage imageNamed:@"me_defult"]];
    self.nameLabel.text = model.username;
    self.contentLabel.text = model.content;
    if (model.stuff_kind == 1) {
        self.videoFlag.hidden = YES;
    } else if (model.stuff_kind == 2) {
        self.videoFlag.hidden = NO;
    }
    self.timeLabel.text = model.comment_on_time;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.file_large] placeholderImage:[UIImage imageNamed:@"home_bigImage_default"]];
}

- (IBAction)headClick:(id)sender {
    FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
    vc.userId = self.model.userId;
    [self.myVC.navigationController pushViewController:vc animated:YES];
}

@end
