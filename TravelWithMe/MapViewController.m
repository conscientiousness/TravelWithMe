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



@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *theMapView;
@property (nonatomic, strong) VBFPopFlatButton *mapFlatRoundedButton;
@end

@implementation MapViewController
{
   CLLocationManager*locationManager;
    BOOL isFirstLocationReceived;
    PFUser *user;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    locationManager = [CLLocationManager new];
    
    //Ask user's permission
    if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
        //requestWhenInUseAuthorization NSLocationWhenInUseUsageDescription
    }
    
    // Prepare locationManager
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType=CLActivityTypeAutomotiveNavigation;
    
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(initFlatRoundedButton)
                                                name:@"isDismiss"
                                              object:nil];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!user) {
        user = [PFUser currentUser];
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


- (IBAction)backClick:(UIButton *)sender {
    [self.theMapView setCenterCoordinate:self.theMapView.userLocation.coordinate animated:YES];
}

- (void) didSelectedType {
    
    [_mapFlatRoundedButton removeFromSuperview];
    
    UIViewController *targetViewController;
    UIStoryboard *storyboard;
    
    if(user) {
        
        targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"selectTypeViewController"];
        
        //[self presentViewController:targetViewController animated:NO completion:nil];
        
        //targetViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        //[self presentViewController:targetViewController animated:NO completion:nil];
        
        targetViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:targetViewController animated:NO completion:nil];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [self presentViewController:targetViewController animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Segmented切換
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

- (IBAction)backToWhite:(UIStoryboardSegue*)segue
{

}

- (IBAction)mapPostClick:(id)sender {
    
    //NSLog(@"current= %@",currentUser);
    UIViewController *targetViewController;
    UIStoryboard *storyboard;
    
    if(user) {
        
        targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"selectTypeViewController"];
        
        //[self presentViewController:targetViewController animated:NO completion:nil];
        
        //targetViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        //[self presentViewController:targetViewController animated:NO completion:nil];

        targetViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        //setModalTransitionStyle:UIModalTransitionStyleCrossDissolve
        //UIModalTransitionStyleCoverVertical
        //targetViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:targetViewController animated:YES completion:nil];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [self presentViewController:targetViewController animated:YES completion:nil];
    }
    
    //[self presentViewController:postVC animated:YES completion:nil];
    //[self performSegueWithIdentifier:@"goPostView" sender:nil];
    
}



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
