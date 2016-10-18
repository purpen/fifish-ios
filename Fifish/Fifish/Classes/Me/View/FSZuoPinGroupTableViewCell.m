//
//  FSZuoPinGroupTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/18.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSZuoPinGroupTableViewCell.h"
#import "FSStuffCollectionViewCell.h"
#import "Masonry.h"
#import "FSHomeDetailViewController.h"

@interface FSZuoPinGroupTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *myCollectionView;

@end

@implementation FSZuoPinGroupTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.myCollectionView];
        [_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
        }]; 
    }
    return self;
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        _myCollectionView.scrollEnabled = NO;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerNib:[UINib nibWithNibName:@"FSStuffCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FSStuffCollectionViewCell"];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _myCollectionView;
}

-(void)setGroupAry:(NSArray *)groupAry{
    _groupAry = groupAry;
    [self.myCollectionView reloadData];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.myCollectionView];
    [_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.groupAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSStuffCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSStuffCollectionViewCell" forIndexPath:indexPath];
    FSZuoPin *model = self.groupAry[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 5 * 2) / 3, (SCREEN_WIDTH - 5 * 2) / 3);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    vc.model = self.groupAry[indexPath.row];
    vc.title = @"作品详情";
    [self.navc pushViewController:vc animated:YES];
}

@end
