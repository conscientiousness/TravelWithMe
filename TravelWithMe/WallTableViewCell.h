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
@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
@property (weak, nonatomic) IBOutlet UILabel *testAreaLabel;
@property (weak, nonatomic) IBOutlet UIView *viewBlock1;
@property (weak, nonatomic) IBOutlet UIView *viewBlock2;
@property (weak, nonatomic) IBOutlet UIView *viewBlock3;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *intoLabel;


@end
