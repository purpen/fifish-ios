//
//  FSMediaViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "Masonry.h"
#import "FSConst.h"

#import "FSMediaViewController.h"

#import "FSlocalMediaViewController.h"

#import "MWPhotoBrowser.h"

#import "FSFileManager.h"
@interface FSMediaViewController ()<UIImagePickerControllerDelegate,UINavigationBarDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * ViewControllerScrowView;

@end

@implementation FSMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChileVC];
    [self setUpUI];
    self.navigationController.navigationBar.hidden = YES;
    // 默认显示第0个子控制器
    [self scrollViewDidEndScrollingAnimation:self.ViewControllerScrowView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSLog(@"%@",[[FSFileManager defaultManager] GetMp4FileArr]);
    for (NSString * str  in [[FSFileManager defaultManager] GetMp4FileArr]) {
        [[FSFileManager defaultManager] RemoveFilePath:str];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpUI{
    //添加视图scrowll
    [self.view addSubview:self.ViewControllerScrowView];
    [self.ViewControllerScrowView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(Nav_Height,0, Tab_Height, 0));
    }];
    
}

- (UIScrollView *)ViewControllerScrowView{
    if (!_ViewControllerScrowView) {
        _ViewControllerScrowView = [[UIScrollView alloc] init];
        _ViewControllerScrowView.backgroundColor = [UIColor grayColor];
        _ViewControllerScrowView.delegate = self;
        _ViewControllerScrowView.pagingEnabled = YES;
        _ViewControllerScrowView.contentSize = CGSizeMake(self.childViewControllers.count*SCREEN_WIDTH, 0);
    }
    return _ViewControllerScrowView;
}


- (void)addChileVC{
    
    FSlocalMediaViewController * locaMediaVc = [[FSlocalMediaViewController alloc] init];
    [self addChildViewController:locaMediaVc];
    
    FSlocalMediaViewController * RovMediaVc = [[FSlocalMediaViewController alloc] init];
    [self addChildViewController:RovMediaVc];
    
}





#pragma mark ScrollviewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    
//    [self.segementControl setSelectedSegmentIndex:index animated:YES];
    
    // 取出需要显示的控制器
    UIViewController * willShowVc = self.childViewControllers[index];
    
    
    // 如果当前位置的位置已经显示过了，就直接返回
//    if ([willShowVc isViewLoaded])
//    {
//        [willShowVc viewWillAppear:YES];
//        return;
//    }
    
    // 添加控制器的view到contentScrollView中;
        willShowVc.view.frame = CGRectMake(offsetX, 0, width, height);
//    NSLog(@"%@",willShowVc.view);
    [scrollView addSubview:willShowVc.view];
    
}

/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
@end
