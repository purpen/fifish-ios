//
//  FSMediaBrowBottomEditView.m
//  Fifish
//
//  Created by macpro on 16/10/10.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMediaBrowBottomEditView.h"
@interface FSMediaBrowBottomEditView()
/**
 编辑分享按钮
 */
@property (nonatomic,strong) UIButton * shareEditBtn;
/**
 删除按钮
 */
@property (nonatomic,strong) UIButton * delegateBtn;

@end

@implementation FSMediaBrowBottomEditView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = FishBlackColor;
        
        [self addSubview:self.shareEditBtn];
        [self.shareEditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        [self addSubview:self.delegateBtn];
        [self.delegateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-16);
            make.centerY.mas_equalTo(self.shareEditBtn);
        }];
    }
    return self;
}


- (UIButton *)shareEditBtn{
    if (!_shareEditBtn) {
        _shareEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareEditBtn.titleLabel.textColor = [UIColor whiteColor];
        _shareEditBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_shareEditBtn setTitle:[NSString stringWithFormat:@"%@/%@",NSLocalizedString(@"edit", nil),NSLocalizedString(@"share", nil)] forState:UIControlStateNormal];
        
    }
    return _shareEditBtn;
}


- (UIButton *)delegateBtn{
    if (!_delegateBtn) {
        _delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delegateBtn setImage:[UIImage imageNamed:@"media_delete_icon"] forState:UIControlStateNormal];
    }
    return _delegateBtn;
}
@end
