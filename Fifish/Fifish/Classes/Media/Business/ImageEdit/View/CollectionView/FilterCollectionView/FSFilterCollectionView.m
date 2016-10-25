//
//  FSFilterCollectionView.m
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFilterCollectionView.h"
#import "FSFilterCollectionViewCell.h"


@interface FSFilterCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

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
#pragma mark UIcollectionviewdelegate
//个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionNumber;
}
//单元大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 90);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSFilterCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:FilterCellIden forIndexPath:indexPath];
    cell.index = indexPath.row;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.FilterDelegate&&[self.FilterDelegate respondsToSelector:@selector(SeletedFilterWithIndex:)]) {
        [self.FilterDelegate SeletedFilterWithIndex:indexPath];
    }
}
@end
