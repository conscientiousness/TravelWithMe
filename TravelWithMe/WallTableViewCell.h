//
//  WallTableViewCell.h
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/23.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewInTableViewCell;
@property (weak, nonatomic) IBOutlet UIImageView *wallHeadPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellLeftLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellObjectId;
@property (weak, nonatomic) IBOutlet UILabel *cellUserObjectId;

@end
