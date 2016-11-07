//
//  FSMessageTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMessageTableViewCell.h"
#import "FSTipNumberView.h"
#import "Masonry.h"

@interface FSMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
/**  */
@property (nonatomic, strong) FSTipNumberView *tipNumberView;

@end

@implementation FSMessageTableViewCell

-(FSTipNumberView *)tipNumberView{
    if (!_tipNumberView) {
        _tipNumberView = [FSTipNumberView getTipNumView];
    }
    return _tipNumberView;
}

-(void)setDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:dict[@"icon"]];
    self.typeLabel.text = dict[@"typeLabel"];
    if ([dict[@"count"] integerValue] == 0) {
        [self.tipNumberView removeFromSuperview];
    } else {
        self.tipNumberView.tipNumLabel.text = [NSString stringWithFormat:@"%@", dict[@"count"]];
        CGSize size = [self.tipNumberView.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        [self.contentView addSubview:self.tipNumberView];
        [self.tipNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
            if ((size.width+9) > 15) {
                make.size.mas_equalTo(CGSizeMake(size.width+11, 17));
            }else{
                make.size.mas_equalTo(CGSizeMake(17, 17));
            }
            make.right.mas_equalTo(self.goIcon.mas_left).with.offset(-8);
            make.centerY.mas_equalTo(self.mas_centerY).with.offset(0);
        }];
    }
}

@end
