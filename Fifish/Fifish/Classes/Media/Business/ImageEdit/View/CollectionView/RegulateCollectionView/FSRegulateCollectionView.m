//
//  FSRegulateCollectionView.m
//  Fifish
//
//  Created by macpro on 16/10/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRegulateCollectionView.h"
#import "FSRegulateCollectionviewCell.h"



static NSInteger const CellHeight = 90;


@interface FSRegulateCollectionView ()

@property (nonatomic,strong)NSArray * imageArr;
@property (nonatomic,strong)NSArray * titleArr;


@end

@interface FSRegulateCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation FSRegulateCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (layout) {
        self = [super initWithFrame:frame collectionViewLayout:layout];
    }
    else{
        UICollectionViewFlowLayout *flayout = [[UICollectionViewFlowLayout alloc] init];
        [flayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flayout.minimumLineSpacing = 0;
//        flayout.minimumInteritemSpacing = 20;
        self = [super initWithFrame:frame collectionViewLayout:flayout];
    }
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithHexString:@"262E35"];
        
        [self registerClass:[FSRegulateCollectionviewCell class] forCellWithReuseIdentifier:FSRegulatCellIden];
    }
    return self;
}

- (NSArray *)imageArr{
    if (!_imageArr) {
        _imageArr = @[@"light_icon",@"contrast_icon",@"saturation_icon",@"Sharpness_icon",@"ColorTemperature_icon"];
    }
    return _imageArr;
}
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"Light",@"Contrast",@"Saturation",@"Sharpness",@"ColorTemperature"];
    }
    return _titleArr;
}
#pragma mark UIcollectionviewdelegate
//个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArr.count;
}
//单元大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/self.titleArr.count, CellHeight);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSRegulateCollectionviewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:FSRegulatCellIden forIndexPath:indexPath];
    cell.iconImageview.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.titleLab.text = NSLocalizedString(self.titleArr[indexPath.row], nil);
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.FSRegulateDelegate&&[self.FSRegulateDelegate respondsToSelector:@selector(RegulateSeletedParameter:)]) {
        [self.FSRegulateDelegate RegulateSeletedParameter:indexPath];
    }
}
@end
