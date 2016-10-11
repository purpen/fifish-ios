//
//  FSImageEditViewController.m
//  Fifish
//
//  Created by macpro on 16/10/10.
//  Copyright © 2016年 Dong. All rights reserved.
//

//tools
#import "FSImageFilterManager.h"

#import "FSImageEditViewController.h"
#import "FSImageEditBottomView.h"

#import "FSFilterCollectionView.h"
@interface FSImageEditViewController ()<FSImageEditBottomViewDelegate,FSFilterCollectionViewDelegate>

@property (nonatomic,strong) UIImageView * imageView;

/**
 滤镜CollectionView
 */
@property (nonatomic,strong) FSFilterCollectionView * FilterCollectionView;

//底部切换view
@property (nonatomic,strong) FSImageEditBottomView * bottomView;

@end

@implementation FSImageEditViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeUserInterface];
    
}

- (void)makeUserInterface{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Nav_Height);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(500);
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(@44);
    }];
    
    [self.view addSubview:self.FilterCollectionView];
    [self.FilterCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-20);
        make.height.mas_equalTo(@100);
    }];
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageWithContentsOfFile:self.MainImageModel.fileUrl];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (FSFilterCollectionView *)FilterCollectionView{
    if (!_FilterCollectionView) {
        _FilterCollectionView = [[FSFilterCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:nil];
        _FilterCollectionView.FilterDelegate = self;
        
    }
    return _FilterCollectionView;
}
- (FSImageEditBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[FSImageEditBottomView alloc] init];
        _bottomView.backgroundColor = FishBlackColor;
        _bottomView.delegate = self;
    }
    return _bottomView;
}
#pragma mark FSImageEditBottomViewDelegate
- (void)FSImageEditBottomViewChooseWithType:(FSImageEditBottomViewType)type{
    if (type == FSImageEditBottomViewadjustmentType) {
        NSLog(@"调整");
    }
    else{
        NSLog(@"滤镜");
    }
}
#pragma FsfilterCollectionDelegate

-(void)SeletedFilterWithIndex:(NSIndexPath *)indexpath{
    UIImage * immmm = [UIImage imageWithContentsOfFile:self.MainImageModel.fileUrl];
    
   UIImage * image = [FSImageFilterManager randerImageWithFilter:0 WithImage:immmm];
    
    self.imageView.image = image;
    
}
@end
