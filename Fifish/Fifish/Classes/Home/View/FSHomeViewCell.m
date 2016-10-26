//
//  FSHomeViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/8/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeViewCell.h"
#import "FSZuoPin.h"
#import "UIView+FSExtension.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "FSHomePageViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "CoreTextLinkData.h"
#import "FSTagSearchViewController.h"

@interface FSHomeViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagTag;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *neiRongView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UIButton *headTapBtn;
@property (weak, nonatomic) IBOutlet CTDisplayView *tagView;
/**  */
@property (nonatomic, strong) NSMutableArray *tagMAry;

@end

@implementation FSHomeViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 22;
}

-(NSMutableArray *)tagMAry{
    if (!_tagMAry) {
        _tagMAry = [NSMutableArray array];
    }
    return _tagMAry;
}

- (IBAction)headBtnClick:(UIButton *)sender {
    FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
    vc.userId = self.model.user_id;
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
    self.tagView.navc = self.navi;
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
            make.top.mas_equalTo(self.headImageView.mas_bottom).offset(12);
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
            make.top.mas_equalTo(self.headImageView.mas_bottom).offset(12);
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            make.height.mas_equalTo(210);
        }];
        [self.contentView layoutIfNeeded];
        self.videoView.model = model;
    }

    CTDisplayView *view = [[CTDisplayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tagView.height)];
    view.userInteractionEnabled = YES;
    view.navc = self.tagView.navc;
    view.backgroundColor = [UIColor whiteColor];
    [self.tagView addSubview:view];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:@"tag.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createFileAtPath:filename contents:nil attributes:nil];
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    [self.tagMAry removeAllObjects];
    if (model.tags.count > 0) {
        for (int i = 0; i < model.tags.count; i ++) {
            NSDictionary *dict = model.tags[i];
            NSDictionary *cellDict = @{
                                       @"color" : @"blue",
                                       @"content" : [NSString stringWithFormat:@" # %@",dict[@"name"]],
                                       @"url" : @"hh",
                                       @"type" : @"link"
                                       };
            [self.tagMAry addObject:cellDict];
        }
        config.width = SCREEN_WIDTH;
        [self.tagMAry writeToFile:filename atomically:YES];
    }
    CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
    view.data = data;
    
    
    if (model.is_love == 0) {
        self.likeBtn.selected = NO;
    } else if (model.is_love == 1) {
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
