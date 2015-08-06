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



@end
