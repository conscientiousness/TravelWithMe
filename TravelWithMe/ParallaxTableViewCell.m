//
//  ParallaxTableViewCell.m
//  UITableView Parallax
//
//  Created by Hank on 2015/8/10.
//  Copyright (c) 2015年 Hank. All rights reserved.
//

#import "ParallaxTableViewCell.h"

@implementation ParallaxTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view
{
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter=CGRectGetHeight(view.frame)/3 -CGRectGetMinY(rectInSuperview);
    float difference =CGRectGetHeight(self.parallaxImage.frame)-CGRectGetHeight(self.frame);
    float move=(distanceFromCenter /CGRectGetHeight(view.frame)) *difference;
    
    CGRect imageRect = self.parallaxImage.frame;
    imageRect.origin.y=-(difference/2)+move;
    self.parallaxImage.frame=imageRect;

}

@end
