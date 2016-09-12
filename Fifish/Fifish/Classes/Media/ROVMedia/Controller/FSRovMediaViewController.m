//
//  FSRovMediaViewController.m
//  Fifish
//
//  Created by macpro on 16/9/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRovMediaViewController.h"
#import "FSCameraManager.h"
@interface FSRovMediaViewController ()

@end

@implementation FSRovMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FSCameraManager * cameramanager = [[FSCameraManager alloc] init];
    [cameramanager RovGetSDCardInfoSuccess:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
    } WithFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
