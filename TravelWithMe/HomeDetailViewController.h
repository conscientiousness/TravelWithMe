//
//  HomeDetailViewController.h
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/10.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPBFloatingTextViewController.h"

@interface HomeDetailViewController : JPBFloatingTextViewController

@property (nonatomic,strong) NSDictionary *cellDictData;
@property (nonatomic,strong) NSArray *cellArrayData;

@end
