//
//  FSHistoryView.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/30.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHistoryView.h"
#import "UIView+FSExtension.h"
#import "FSSearchModel.h"
#import "FSHistoryCollectionViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"

@interface FSHistoryView () <UICollectionViewDelegate, UICollectionViewDataSource>

/**  */
@property (nonatomic, strong) UICollectionView *historyCollectionView;
/**  */
@property (nonatomic, strong) NSArray *dataAry;

@end

@implementation FSHistoryView

-(UICollectionView *)historyCollectionView{
    if (!_historyCollectionView) {
        UICollectionViewLeftAlignedLayout *layOut = [[UICollectionViewLeftAlignedLayout alloc] init];
        layOut.minimumLineSpacing = 10;
        layOut.minimumInteritemSpacing = 5;
        layOut.sectionInset = UIEdgeInsetsMake(30, 10, 0, 10);
        _historyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height) collectionViewLayout:layOut];
        _historyCollectionView.showsHorizontalScrollIndicator = NO;
        _historyCollectionView.delegate = self;
        _historyCollectionView.dataSource = self;
        [_historyCollectionView registerNib:[UINib nibWithNibName:@"FSHistoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FSHistoryCollectionViewCell"];
        _historyCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }
    return _historyCollectionView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSSearchModel *model = self.dataAry[indexPath.row];
    CGSize size = [model.keyStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
    return CGSizeMake(size.width+40, 30);
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.historyCollectionView];
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.dataAry = [FSSearchModel findAll];
        [self.historyCollectionView reloadData];
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSHistoryCollectionViewCell" forIndexPath:indexPath];
    FSSearchModel *model = self.dataAry[indexPath.row];
    cell.keyStr.text = model.keyStr;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FSSearchModel *model = self.dataAry[indexPath.row];
    if ([self.hVDelegate respondsToSelector:@selector(beginSearch:)]) {
        [self.hVDelegate beginSearch:model.keyStr];
    }
}

@end
