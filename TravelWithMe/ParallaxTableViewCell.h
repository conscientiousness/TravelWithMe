//
//  ParallaxTableViewCell.h
//  UITableView Parallax
//
//  Created by Hank on 2015/8/10.
//  Copyright (c) 2015年 Hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParallaxTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel*parallaxLabel;
@property (nonatomic,strong) IBOutlet UIImageView *parallaxImage;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

-(void) cellOnTableView:(UITableView*)tableView didScrollOnView:(UIView *)view;

@end
