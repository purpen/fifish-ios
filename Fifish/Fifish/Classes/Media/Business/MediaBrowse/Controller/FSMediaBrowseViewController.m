//
//  FSMediaBrowseViewController.m
//  Fifish
//
//  Created by macpro on 16/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

//tools
#import "FSFileManager.h"
#import "FSUserModel.h"
#import <Photos/Photos.h>
//model
#import "FSImageModel.h"
#import "FSVideoModel.h"
//view
#import "FSAlertView.h"
#import "FSMediaBrowBottomEditView.h"
//vc
#import "FSImageEditViewController.h"
#import "FSLoginViewController.h"
#import "FSReleasePictureViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "FSMediaBrowseViewController.h"
#import "FSMediaBrowCollectionViewCell.h"

@interface FSMediaBrowseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,FSMediaBrowBottomEditViewDelegate,UIVideoEditorControllerDelegate,UINavigationControllerDelegate>
/**
 浏览器
 */
@property (nonatomic,strong)UICollectionView                        * BrowseCollectionView;

/**
 当前张数
 */
@property (nonatomic,strong)UILabel                                 * offsetLab;

/**
 编辑分享view
 */
@property (nonatomic,strong)FSMediaBrowBottomEditView              * editView;


@end

@implementation FSMediaBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}
- (void)NavBack{
    [super NavBack];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.BrowseCollectionView];
    [self.BrowseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(Nav_Height, 0, Nav_Height, 0));
    }];
    
    [self.view addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(@44);
    }];
    
    [self.view addSubview:self.offsetLab];
    [self.offsetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.editView.mas_centerX);
        make.bottom.mas_equalTo(self.editView.mas_top).offset(-30);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.BrowseCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.seletedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.offsetLab.text = [NSString stringWithFormat:@"%lu/%lu",self.seletedIndex+1,self.modelArr.count];
    });
    
    
}

- (UICollectionView *)BrowseCollectionView{
    if (!_BrowseCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _BrowseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _BrowseCollectionView.pagingEnabled = YES;
        _BrowseCollectionView.delegate = self;
        _BrowseCollectionView.dataSource = self;
        _BrowseCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        [_BrowseCollectionView registerClass:[FSMediaBrowCollectionViewCell class] forCellWithReuseIdentifier:BrowCellIden];
        
        
    }
    return _BrowseCollectionView;
}
- (UILabel *)offsetLab{
    if (!_offsetLab) {
        _offsetLab = [[UILabel alloc] init];
        _offsetLab.textColor = [UIColor whiteColor];
        _offsetLab.font = [UIFont systemFontOfSize:14];
    }
    return _offsetLab;
}
- (FSMediaBrowBottomEditView *)editView{
    if (!_editView) {
        _editView = [[FSMediaBrowBottomEditView alloc] init];
        _editView.delegate = self;
        return _editView;
    }
    return _editView;
}
#pragma mark UIcollectionviewdelegate

//个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArr.count;
}

//单元大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FSMediaBrowCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:BrowCellIden forIndexPath:indexPath];
    
    FSImageModel * model = self.modelArr[indexPath.row];
    
    cell.model = model;
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FSImageModel * model = self.modelArr[indexPath.row];
    if ([model isKindOfClass:[FSVideoModel class]]) {
        MPMoviePlayerViewController * mvPlayer =  [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:model.fileUrl]];
                [self.navigationController presentViewController:mvPlayer animated:YES completion:nil];
    }
}
- (void)finalizeCollectionViewUpdates{
    
}
#pragma mark ScrollviewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    self.seletedIndex = offset.x/SCREEN_WIDTH;
    self.offsetLab.text = [NSString stringWithFormat:@"%ld/%lu",self.seletedIndex+1,(unsigned long)self.modelArr.count];
}

