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

//view
#import "FSFSImageRegulateBottomView.h"
#import "FSImageEditBottomView.h"
#import "FSFilterCollectionView.h"
#import "FSRegulateCollectionView.h"

@interface FSImageEditViewController ()<FSImageEditBottomViewDelegate,FSFilterCollectionViewDelegate,FSRegulateCollectionViewDelegate,FSFSImageRegulateBottomViewDelegate>

@property (nonatomic,strong) UIImageView * imageView;

/**
 滤镜CollectionView
 */
@property (nonatomic,strong) FSFilterCollectionView     * FilterCollectionView;

/**
 图片参数
 */
@property (nonatomic,strong) FSRegulateCollectionView   * RegulateCollectionView;


//底部切换view
@property (nonatomic,strong) FSImageEditBottomView      * bottomView;

/**
 滤镜类
 */
@property (nonatomic,strong) FSImageFilterManager       * FilterManager;


@property (nonatomic,strong) FSFSImageRegulateBottomView* ImageRegulateBottomView;
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
        make.height.mas_equalTo(450);
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo([NSNumber numberWithFloat:ImageEditBottomBarHei]);
    }];
    
    [self.view addSubview:self.FilterCollectionView];
    [self.FilterCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.view addSubview:self.RegulateCollectionView];
    [self.RegulateCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.FilterCollectionView.mas_left);
        make.top.equalTo(self.FilterCollectionView.mas_top);
        make.right.equalTo(self.FilterCollectionView.mas_right);
        make.bottom.equalTo(self.FilterCollectionView.mas_bottom);
    }];
    
    [self.view addSubview:self.ImageRegulateBottomView];
    [self.ImageRegulateBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
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
        _FilterCollectionView.collectionNumber = self.FilterManager.fsFilterArr.count;
        
    }
    return _FilterCollectionView;
}
- (FSRegulateCollectionView *)RegulateCollectionView{
    if (!_RegulateCollectionView) {
        _RegulateCollectionView = [[FSRegulateCollectionView alloc] init];
        _RegulateCollectionView.FSRegulateDelegate = self;
        _RegulateCollectionView.hidden = YES;
    }
    return _RegulateCollectionView;
}
- (FSImageEditBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[FSImageEditBottomView alloc] initWithFristTitle:NSLocalizedString(@"Filter", nil) AndSencondTitle:NSLocalizedString(@"Adjustment", nil)];
        
        _bottomView.delegate = self;
    }
    return _bottomView;
}
- (FSImageFilterManager *)FilterManager{
    if (!_FilterManager) {
        _FilterManager = [[FSImageFilterManager alloc] init];
    }
    return _FilterManager;
}
-(FSFSImageRegulateBottomView *)ImageRegulateBottomView{
    if (!_ImageRegulateBottomView) {
        _ImageRegulateBottomView = [[FSFSImageRegulateBottomView alloc] init];
        _ImageRegulateBottomView.RegulateBottomViewDelegate = self;
        _ImageRegulateBottomView.hidden = YES;
    }
    return _ImageRegulateBottomView;
}
#pragma mark FSImageEditBottomViewDelegate
- (void)FSImageEditBottomViewChooseWithIndex:(NSInteger)type{
    if (type == 1) {
        NSLog(@"调整");
        self.FilterCollectionView.hidden = YES;
        self.RegulateCollectionView.hidden = NO;
    }
    else{
        NSLog(@"滤镜");
        self.FilterCollectionView.hidden = NO;
        self.RegulateCollectionView.hidden = YES;
    }
}
#pragma mark FSFSImageRegulateBottomViewDelegate
- (void)FSFSImageRegulateBottomViewCancel{
    //隐藏参数调整滑动条
    self.ImageRegulateBottomView.hidden = YES;
}
#pragma FsfilterCollectionDelegate

-(void)SeletedFilterWithIndex:(NSIndexPath *)indexpath{
    UIImage * immmm = [UIImage imageWithContentsOfFile:self.MainImageModel.fileUrl];
    
   UIImage * image = [[[FSImageFilterManager alloc] init] randerImageWithIndex:self.FilterManager.fsFilterArr[indexpath.row] WithImage:immmm];
    
    self.imageView.image = image;
    
}

#pragma mark FSFilterCollectionViewDelegate
-(void)RegulateSeletedParameter:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    //显示参数调整滑动条
    self.ImageRegulateBottomView.hidden = NO;
}
@end
