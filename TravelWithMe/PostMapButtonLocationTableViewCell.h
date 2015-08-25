//
//  PostMapButtonLocationTableViewCell.h
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/25.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostMapButtonLocationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *mapPostCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *mapPostSendBtn;
@property (weak, nonatomic) IBOutlet UILabel *mapPostUserLocationLabel;

@end
