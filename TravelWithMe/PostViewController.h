//
//  PostViewController.h
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/17.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SendDataBack)(BOOL needReload);

@interface PostViewController : UIViewController
@property (nonatomic,strong) SendDataBack SendDataBackBlock;
@end
