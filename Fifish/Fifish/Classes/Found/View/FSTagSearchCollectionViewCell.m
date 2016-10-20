//
//  FSTagSearchCollectionViewCell.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/19.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTagSearchCollectionViewCell.h"
#import "FSTagSearchViewController.h"

@interface FSTagSearchCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *tagBtn;

@end

@implementation FSTagSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tagBtn.layer.masksToBounds = YES;
    self.tagBtn.layer.cornerRadius = 9;
    self.tagBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.tagBtn.layer.borderWidth = 1;
    [self.tagBtn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)tagClick:(UIButton*)sender{
    FSTagSearchViewController *vc = [[FSTagSearchViewController alloc] init];
    NSString *str = [sender.titleLabel.text substringFromIndex:2];
    vc.placeString = str;
    [self.navc pushViewController:vc animated:YES];
}

-(void)setTagText:(NSString *)tagText{
    _tagText = tagText;
    [self.tagBtn setTitle:[NSString stringWithFormat:@"# %@",tagText] forState:UIControlStateNormal];
}

@end
