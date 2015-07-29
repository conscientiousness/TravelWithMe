//
//  StoreViewController.m
//  TravelWithMe
//
//  Created by Hank on 2015/7/25.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "StoreViewController.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/tw/app/angry-birds/id343200656?mt=8"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
