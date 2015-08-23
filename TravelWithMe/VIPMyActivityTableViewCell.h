//
//  VIPMyActivityTableViewCell.h
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/22.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPMyActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myActivityShareSmallPhoto;
@property (weak, nonatomic) IBOutlet UILabel *myActivityCountryCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *myActivityStartDate;
@property (weak, nonatomic) IBOutlet UILabel *myActivityMemo;

@end
