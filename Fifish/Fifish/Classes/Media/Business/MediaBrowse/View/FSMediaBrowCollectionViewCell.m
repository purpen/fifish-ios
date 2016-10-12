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
- (void)setModel:(FSMediaModel *)model{
    _model = model;
    if ([_model isKindOfClass:[FSVideoModel class]]) {
        FSVideoModel * videomodel = (FSVideoModel *)model;
        
        self.mainImageView.image = videomodel.VideoPicture;
    }
    else{
        self.mainImageView.image = [UIImage imageWithContentsOfFile:_model.fileUrl];
    }
}
@end