/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark FSMediaBrowBottomEditViewDelegate
- (void)MediaBrowViewEditAndShare{
    NSLog(@"分享");
    FSUserModel *usermodel = [[FSUserModel findAll] lastObject];
    if (!usermodel.isLogin) {
        FSLoginViewController *vc = [[FSLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
       //登录了，可以进行后续操作
    FSMediaModel * model = self.modelArr[self.seletedIndex];
    if ([model isKindOfClass:[FSVideoModel class]]){
        //判断时长
        FSVideoModel * videoModel = (FSVideoModel*)model;
        NSInteger  duration =ceil(CMTimeGetSeconds(videoModel.videoAsset.duration));
        if (duration>0&&duration<=60){
            FSReleasePictureViewController * PictureViewVC = [[FSReleasePictureViewController alloc] init];
            PictureViewVC.mediaModel = model;
            PictureViewVC.type =@2;
            [self.navigationController pushViewController:PictureViewVC animated:YES];
        }
        
        else{
            [[FSAlertView alloc] showAlertView:self title:NSLocalizedString(@"Duration too long", nil) message:NSLocalizedString(@"Please control the Duration of time in 60 seconds", nil) canceltitle:NSLocalizedString(@"Cancel", nil) oktitle:NSLocalizedString(@"Confirm", nil) confirmBlock:^{
                UIVideoEditorController * editVc = [[UIVideoEditorController alloc] init];
                editVc.delegate = self;
                editVc.videoPath = model.fileUrl;
                
                [self presentViewController:editVc animated:YES completion:nil];
            } cancelBlock:^{
                
            }];
        
        }
        
    }
    else{
        FSImageEditViewController * imageEditVc = [[FSImageEditViewController alloc] init];
        imageEditVc.MainImageModel = (FSImageModel *)model;
        [self.navigationController pushViewController:imageEditVc animated:YES];
    }
    }
    
}
- (void)MediaBrowViewDelete{
    // 删除数据源
    @synchronized (self.modelArr) {
        if (!(self.seletedIndex<self.modelArr.count)) {
            return;
        }
        
        [[[FSAlertView alloc] init] showAlertView:self title:NSLocalizedString(@"Confirm delete?", nil) message:nil canceltitle:NSLocalizedString(@"Cancel", nil) oktitle:NSLocalizedString(@"Confirm", nil) confirmBlock:^{
            //取出将要删除的模型
            FSMediaModel * willDeleteModel = self.modelArr[self.seletedIndex];
            
            //判断是否删除源文件成功
            if ([[FSFileManager defaultManager] RemoveFilePath:willDeleteModel.fileUrl]) {
                [self.modelArr removeObjectAtIndex:self.seletedIndex];
                
                [self.BrowseCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.seletedIndex inSection:0]]];
                
                [self scrollViewDidEndScrollingAnimation:self.BrowseCollectionView];
            }
        } cancelBlock:^{
            
        }];
        
    }
    
}
#pragma mark UIVideoEditorControllerDelegate
- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor{
    [editor dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Canacel", nil)];
    
}
- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error{
    [editor dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath
{
    [SVProgressHUD showSuccessWithStatus:nil];
    //不存
//    [[FSFileManager defaultManager] SaveVideoWithFilePath:editedVideoPath];
    
    AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:editedVideoPath] options:nil];
    NSInteger  duration =ceil(CMTimeGetSeconds(asset.duration));
    if (duration>60) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ %ld %@",NSLocalizedString(@"Please control the duration of time in 60 seconds, when the length of", nil),(long)duration,NSLocalizedString(@"Seconds", nil)]];
        return;
    }
    
        FSReleasePictureViewController * PictureViewVC = [[FSReleasePictureViewController alloc] init];
        FSVideoModel * model = [[FSVideoModel alloc] initWithFilePath:editedVideoPath];
        PictureViewVC.mediaModel = model;
        PictureViewVC.type =@2;
        [self.navigationController pushViewController:PictureViewVC animated:YES];
    [editor dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",editedVideoPath);
    
}
@end
