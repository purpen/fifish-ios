//
//  FSCommendTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSCommendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FSCommentModel.h"

@interface FSCommendTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commendLabel;

@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UILabel *replyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;

@end

@implementation FSCommendTableViewCell

-(void)setModel:(FSCommentModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"login_head_default"]];
    self.timeLabel.text = @"";
    self.nameLabel.text = model.username;
    if (model.reply_user_Id.length == 0) {
        self.commendLabel.text = model.content;
        self.replyView.hidden = YES;
    } else if (model.reply_user_Id.length != 0) {
        self.commendLabel.hidden = YES;
        self.replyView.hidden = NO;
        self.replyNameLabel.text = model.reply_user_name;
        self.replyContentLabel.text = model.content;
    }
}

-(void)setFrame:(CGRect)frame{
    frame.origin.y -= 13;
    [super setFrame:frame];
}

@end
