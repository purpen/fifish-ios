//
//  FSAddressViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSAddressViewController.h"
#import "FSSearchBar.h"
#import "FSLocationTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FSAddressViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

/**  */
@property (nonatomic, strong) FSSearchBar *searchBar;
/**  */
@property (nonatomic, strong) UITableView *myTableView;
/**  */
@property (nonatomic, strong) NSArray *locationAry;
/**  */
@property (nonatomic, strong) CLLocationManager *locMgr;
/**  */
@property (nonatomic, assign) BOOL flag;
/**  */
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation FSAddressViewController

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

-(CLLocationManager *)locMgr{
    if (!_locMgr) {
        _locMgr = [[CLLocationManager alloc] init];
        _locMgr.delegate = self;
        [_locMgr requestWhenInUseAuthorization];
    }
    return _locMgr;
}

-(FSSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[FSSearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) searchBarStyle:LGLSearchBarStyleDefault];
    }
    return _searchBar;
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) style:UITableViewStylePlain];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerNib:[UINib nibWithNibName:@"FSLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"FSLocationTableViewCell"];
    }
    return _myTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startLocation];
    
    [self.searchBar searchBarTextSearchTextBlock:^(NSString *searchText) {
        //请求附近地址
        
    }];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.myTableView];
}

-(void)startLocation{
    //  判断是否开启GPS定位
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"openGPS", nil)];
            _flag = NO;
        }else{
            [self.locMgr startUpdatingLocation];
            self.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            _flag = YES;
        }
        
    } else {
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *loc = [locations firstObject];
    NSLog(@"  %ld", locations.count);
    NSLog(@"纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
    [self.locMgr stopUpdatingLocation];
    //反向地理编码
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *placeMark in placemarks) {
            NSLog(@"地址  %@", placeMark.name);
        }
        self.locationAry = placemarks;
        [self.myTableView reloadData];
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败: %@", error);
}

-(void)dealloc{
    self.locMgr.delegate = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    if (_flag) {
        return;
    }
    NSString *mediaMessage = @"请在设置->隐私->定位服务 中打开本应用的访问权限并在返回后重新打开该页面";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:mediaMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.delegate = self;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.locationAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSLocationTableViewCell"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

@end
