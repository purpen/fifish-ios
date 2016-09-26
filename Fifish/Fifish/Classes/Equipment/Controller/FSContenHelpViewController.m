//
//  FSContenHelpViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/9/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSContenHelpViewController.h"
#import "Masonry.h"

@interface FSContenHelpViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
/**  */
@property (nonatomic, strong) UIScrollView *myScrollView;
/**  */
@property (nonatomic, strong) NSArray *pictuerAry;
/**  */
@property (nonatomic, strong) NSArray *titleAry;

@end

@implementation FSContenHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 22;
    self.nextBtn.layer.borderWidth = 1;
    self.nextBtn.layer.borderColor = DEFAULT_COLOR.CGColor;
    [self.view addSubview:self.myScrollView];
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.view.mas_top).offset(80);
        make.bottom.mas_equalTo(self.tipLabel.mas_top).offset(-26);
    }];
    [self scrollViewDidScroll:self.myScrollView];
}

-(NSArray *)titleAry{
    if (!_titleAry) {
        _titleAry = [NSArray arrayWithObjects:@"1、打开Rov设备电源", @"2、打开中继设备电源", @"3、连接线缆", @"4、移动设备连接到中继设备的WiFi", nil];
    }
    return _titleAry;
}

-(NSArray *)pictuerAry{
    if (!_pictuerAry) {
        _pictuerAry = [NSArray arrayWithObjects:@"", @"", @"", @"", nil];
    }
    return _pictuerAry;
}

-(UIScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] init];
        _myScrollView.backgroundColor = [UIColor clearColor];
        _myScrollView.delegate = self;
        _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.pictuerAry.count, 0);
        _myScrollView.pagingEnabled = YES;
        _myScrollView.showsVerticalScrollIndicator = NO;
        _myScrollView.showsHorizontalScrollIndicator = NO;
        _myScrollView.alwaysBounceVertical = NO;
        _myScrollView.alwaysBounceHorizontal = NO;
        _myScrollView.bounces = NO;
    }
    return _myScrollView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x/SCREEN_WIDTH);
    self.myPageControl.currentPage = index;
    self.tipLabel.text = self.titleAry[index];
    if (index == self.titleAry.count - 1) {
        [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
}

-(void)setNavi{
    self.navigationItem.title = @"连接帮助";
}

- (IBAction)nextClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"下一步"]) {
        int index = fabs(self.myScrollView.contentOffset.x/SCREEN_WIDTH);
        [self.myScrollView setContentOffset:CGPointMake((index + 1) * SCREEN_WIDTH,0) animated:YES];
    } else if ([sender.titleLabel.text isEqualToString:@"完成"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
