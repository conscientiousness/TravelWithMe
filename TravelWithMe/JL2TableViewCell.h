//
//  JL2TableViewCell.h
//  testCocoaPods
//
//  Created by Jesselin on 2015/7/14.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JL2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *secondSectionView;
@property (weak, nonatomic) IBOutlet UIImageView *memberImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *memberImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *memberImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *memberImageView4;
@property (weak, nonatomic) IBOutlet UIButton *moreMemberBtn;

@end
