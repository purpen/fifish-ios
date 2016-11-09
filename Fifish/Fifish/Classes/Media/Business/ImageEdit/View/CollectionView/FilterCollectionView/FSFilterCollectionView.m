//
//  FSFilterCollectionView.m
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFilterCollectionView.h"
#import "FSFilterCollectionViewCell.h"
#import "FSImageFilterManager.h"

static NSInteger const CellHei = 90;
static NSInteger const CellWei = 70;

@interface FSFilterCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//原始图片压缩后的图片
@property (nonatomic ,strong)UIImage * MainImage;

/**
 滤镜预览图片数组
 */
@property (nonatomic ,strong)NSMutableArray * FilerPreviewPicturArr;

/**
 滤镜名字
 */
@property (nonatomic ,strong)NSArray * FilteraNameArr;



@end

@implementation FSFilterCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (layout) {
        self = [super initWithFrame:frame collectionViewLayout:layout];
    }
    else{
        UICollectionViewFlowLayout *flayout = [[UICollectionViewFlowLayout alloc] init];
        [flayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flayout.minimumLineSpacing = 20;
        flayout.minimumInteritemSpacing = 20;
        self = [super initWithFrame:frame collectionViewLayout:flayout];
    }
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[FSFilterCollectionViewCell class] forCellWithReuseIdentifier:FilterCellIden];
    }
    return self;
}
#pragma mark Filter数组
- (void)randerFilterImage{
    self.FilerPreviewPicturArr = [NSMutableArray arrayWithCapacity:self.collectionNumber];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i<self.collectionNumber; i++) {
            FSImageFilterManager  * FilterManager = [[FSImageFilterManager alloc] init];
            UIImage * image = [FilterManager randerImageWithIndex:FilterManager.fsFilterArr[i] WithImage:self.MainImage];
            [self.FilerPreviewPicturArr addObject:image];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"FSfilterName" ofType:@"plist"];
            self.FilteraNameArr = [NSArray arrayWithContentsOfFile:path];
            
            [self reloadData];
        });
        
    });
    
}
#pragma mark UIcollectionviewdelegate
//个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionNumber;
}
//单元大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CellWei, CellHei);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSFilterCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:FilterCellIden forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.FilterNameLab.text = self.FilteraNameArr[indexPath.row];
    
//  滤镜预览图片数组是异步加载，判断是否加载完再取值
    cell.FilterImageView.image =self.FilerPreviewPicturArr.count == self.collectionNumber ? self.FilerPreviewPicturArr[indexPath.row]:nil;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.FilterDelegate&&[self.FilterDelegate respondsToSelector:@selector(SeletedFilterWithIndex:)]) {
        
        [self.FilterDelegate SeletedFilterWithIndex:indexPath];
        
        //改变文字选中颜色
        FSFilterCollectionViewCell * cell = (FSFilterCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.FilterNameLab.textColor = [UIColor whiteColor];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    FSFilterCollectionViewCell * cell = (FSFilterCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.FilterNameLab.textColor = [UIColor grayColor];
}

#pragma mark originalImage
- (void)setOriginalImage:(UIImage *)originalImage{
    _originalImage = originalImage;
    UIGraphicsBeginImageContext(CGSizeMake(CellWei*2, (originalImage.size.height/(_originalImage.size.width/CellWei))*2));  //size 为CGSize类型，即你所需要的图片尺寸
    
    [_originalImage drawInRect:CGRectMake(0, 0, CellWei*2, (originalImage.size.height/(_originalImage.size.width/CellWei))*2)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.MainImage = scaledImage;
    
     [self randerFilterImage];
}
@end
