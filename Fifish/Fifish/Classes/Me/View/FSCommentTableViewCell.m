//
//  FSCommentTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSCommentTableViewCell.h"

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

- (IBAction)headClick:(id)sender {
}

@end
