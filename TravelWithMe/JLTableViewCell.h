//
//  JLTableViewCell.h
//  testCocoaPods
//
//  Created by Jesselin on 2015/7/12.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
@property (weak, nonatomic) IBOutlet UIView *firstSectionView;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *postStatus;
@property (weak, nonatomic) IBOutlet UILabel *travelDate;
@property (weak, nonatomic) IBOutlet UILabel *memo;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UIButton *interestedBtn;
@property (weak, nonatomic) IBOutlet UIButton *whoJoinBtn;
@property (weak, nonatomic) IBOutlet UILabel *interestedLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UILabel *days;

@end
