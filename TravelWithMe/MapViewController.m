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
#import "MapMKPointAnnotation.h"
#import "SelectTypeViewController.h"
#import "DPAnnotationView.h"
#import "DateTools.h"


@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
   CLLocationManager *locationManager;
   BOOL isFirstLocationReceived;
   PFUser *user;
   NSMutableDictionary *passDataDict;
   CLLocation *currentLocation;
   NSMutableArray *arrayDatas;
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
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
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
}


#pragma mark - 子畫面Dismiss
- (void) didTopChildDismiss {
    
    if(!user){
        user = [PFUser currentUser];
    }
    
    [self initFlatRoundedButton];
    
    if(passDataDict==nil)
        passDataDict = [NSMutableDictionary new];
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
    [passDataDict setValue:[notification userInfo][MAPPOST_TYPE_KEY] forKey:MAPPOST_TYPE_KEY];
    [passDataDict setValue:[NSNumber numberWithDouble:currentLocation.coordinate.latitude] forKey:MAPPOST_LATITUDE_KEY];
    [passDataDict setValue:[NSNumber numberWithDouble:currentLocation.coordinate.longitude] forKey:MAPPOST_LONGITUDE_KEY];
    
    MapPostViewController *targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapPostViewController"];
    
    targetViewController.dictDatas = passDataDict;
    
    //釋放
    passDataDict = nil;
    
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

#pragma mark - 點選縮放功能view
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



#pragma mark - CLLocationManager Delegate Methoods
//取得所在位置
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    currentLocation = locations.lastObject;
    
    //顯示小數點
    //NSLog(@"Current Location:%.8f,%.8f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    //取得USER位置後，依設定置中USER縮放地圖
    if(isFirstLocationReceived == false)
    {
        MKCoordinateRegion region = _theMapView.region;
        region.center =currentLocation.coordinate;
        region.span.latitudeDelta=0.01;
        region.span.longitudeDelta=0.01;
        
        [_theMapView setRegion:region animated:true];
        
        isFirstLocationReceived =true;
       
       MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       hud.labelText = @"Loading...";
       
       dispatch_queue_t publishQueue = dispatch_queue_create("qry", nil);
       
       dispatch_async(publishQueue, ^{
          
          [self getdata];
          
          dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             CLLocationCoordinate2D coordicate;
             
             for(PFObject *data in arrayDatas){
                
                //float randomNum = (float)(arc4random()%9)/1000;
                
                //設定大頭針位置
                coordicate.latitude = ((PFGeoPoint*)data[MAPPOST_USERLOCATION_KEY]).latitude;//+randomNum;
                coordicate.longitude = ((PFGeoPoint*)data[MAPPOST_USERLOCATION_KEY]).longitude;//+randomNum;
                
                
                MapMKPointAnnotation *annotation =[MapMKPointAnnotation new];
                
                annotation.extraInfo = @{
                //分類
                MAPPOST_TYPE_KEY:data[MAPPOST_TYPE_KEY]
                //照片
                ,MAPPOST_SMALLPHOTO_KEY:data[MAPPOST_SMALLPHOTO_KEY]
                };
                
                //位置
                annotation.coordinate = coordicate;
                //標題：名字
                annotation.title = data[COMMON_POINTER_CREATEUSER_KEY][USER_DISPLAYNAME_KEY];
                //副標題：發文時間
                NSDate *timeAgoDate = data.createdAt;
                annotation.subtitle=timeAgoDate.timeAgoSinceNow;
                //po文ID
                annotation.selectedObjectId = data.objectId;
                
                [_theMapView addAnnotation:annotation];
             }
          });
       });
       
      
    }
}

-(MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
   
   // 藍點我的位置
   if (annotation == mapView.userLocation)
      return nil;
   
   MapMKPointAnnotation *myAnnotion = annotation;
   NSDictionary *extraInfo = myAnnotion.extraInfo;
   
   // 產生大頭針
   /*MKPinAnnotationView *resultView = (MKPinAnnotationView*)
    [mapView dequeueReusableAnnotationViewWithIdentifier:@""];
    if(resultView == nil)
    {
    resultView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Store"];
    }*/
   
   
   // 自訂大頭針圖片
   MKAnnotationView *resultView = (MKAnnotationView*)
   [mapView dequeueReusableAnnotationViewWithIdentifier:@"Store"];
   
   if(resultView == nil)
   {
      resultView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Store"];
   }
   
   else resultView.annotation =annotation;
   
   resultView.canShowCallout=true; // 大頭針顯示框框
   // resultView.animatesDrop =true; // 大頭針動畫效果
   // resultView.pinColor = MKPinAnnotationColorGreen; //大頭針顏色 只有三種顏色 紅綠紫 自訂畫面不支援
   
   // Use image as annotationView 自訂圖標 (圖測試用 建議大小25*25)
   resultView.image = [UIImage imageNamed:@"map-green-pin.png"];
   
   
   // Add Left Callout Accessory View 大頭針點下去放圖片
   UIImage *leftImage = [UIImage imageNamed:@"intrested-icon.png"];
   resultView.leftCalloutAccessoryView =[[UIImageView alloc]
                                         initWithImage:leftImage];
   
   PFFile *PFPhoto = (PFFile*)extraInfo[MAPPOST_SMALLPHOTO_KEY];
   [PFPhoto getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
      if (!error) {
         UIImage *leftImage = [UIImage imageWithData:imageData];
         resultView.leftCalloutAccessoryView =[[UIImageView alloc]
                                               initWithImage:leftImage];
      }
   }];
   
   //NSLog(@"%f,%f",resultView.frame.size.height,resultView.frame.size.width);
   
   // Add Right Callout Accessory View 跳轉至PO文畫面
   UIButton *rightButton =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
   [rightButton addTarget:self
                   action:@selector(buttonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
   resultView.rightCalloutAccessoryView=rightButton;

   
   return resultView;
}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
 
   if(view.annotation == mapView.userLocation) return;
   
   //MapMKPointAnnotation *myAnnotion = (MapMKPointAnnotation*)view.annotation;
   //NSDictionary *extraInfo = myAnnotion.extraInfo;
   //NSLog(@"extraInfo:%@,dataIndex:%@",extraInfo.description,myAnnotion.selectedObjectId);
}

// 模擬點下大頭針的方法 可跳轉至PO文畫面
-(void) buttonPressed:(id)sender{
   
   NSLog(@"extraInfo:%@",[sender superview]);
   
   UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"目前沒有資訊" preferredStyle:UIAlertControllerStyleAlert];
   UIAlertAction *ok =[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
   
   [alert addAction:ok];
   [self presentViewController:alert animated:YES completion:nil];
   
}

#pragma mark - Load Parse Data

- (void) getdata
{

   PFQuery *query = [PFQuery queryWithClassName:MAPPOST_TABLENAME];
   [query includeKey:@"createUser.User"];
   
   arrayDatas = [NSMutableArray new];
   [arrayDatas addObjectsFromArray:[query findObjects]];
}


@end
