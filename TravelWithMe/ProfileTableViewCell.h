//
//  ProfileTableViewCell.h
//  TravelWithMe
//
//  Created by Jesselin on 2015/10/4.
//  Copyright © 2015年 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *displayNme;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *line;
@property (weak, nonatomic) IBOutlet UITextField *wechat;
@property (weak, nonatomic) IBOutlet UITextField *facebook;
@end
