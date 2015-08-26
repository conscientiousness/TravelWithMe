//
//  MapViewController.h
//  TravelWithMe
//
//  Created by Hank on 2015/7/29.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendDictToMapPost)(NSDictionary* dict);

@interface MapViewController : UIViewController
@property (nonatomic,strong) SendDictToMapPost block;
@end
