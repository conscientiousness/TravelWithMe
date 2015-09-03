//
//  MapDetailViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/31.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "MapDetailViewController.h"
#import "MapDetailInfoCell.h"
#import "DateTools.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapDetailViewController()<UITableViewDelegate, UITableViewDataSource>
{
    PFObject *dataObject;
}
@property (weak, nonatomic) IBOutlet UIButton *comeHereButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *mapDetailTableView;
@end

@implementation MapDetailViewController

//-(void) viewDidLoad {
//    [super viewDidLoad];
//    
//    
//    //blur效果
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//    blurView.frame = self.view.bounds;
//    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view insertSubview:blurView belowSubview:_infoView];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"讀取中...";
    
    dispatch_queue_t loadingQueue = dispatch_queue_create("mapDetailLoading", nil);
    dispatch_async(loadingQueue, ^{
        [self getData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mapDetailTableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    self.view.layer.cornerRadius = 8.f;
    self.view.backgroundColor = [UIColor whiteColor];
    //[self addDismissButton];
    
}

#pragma mark - Private Instance methods

//- (void)addDismissButton
//{
//    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
//    dismissButton.tintColor = [UIColor customGreenColor];
//    dismissButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
//    [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
//    [dismissButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:dismissButton];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dismissButton
//                                                          attribute:NSLayoutAttributeCenterX
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeCenterX
//                                                         multiplier:1.f
//                                                           constant:0.f]];
//    
//    [self.view addConstraints:[NSLayoutConstraint
//                               constraintsWithVisualFormat:@"V:[dismissButton]-|"
//                               options:0
//                               metrics:nil
//                               views:NSDictionaryOfVariableBindings(dismissButton)]];
//}
//
//- (void)dismiss:(id)sender
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (IBAction)backBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)comeHereBtnPressed:(id)sender {
    [self launchMaps];
}

#pragma mark - Table View Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if(datas == nil) {
    //        datas = [NSMutableDictionary new];
    //    }
    
    NSString *identifier;
    
    if (indexPath.row == 0) {
        identifier = @"cell1";
    }
    
    if (indexPath.row == 0) {
        MapDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //類別icon
        [cell.typeImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-icon",dataObject[MAPPOST_TYPE_KEY]]]];
        
        //地點
        cell.locationLabel.text = [NSString stringWithFormat:@"%@,%@",dataObject[MAPPOST_COUNTRY_KEY],dataObject[MAPPOST_LOCALITY_KEY]];
        
        //分享照片
        //[cell.sharePhotoImageView setImage:[UIImage imageWithData:[(PFFile*)dataObject[MAPPOST_PHOTO_KEY] getData]]];
        //大頭照
        [cell.sharePhotoImageView sd_setImageWithURL:(NSURL*)((PFFile*)dataObject[MAPPOST_PHOTO_KEY]).url placeholderImage:[UIImage imageNamed:@"tmp-loading-image"]];
        
        //大頭照
        [cell.headPhotoImageView sd_setImageWithURL:(NSURL*)((PFFile*)dataObject[COMMON_POINTER_CREATEUSER_KEY][USER_PROFILEPICTUREMEDIUM_KEY]).url placeholderImage:[UIImage imageNamed:@"tmp-head-icon"]];
        
        //po文者姓名
        cell.displayNameLabel.text = dataObject[COMMON_POINTER_CREATEUSER_KEY][USER_DISPLAYNAME_KEY];
        
        //PO文時間
        NSDate *timeAgoDate = ((PFObject*)dataObject).createdAt;
        cell.timeagoLabel.text = timeAgoDate.timeAgoSinceNow;
        
        
        cell.memoLabel.numberOfLines = 0;
        cell.memoLabel.text = dataObject[MAPPOST_MEMO_KEY];
        
        return cell;
        
    }
    
    
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGFloat result;
//    
//    result = 100.0;
//}

- (void) launchMaps{
    
    //[self.theMapView setCenterCoordinate:self.theMapView.userLocation.coordinate animated:YES];

    
    // Decide Source MapItem
    CLLocationCoordinate2D sourceCoordinate = CLLocationCoordinate2DMake(((MKUserLocation*)_crrrentUserCoordinate).coordinate.latitude, ((MKUserLocation*)_crrrentUserCoordinate).coordinate.longitude);
    MKPlacemark *sourcePlace = [[MKPlacemark alloc] initWithCoordinate:sourceCoordinate
                                                     addressDictionary:nil];
    
    MKMapItem *sourceMapItem = [[MKMapItem alloc]initWithPlacemark:sourcePlace];
    
    
    // Decide Target MapItem
    CLLocationCoordinate2D targetCoordinate = CLLocationCoordinate2DMake([dataObject[MAPPOST_LATITUDE_KEY] doubleValue], [dataObject[MAPPOST_LONGITUDE_KEY] doubleValue]);
    
    MKPlacemark *targetPlace = [[MKPlacemark alloc] initWithCoordinate:targetCoordinate
                                                     addressDictionary:nil];
    
    MKMapItem *targetMapItem = [[MKMapItem alloc]initWithPlacemark:targetPlace];
    
    
    // Directions Options
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving
                              };
    
    [MKMapItem openMapsWithItems:@[sourceMapItem,targetMapItem]
                   launchOptions:options];
}



- (void) getData {
    
    dataObject = [PFObject objectWithoutDataWithClassName:MAPPOST_TABLENAME objectId:_mapPostObjectId];
}

@end
