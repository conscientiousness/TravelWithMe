//
//  MapViewController.m
//  TravelWithMe
//
//  Created by Hank on 2015/7/29.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "VBFPopFlatButton.h"
#import "MapPostViewController.h"
#import "SelectTypeViewController.h"


@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstLocationReceived;
    PFUser *user;
    NSMutableDictionary *passDataDict;
    CLLocation *currentLocation;
    CLGeocoder *gecorder;
}
@property (weak, nonatomic) IBOutlet UIView *AnimationsView;
@property (weak, nonatomic) IBOutlet MKMapView *theMapView;
@property (nonatomic, strong) VBFPopFlatButton *mapFlatRoundedButton;
@end

@implementation MapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    locationManager = [CLLocationManager new];
    
    //Ask user's permission 詢問使用者
    
    if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    
    // Prepare locationManager
    // 定位需求 10公尺 Wifi
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    // 定位等級 行走
    locationManager.activityType=CLActivityTypeFitness;
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didTopChildDismiss)
                                                name:TOP_CHILD_DISMISSED_NOTIFICATION
                                              object:nil];
    

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(presentToMapPost:)
                                                name:PRESENT_TO_MAPPOSTVIEW_NOTIFICATION
                                              object:nil];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // FB登入
    if(!user){
        user = [PFUser currentUser];
    }
    if([PFUser currentUser]==nil) {
        user = nil;
    }
    [self initFlatRoundedButton];
    
    if(passDataDict==nil)
        passDataDict = [NSMutableDictionary new];
    
    if(gecorder==nil)
        gecorder=[CLGeocoder new];
}


#pragma mark - 子畫面Dismiss
- (void) didTopChildDismiss {
    [self initFlatRoundedButton];
}

- (void) initFlatRoundedButton {
    
    //重創建動態ADD按鈕
    self.mapFlatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(MAP_FLAT_BTN_CGRECTMAKE)
                                                            buttonType:buttonAddType
                                                           buttonStyle:buttonRoundedStyle
                                                 animateToInitialState:YES];
    self.mapFlatRoundedButton.roundBackgroundColor = [UIColor customGreenColor];
    self.mapFlatRoundedButton.lineThickness = 3;
    self.mapFlatRoundedButton.tintColor = [UIColor whiteColor];
    [self.mapFlatRoundedButton addTarget:self
                                  action:@selector(didSelectedType)
                        forControlEvents:UIControlEventTouchUpInside];
    [_theMapView addSubview:self.mapFlatRoundedButton];
}

#pragma mark - 當類別按鈕按下，present到PO文畫面
- (void) presentToMapPost:(NSNotification*)notification {
    
    //prepare passing value
    [passDataDict setValue:[NSNumber numberWithDouble:currentLocation.coordinate.latitude] forKey:MAPVIEW_LATITUDE_DICT_KEY];
    [passDataDict setValue:[NSNumber numberWithDouble:currentLocation.coordinate.longitude] forKey:MAPVIEW_LONGITUDE_DICT_KEY];
    [passDataDict setValue:[notification userInfo][@"selectedType"] forKey:MAPVIEW_SELECTEDTYPE_DICT_KEY];

    //丟字典給PO文畫面
    //self.block(passDataDict);
    
    MapPostViewController *targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapPostViewController"];
    
    targetViewController.dictDatas = passDataDict;
    
    //以覆蓋方式在原本VC上面(注意:dismiss時,不會觸發viewWillAppear等)
    targetViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:targetViewController animated:YES completion:nil];
}

#pragma mark - 按下新增按鈕，present到類別按鈕畫面
- (void) didSelectedType {

    //移除按鈕，當返回時在init才有按鈕特效
    [_mapFlatRoundedButton removeFromSuperview];
    
    UIViewController *targetViewController;
    UIStoryboard *storyboard;
    
    if(user) {
        
        targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"selectTypeViewController"];
        
        //[self presentViewController:targetViewController animated:NO completion:nil];
        
        //targetViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        //[self presentViewController:targetViewController animated:NO completion:nil];
        
        targetViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        //self.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:targetViewController animated:NO completion:nil];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [self presentViewController:targetViewController animated:YES completion:nil];
    }
    
}

