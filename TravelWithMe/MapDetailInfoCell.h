//
//  MapDetailInfoCell.h
//  TravelWithMe
//
//  Created by Jesselin on 2015/9/2.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapDetailInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sharePhotoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeagoLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;

@end
