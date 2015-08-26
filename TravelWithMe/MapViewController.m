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
    CLLocationManager*locationManager;
    BOOL isFirstLocationReceived;
    PFUser *user;
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
                                            selector:@selector(initFlatRoundedButton)
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
}


#pragma mark - 初始化新增按鈕
- (void) initFlatRoundedButton {
    
    
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
    
    //NSLog(@"%@",[notification userInfo]);
    
    MapPostViewController *targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapPostViewController"];
    
    //所選類別在丟到MapPostViewController
    targetViewController.selectedtypeString = [notification userInfo][@"selectedType"];
    
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

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *currentLocation = locations.lastObject;
    
//  顯示小數點
//  NSLog(@"Current Location:%.6f,%.6f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
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

@end
