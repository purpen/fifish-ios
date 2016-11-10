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
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface FSAddressViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, AMapSearchDelegate>

/**  */
@property (nonatomic, strong) FSSearchBar *searchBar;
/**  */
@property (nonatomic, strong) UITableView *myTableView;
/**  */
@property (nonatomic, strong) NSArray *locationAry;
/**  */
@property (nonatomic, strong) AMapLocationManager *locationManager;
/**  */
@property (nonatomic, assign) BOOL flag;
/**  */
@property (nonatomic, strong) CLGeocoder *geocoder;
/**  */
@property (nonatomic, strong)  AMapSearchAPI *search;
/**  */
@property (nonatomic, assign) BOOL isInChina;

@end

@implementation FSAddressViewController

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


/**
 *得到本机现在用的语言
 * en-CN 或en  英文  zh-Hans-CN或zh-Hans  简体中文   zh-Hant-CN或zh-Hant  繁体中文    ja-CN或ja  日本  ......
 */
- (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

-(AMapSearchAPI *)search{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        NSString *lang = [self getPreferredLanguage];
        if ([lang rangeOfString:@"en"].location != NSNotFound) {
            _search.language = AMapSearchLanguageEn;
        } else {
            _search.language = AMapSearchLanguageZhCN;
        }
    }
    return _search;
}

-(AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _locationManager.locationTimeout = 2;
        _locationManager.reGeocodeTimeout = 2;
    }
    return _locationManager;
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
        [SVProgressHUD show];
        if (self.isInChina) {
            AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
            
            request.keywords            = searchText;
            request.requireExtension    = YES;
            
            /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
            request.cityLimit           = YES;
            request.requireSubPOIs      = YES;
            [self.search AMapPOIKeywordsSearch:request];
        } else {
            
        }
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
            [SVProgressHUD show];
            [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                if (error)
                {
                    NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
                    
                    if (error.code == AMapLocationErrorLocateFailed)
                    {
                        return;
                    }
                }
                if ((location.coordinate.latitude >= 4 && location.coordinate.latitude <= 53) && (location.coordinate.longitude >= 73 && location.coordinate.longitude <= 135)) {
                    [self searchPOIWithCoordinate:location.coordinate];
                    self.isInChina = YES;
                } else {
                    self.isInChina = NO;
                    [self appleMap:location.coordinate :NSLocalizedString(@"attractions", nil)];
                }
            }];
            _flag = YES;
        }
        
    } else {
        
    }
}

-(void)appleMap:(CLLocationCoordinate2D)coor :(NSString *)key{
    //创建一个位置信息对象，第一个参数为经纬度，第二个为纬度检索范围，单位为米，第三个为经度检索范围，单位为米
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coor, 500, 500);
    
    //初始化一个检索请求对象
    
    MKLocalSearchRequest * req = [[MKLocalSearchRequest alloc]init];
    
    //设置检索参数
    
    req.region=region;
    
    //兴趣点关键字
    
    req.naturalLanguageQuery = key;
    
    //初始化检索
    
    MKLocalSearch * ser = [[MKLocalSearch alloc]initWithRequest:req];
    
    //开始检索，结果返回在block中
    
    [ser startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        //兴趣点节点数组
        
        NSArray * array = [NSArray arrayWithArray:response.mapItems];
        self.locationAry = array;
        [self.myTableView reloadData];
        [SVProgressHUD dismiss];
    }];
}

/*  POI 搜索.  */
-  (void)searchPOIWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    //构造POI搜索对象
    AMapPOIAroundSearchRequest  *place = [[AMapPOIAroundSearchRequest alloc] init];
    
    //设置关键字
    place.keywords = NSLocalizedString(@"attractions", nil);
    place.requireExtension = YES;//设置成YES，返回信息详细，较费流量
    place.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    place.sortrule = 0;
    //发起查询
    [self.search  AMapPOIAroundSearch:place];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    self.locationAry = response.pois;
    [self.myTableView reloadData];
    [SVProgressHUD dismiss];
}


-(void)viewDidAppear:(BOOL)animated{
    if (_flag) {
        return;
    }
    NSString *mediaMessage = @"请在设置->隐私->定位服务 中打开本应用的访问权限并在返回后重新打开该页面";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", nil) message:mediaMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"determine", nil) otherButtonTitles:NSLocalizedString(@"cancel", nil), nil];
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
    if (self.isInChina) {
        AMapPOI *obj = self.locationAry[indexPath.row];
        cell.locationNameLabel.text = obj.name;
        cell.locationLabel.text = obj.address;
    } else {
        MKMapItem *item = self.locationAry[indexPath.row];
        cell.locationNameLabel.text = item.name;
        cell.locationLabel.text = @"";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isInChina) {
        AMapPOI *obj = self.locationAry[indexPath.row];
        if ([self.addressDelegate respondsToSelector:@selector(getAddress:andLat:andLon:)]) {
            [self.addressDelegate getAddress:obj.name andLat:obj.location.latitude andLon:obj.location.longitude];
        }
    } else {
        MKMapItem *item = self.locationAry[indexPath.row];
        if ([self.addressDelegate respondsToSelector:@selector(getAddress:)]) {
            [self.addressDelegate getAddress:item.name andLat:item.placemark.location.coordinate.latitude andLon:item.placemark.location.coordinate.longitude];
        }
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
