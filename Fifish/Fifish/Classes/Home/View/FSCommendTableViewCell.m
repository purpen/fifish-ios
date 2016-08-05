//
//  FSCommendTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSCommendTableViewCell.h"

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
    
}

-(void)setFrame:(CGRect)frame{
    frame.origin.y -= 13;
    [super setFrame:frame];
}

@end
