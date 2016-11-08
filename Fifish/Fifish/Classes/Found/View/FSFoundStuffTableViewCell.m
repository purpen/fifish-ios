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
#import "CTDisplayView.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "FSUserModel.h"
#import "FSShareViewController.h"

@interface FSFoundStuffTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagtagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelLabel;

@property (weak, nonatomic) IBOutlet UIButton *headTapBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *neiRongView;

@property (weak, nonatomic) IBOutlet UIView *tagView;
/**  */
@property (nonatomic, strong) NSMutableArray *tagMAry;
@property (weak, nonatomic) IBOutlet UIImageView *addressIcon;

@end


@implementation FSFoundStuffTableViewCell

- (IBAction)shareClick:(id)sender {
    FSShareViewController *vc = [[FSShareViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.model = self.model;
    [self.myViewController presentViewController:vc animated:YES completion:nil];
}

-(NSMutableArray *)tagMAry{
    if (!_tagMAry) {
        _tagMAry = [NSMutableArray array];
    }
    return _tagMAry;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 17;
    self.fucosBtn.layer.masksToBounds = YES;
    self.fucosBtn.layer.cornerRadius = 13;
    self.fucosBtn.layer.borderWidth = 1;
    self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"7F8FA2"].CGColor;
}

- (IBAction)headTapClick:(UIButton *)sender {
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
    FSUserModel *userModel = [[FSUserModel findAll] lastObject];
    if ([_model.user_id isEqualToString:userModel.userId]) {
        self.fucosBtn.hidden = YES;
    } else {
        self.fucosBtn.hidden = NO;
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_large] placeholderImage:[UIImage imageNamed:@"me_defult"]];
    self.nameLabel.text = model.username;
    self.timeLabel.text = model.created_at;
    self.addressLabel.text = model.address;
    if (model.address.length == 0) {
        self.addressIcon.hidden = YES;
    } else {
        self.addressIcon.hidden = NO;
    }
    self.contentLabel.text = model.content;
    if ([model.kind intValue] == 1) {
        [self.videoView removeFromSuperview];
        [self.contentView addSubview:self.pictuerView];
        [_pictuerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(0);
            make.top.mas_equalTo(self.headImageView.mas_bottom).offset(8);
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
            make.top.mas_equalTo(self.headImageView.mas_bottom).offset(8);
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            make.height.mas_equalTo(210);
        }];
        [self.contentView layoutIfNeeded];
        self.videoView.model = model;
    }
    
    if (model.is_follow == 0) {
        self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"7F8FA2"].CGColor;
        self.fucosBtn.selected = NO;
    } else {
        self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"0995F8"].CGColor;
        self.fucosBtn.selected = YES;
    }
    
    if (model.is_love == 0) {
        self.likeBtn.selected = NO;
    } else {
        self.likeBtn.selected = YES;
    }
    
    CTDisplayView *view = [[CTDisplayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tagView.height)];
    view.userInteractionEnabled = YES;
    view.navc = self.navc;
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
        self.tagtagLabel.hidden = NO;
        for (int i = 0; i < model.tags.count; i ++) {
            NSDictionary *dict = model.tags[i];
            NSDictionary *cellDict = @{
                                       @"color" : @"blue",
                                       @"content" : [NSString stringWithFormat:@" %@",dict[@"name"]],
                                       @"url" : @"hh",
                                       @"type" : @"link"
                                       };
            [self.tagMAry addObject:cellDict];
        }
        config.width = SCREEN_WIDTH;
        [self.tagMAry writeToFile:filename atomically:YES];
    } else {
        self.tagtagLabel.hidden = YES;
    }
    CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
    view.data = data;
    
}

@end