#pragma mark - 回到User所在位置
- (IBAction)backClick:(UIButton *)sender {
    [self.theMapView setCenterCoordinate:self.theMapView.userLocation.coordinate animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Segmented 地圖顯示方式切換
- (IBAction)mapTypeChanged:(id)sender {
    NSInteger targetIndex = [sender selectedSegmentIndex];
    
    switch (targetIndex) {
        case 0:
            _theMapView.mapType =MKMapTypeStandard;
            break;
        case 1:
            _theMapView.mapType =MKMapTypeSatellite;
            break;
        case 2:
            _theMapView.mapType =MKMapTypeHybrid;
            break;
            
    }
}

// Segmented 無＆追蹤＆方向切換
- (IBAction)userTrackingModeChanged:(UISegmentedControl*)sender {
    
    NSInteger targetIndex = [sender selectedSegmentIndex];
    
    switch (targetIndex) {
        case 0:
            _theMapView.userTrackingMode =MKUserTrackingModeNone;
            break;
        case 1:
            _theMapView.userTrackingMode =MKUserTrackingModeFollow;
            break;
        case 2:
            _theMapView.userTrackingMode =MKUserTrackingModeFollowWithHeading;
            break;
    }
}


- (IBAction)SmartCompassBtnPressed:(id)sender {
    
    // CATransition
    CATransition *transition = [CATransition animation];
    transition.duration=0.5; //動畫時間
    transition.timingFunction = [CAMediaTimingFunction
                                 functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //動畫效果
    
    if(_AnimationsView.isHidden)
    {
        _AnimationsView.hidden = NO;
        transition.subtype = kCATransitionFromBottom; //動畫出現方向
    }
    else
    {
        _AnimationsView.hidden = YES;
        transition.subtype =kCATransitionFromTop; //動畫退出方向
    }
    [_AnimationsView.layer addAnimation:transition forKey:nil];
}

//- (IBAction)mapPostClick:(id)sender {
//    
//    //NSLog(@"current= %@",currentUser);
//    UIViewController *targetViewController;
//    UIStoryboard *storyboard;
//    
//    if(user) {
//        
//        targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"selectTypeViewController"];
//        
//        //[self presentViewController:targetViewController animated:NO completion:nil];
//        
//        //targetViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        //[self presentViewController:targetViewController animated:NO completion:nil];
//
//        targetViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        //setModalTransitionStyle:UIModalTransitionStyleCrossDissolve
//        //UIModalTransitionStyleCoverVertical
//        //targetViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        [self presentViewController:targetViewController animated:YES completion:nil];
//        
//    } else {
//        
//        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        
//        targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
//        
//        [self presentViewController:targetViewController animated:YES completion:nil];
//    }
//    
//    //[self presentViewController:postVC animated:YES completion:nil];
//    //[self performSegueWithIdentifier:@"goPostView" sender:nil];
//    
//}
//
//

#pragma mark - CLLocationManager Delegate Methoods
//取得所在位置
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    currentLocation = locations.lastObject;
    
    //顯示小數點
    //NSLog(@"Current Location:%.8f,%.8f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    if(isFirstLocationReceived == false)
    {
        MKCoordinateRegion region = _theMapView.region;
        region.center =currentLocation.coordinate;
        region.span.latitudeDelta=0.01;
        region.span.longitudeDelta=0.01;
        
        [_theMapView setRegion:region animated:true];
        
        isFirstLocationReceived =true;
    }
}

//#pragma mark - 反查地點
//-(void)getGeoCoderPlacemarks{
//    
//    //NSMutableArray *placeAry = [NSMutableArray new];
//    
//    //CLLocation *location =[[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
//    
//    [gecorder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks,NSError *error){
//        
//        //NSLog(@"Result:%@",placemarks.description);
//        CLPlacemark *placemark = placemarks[0];
//        
//        //
//        //NSLog(@"1:%@,2:%@,3:%@,4:%@,5:%@",placemark.country,placemark.location,placemark.administrativeArea,placemark.thoroughfare,placemark.subThoroughfare);
//        
//        //[placeAry addObjectsFromArray:placemarks];
//        
//        //country  administrativeArea  locality 國家 縣市 鄉鎮區市
//        
//        [passDataDict setValue:placemark.country forKey:MAPVIEW_COUNTRY_DICT_KEY];
//        [passDataDict setValue:placemark.administrativeArea forKey:MAPVIEW_CITY_DICT_KEY];
//        [passDataDict setValue:placemark.locality forKey:MAPVIEW_LOCALITY_DICT_KEY];
//    }];
//
//}

@end
