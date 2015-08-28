//
//  MapMKPointAnnotation.h
//  TravelWithMe
//
//  Created by Hank on 2015/8/25.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapMKPointAnnotation : MKPointAnnotation

// 加上兩種不同屬性property
@property (nonatomic,assign)NSString *selectedObjectId;
@property (nonatomic,strong)NSDictionary *extraInfo;

@end
