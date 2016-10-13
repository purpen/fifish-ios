//
//  FSMediaBrowCollectionViewCell.m
//  Fifish
//
//  Created by macpro on 16/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMediaBrowCollectionViewCell.h"

#import "FSVideoModel.h"
#import "FSImageModel.h"

@interface FSMediaBrowCollectionViewCell()
@property (nonatomic ,strong)UIImageView * mainImageView;

@property (nonatomic ,strong)UIButton    * playBtn;
@end

@implementation FSMediaBrowCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainImageView];
        [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(Nav_Height, 0, Nav_Height, 0));
        }];
        
        [self.mainImageView addSubview:self.playBtn];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mainImageView.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return self;
}

- (UIImageView *)mainImageView{
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc] init];
        _mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _mainImageView;
}
- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"play_icon"] forState:UIControlStateNormal];
    }
    return _playBtn;
}
- (void)setModel:(FSMediaModel *)model{
    _model = model;
    if ([_model isKindOfClass:[FSVideoModel class]]) {
        FSVideoModel * videomodel = (FSVideoModel *)model;
        self.mainImageView.image = videomodel.VideoPicture;
        self.playBtn.hidden = NO;
    }
    else{
        self.playBtn.hidden = YES;
        self.mainImageView.image = [UIImage imageWithContentsOfFile:_model.fileUrl];
    }
}
@end
