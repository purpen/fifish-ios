//
//  FSImageBrowserVC.m
//  Fifish
//
//  Created by THN-Dong on 2016/12/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageBrowserVC.h"
#import "UIImage+Helper.h"
#import "UIView+FSExtension.h"
#import "FSImageBrowserFlowLayout.h"
#import "FSImageBrowserCell.h"
#import "FSImageItem.h"
#import "SDWebImageManager.h"

#define kPageControlHeight 40.0f
#define kCellIdentifier @"FSImageBrowserCellIdentifier"

@interface FSImageBrowserVC ()

<UICollectionViewDelegate,
UICollectionViewDataSource,
FSImageItemProtocol,
FSImageItemProtocol>

@property (nonatomic, strong) UIImageView *blurImageView;
@property (nonatomic, strong) UIImage *blurImage;
@property (nonatomic, assign, getter=isFirstShow) BOOL firstShow;
@property(nonatomic,copy) NSArray *imageModels;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIImage *screenshot;
@property (nonatomic, strong) UIImageView *screenshotImageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FSImageBrowserFlowLayout *flowLayout;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) FSImageItem *currentImageItem;

@end

@implementation FSImageBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.blurImageView];
    [self.view addSubview:self.screenshotImageView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];
    [self.collectionView setContentOffset:
     CGPointMake(self.currentIndex * KImageBrowserWidth,0.0f)
                                 animated:NO];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.blurImageView.frame = [UIScreen mainScreen].bounds;
    self.screenshotImageView.frame = [UIScreen mainScreen].bounds;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.screenshotImageView.alpha = 0.0f;
                     }completion:^(BOOL finished) {
                     }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self _setCurrentItem];
    self.firstShow = NO;
}

-(void)_setCurrentItem{
    NSArray *cells = [self.collectionView visibleCells];
    if (cells.count != 0) {
        FSImageBrowserCell *cell = [cells objectAtIndex:0];
        if (self.currentImageItem != cell.imageItem) {
            self.currentImageItem = cell.imageItem;
            [self _perDownLoadImageWithIndex:self.currentIndex];
        }
    }
}

-(void)_perDownLoadImageWithIndex:(NSInteger)index{
    SDWebImageManager* manager = [SDWebImageManager sharedManager];
    if (index + 1 < self.imageModels.count) {
        FSImageBrowserModel* nextModel = [self.imageModels objectAtIndex:index + 1];
        [manager downloadImageWithURL:nextModel.HDURL
                              options:0
                             progress:nil
                            completed:^(UIImage *image,
                                        NSError *error,
                                        SDImageCacheType cacheType,
                                        BOOL finished,
                                        NSURL *imageURL) {}];
    }
    if (index - 1 >= 0) {
        FSImageBrowserModel* previousModel = [self.imageModels objectAtIndex:index - 1];
        [manager downloadImageWithURL:previousModel.HDURL
                              options:0
                             progress:nil
                            completed:^(UIImage *image,
                                        NSError *error,
                                        SDImageCacheType cacheType,
                                        BOOL finished,
                                        NSURL *imageURL) {}];
    }
}

-(void)show{
    [self.parentVC presentViewController:self animated:NO completion:^{}];
}

-(void)_hide{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    __weak typeof(self) weakSelf = self;
    if (self.currentImageItem.zoomScale != 1.0f) {
        self.currentImageItem.zoomScale = 1.0f;
    }
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakSelf.screenshotImageView.alpha = 1.0f;
                         if (weakSelf.isScalingToHide) {
                             weakSelf.currentImageItem.imageView.frame = weakSelf.currentImageItem.imageModel.originPosition;
                         }
                         else {
                             weakSelf.currentImageItem.imageView.alpha = 0.0f;
                         }
                     } completion:^(BOOL finished) {
                        [weakSelf dismissViewControllerAnimated:NO
                                                     completion:^{
                                                         weakSelf.imageModels = nil;
                                                     }];
                     }];
}

-(void)setIsShowPageControl:(BOOL)isShowPageControl{
    _isShowPageControl = isShowPageControl;
    self.pageControl.hidden = !isShowPageControl;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]
                        initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kPageControlHeight - 10.0f, SCREEN_WIDTH, kPageControlHeight)];
        _pageControl.numberOfPages = self.imageModels.count;
        _pageControl.currentPage = self.currentIndex;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(0,
                                                    0,
                                                    KImageBrowserWidth,
                                                    self.view.height)
                           collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[FSImageBrowserCell class]
            forCellWithReuseIdentifier:kCellIdentifier];
    }
    return _collectionView;
}

-(FSImageBrowserFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[FSImageBrowserFlowLayout alloc] init];
    }
    return _flowLayout;
}

-(UIImageView *)screenshotImageView{
    if (!_screenshotImageView) {
        _screenshotImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _screenshotImageView.image = self.screenshot;
    }
    return _screenshotImageView;
}

-(UIImageView *)blurImageView{
    if (_blurImageView) {
        return _blurImageView;
    }
    _blurImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _blurImageView.image = self.blurImage;
    return _blurImageView;
}

-(instancetype)initWithImageBrowserModels:(NSArray *)imageModels
                             currentIndex:(NSInteger)index{
    self = [super init];
    if (self) {
        self.firstShow = YES;
        self.isScalingToHide = YES;
//        self.parentVC = [self _getParentVC];
        self.imageModels = imageModels;
        self.currentIndex = index;
        self.screenshot = [self _screenshotFromView:KEY_WINDOW];
        self.blurImage = [self.screenshot applyBlurWithRadius:20 tintColor:[UIColor colorWithWhite:0 alpha:0.5] saturationDeltaFactor:1.4 maskImage:nil];
    }
    return self;
}

-(UIImage *)_screenshotFromView:(UIView *)aView{
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, NO, [UIScreen mainScreen].scale);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshotImage;
}

//-(UIViewController *)_getParentVC{
//    UIViewController *result = nil;
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    
//    if (window.windowLevel != UIWindowLevelNormal) {
//        NSArray *windows = [UIApplication sharedApplication].windows;
//        for (UIWindow *tmpWin in windows) {
//            if (tmpWin.windowLevel == UIWindowLevelNormal) {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    
//    id nextResponder = nil;
//    UIViewController *appRootVC = window.rootViewController;
//    if (appRootVC.presentationController) {
//        
//        nextResponder = appRootVC.presentationController;
//        
//    }else{
//    
//        UIView *frontView = [window subviews][0];
//        nextResponder = [frontView nextResponder];
//    
//    }
//    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
//        
//        UITabBarController *tabbar = (UITabBarController *)nextResponder;
//        UINavigationController *nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
//        result = nav.childViewControllers.lastObject;
//        
//    } else {
//    
//        result = nextResponder;
//    
//    }
//    return result;
//}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageModels.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier
                                                                         forIndexPath:indexPath];
    cell.imageItem.firstShow = self.isFirstShow;
    cell.imageModel = [self.imageModels objectAtIndex:indexPath.row];
    cell.imageItem.eventDelegate = self;
    return cell;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger index = offset / SCREEN_WIDTH;
    self.currentIndex = index;
    self.pageControl.currentPage = self.currentIndex;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self _setCurrentItem];
}

#pragma mark - FSImageItemDelegate
-(void)didClickedItemToHide{
    [self _hide];
}

@end
