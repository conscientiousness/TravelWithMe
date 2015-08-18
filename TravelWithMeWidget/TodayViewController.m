//
//  TodayViewController.m
//  TravelWithMeWidget
//
//  Created by Hank on 2015/8/17.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    //[self TravelWithMeBtnPressed:nil];
    completionHandler(NCUpdateResultNewData);
}

- (IBAction)TravelWithMeBtnPressed:(id)sender {
    
    NSURL *url=[NSURL URLWithString:@"TravelWithMe://abc"];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        //NSLog(@"openURL Done.");
    }];
}

@end
