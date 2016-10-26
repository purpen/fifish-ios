//
//  FSImageEditViewController.m
//  Fifish
//
//  Created by macpro on 16/10/10.
//  Copyright © 2016年 Dong. All rights reserved.
//

//tools
#import "FSImageFilterManager.h"

//vc
#import "FSImageEditViewController.h"
#import "FSReleasePictureViewController.h"

//view
#import "FSFSImageRegulateBottomView.h"
#import "FSImageEditBottomView.h"
#import "FSFilterCollectionView.h"
#import "FSRegulateCollectionView.h"
#import "FSAlertView.h"

//model
#import "FSFliterImage.h"

@interface FSImageEditViewController ()<FSImageEditBottomViewDelegate,FSFilterCollectionViewDelegate,FSRegulateCollectionViewDelegate,FSFSImageRegulateBottomViewDelegate>

@property (nonatomic,strong) UIImageView * imageView;

//TODO:如果图片过大此处三个图片变量会耗费很大内存，后期需要优化处理
//原始图片 第一级处理
@property (nonatomic,strong,readonly) UIImage     * originalImage;
//经过滤镜处理的图片  二级处理
@property (nonatomic,strong) UIImage     * FliterImage;
//经过参数调整的图片 三级处理
@property (nonatomic,strong) FSFliterImage     * ParamsImage;

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


/**
 参数调整
 */
@property (nonatomic,strong) FSFSImageRegulateBottomView* ImageRegulateBottomView;

//中间变量，记录编辑参数类型
@property (nonatomic)        NSInteger            editType;


@end

@implementation FSImageEditViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUserInterface];
    
    [self setNavView];
    
}

- (void)setNavView{
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0, 0, 40, 40);
    [nextBtn setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(gotoshareVC) forControlEvents:UIControlEventTouchUpInside];
    [self setRightItem:nextBtn];
}
- (void)NavBack{
    [[[FSAlertView alloc] init] showAlertView:self title:NSLocalizedString(@"Give up editing?", nil) message:NSLocalizedString(@"If you return now, the picture editor will be cancelled.", nil) canceltitle:NSLocalizedString(@"Give up", nil) oktitle:NSLocalizedString(@"Retain", nil) confirmBlock:^{
        
    } cancelBlock:^{
        [super NavBack];
    }];
}
- (void)gotoshareVC{
    
    FSReleasePictureViewController * vc = [[FSReleasePictureViewController alloc] init];
    vc.type = @1;
    self.MainImageModel.flietrImage = self.imageView.image;
    vc.mediaModel= self.MainImageModel;
    [self.navigationController pushViewController:vc animated:YES];
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
        make.height.mas_equalTo(@110);
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
        make.height.mas_equalTo(@150);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.bottomView.mas_bottom);
    }];
}
- (void)setMainImageModel:(FSImageModel *)MainImageModel{
    _MainImageModel = MainImageModel;
    _originalImage = [UIImage imageWithContentsOfFile:self.MainImageModel.fileUrl];
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageWithContentsOfFile:self.MainImageModel.fileUrl];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

-(FSFliterImage *)ParamsImage{
    if (!_ParamsImage) {
        _ParamsImage = [[FSFliterImage alloc] init];

    }
    return _ParamsImage;
}

- (FSFilterCollectionView *)FilterCollectionView{
    if (!_FilterCollectionView) {
        _FilterCollectionView = [[FSFilterCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:nil];
        _FilterCollectionView.collectionNumber = self.FilterManager.fsFilterArr.count;
        _FilterCollectionView.FilterDelegate = self;
        _FilterCollectionView.originalImage = self.originalImage;
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
        _ImageRegulateBottomView = [[FSFSImageRegulateBottomView alloc] initWithFrame:CGRectZero];
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

#pragma FsfilterCollectionDelegate

-(void)SeletedFilterWithIndex:(NSIndexPath *)indexpath{
   self.imageView.image = self.ParamsImage.image  = [self.FilterManager randerImageWithIndex:self.FilterManager.fsFilterArr[indexpath.row] WithImage:self.originalImage];

}
#pragma mark FSFilterCollectionViewDelegate
-(void)RegulateSeletedParameter:(NSIndexPath *)indexPath{
    
    //点击参数值设定，显示参数调整滑动条
    self.ImageRegulateBottomView.hidden = NO;
    [self.ImageRegulateBottomView.SliderView setSliederWithType:indexPath.row AndImage:self.ParamsImage];
    
    //记录编辑类型
    self.editType = indexPath.row;
    NSLog(@"type:%ld,value:%f",(long)self.editType,self.ImageRegulateBottomView.SliderView.sliderCurrentValue);
}

#pragma mark FSFSImageRegulateBottomViewDelegate
- (void)FSFSImageRegulateBottomViewCancel{
    //隐藏参数调整滑动条
    self.ImageRegulateBottomView.hidden = YES;
    self.imageView.image = self.ParamsImage.image?self.ParamsImage.image:self.originalImage;

}
- (void)FSFSImageRegulateBottomViewConfirm{
    self.ImageRegulateBottomView.hidden = YES;
    NSLog(@"type:%ld,value:%f",(long)self.editType,self.ImageRegulateBottomView.SliderView.sliderCurrentValue);
    //记录参数值
    [self.ParamsImage updataParamsWithIndex:self.editType WithValue:self.ImageRegulateBottomView.SliderView.sliderCurrentValue];
    
    
    self.ParamsImage.image = self.imageView.image;
    
}

-(void)FSFSImageRegulateBottomViewSliderValuechange:(CGFloat)value{

    self.imageView.image = [self.FilterManager randerImageWithProgress:value WithImage:self.ParamsImage.image?self.ParamsImage.image:self.originalImage WithImageParamType:self.editType];
    
    
}
@end
