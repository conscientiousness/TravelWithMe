//
//  JLTableViewCell.m
//  testCocoaPods
//
//  Created by Jesselin on 2015/7/12.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "JLTableViewCell.h"

@implementation JLTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)joinBtnPressed:(id)sender {
    NSLog(@"inin");
}

@end
