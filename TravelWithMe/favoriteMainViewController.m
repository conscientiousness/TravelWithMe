//
//  favoriteMainViewController.m
//  TravelWithMe
//
//  Created by ajay on 2015/8/11.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "favoriteMainViewController.h"
#import "UIColors.h"
@interface favoriteMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *favoriteView;
@property (weak, nonatomic) IBOutlet UIView *followView;
@end

@implementation favoriteMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn:(UISegmentedControl*)sender {
    
    NSInteger targetIndex = sender.selectedSegmentIndex;
    switch (targetIndex) {
        case 0:
            self.favoriteView.hidden= YES;
            self.followView.hidden= NO;
            NSLog(@"1");
            break;
            
        case 1:
            self.favoriteView.hidden= NO;
            self.followView.hidden= YES;
            
            NSLog(@"2");
            break;
    }
    
    
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
