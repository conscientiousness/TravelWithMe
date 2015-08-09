//
//  JL3MessageTableViewCell.h
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/8.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JL3MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *thirdSectionView;
@property (weak, nonatomic) IBOutlet UIImageView *messageUserPhoto;
@property (weak, nonatomic) IBOutlet UILabel *messageUserName;
@property (weak, nonatomic) IBOutlet UILabel *messageTime;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end
