//
//  FSImageBrowserCell.m
//  Fifish
//
//  Created by THN-Dong on 2016/12/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageBrowserCell.h"

@implementation FSImageBrowserCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageItem = [[FSImageItem alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.contentView addSubview:self.imageItem];
    }
    return self;
}

-(void)setImageModel:(FSImageBrowserModel *)imageModel{
    if (_imageModel != imageModel) {
        _imageModel = imageModel;
    }
    self.imageItem.imageModel = self.imageModel;
}

@end
