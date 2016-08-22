//
//  FSMediaViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMediaViewController.h"
#import "FSFileManager.h"
@interface FSMediaViewController ()
@end

@implementation FSMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    NSLog(@"%@",[[FSFileManager defaultManager] GetMp4FileArr]);
    // Do any additional setup after loading the view from its nib.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
