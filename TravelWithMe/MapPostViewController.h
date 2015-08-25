//
//  mapPostViewController.h
//  TravelWithMe
//
//  Created by ajay on 2015/8/10.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendStatusBack)(BOOL isSave);

@interface MapPostViewController : UIViewController
@property (nonatomic,strong) SendStatusBack block;
@end
