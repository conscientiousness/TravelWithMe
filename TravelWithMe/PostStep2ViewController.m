//
//  PostStep2ViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/16.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "PostStep2ViewController.h"

@interface PostStep2ViewController ()

@end

@implementation PostStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    UIBarButtonItem *nextStepButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepBtnPressed:)];
    self.navigationItem.rightBarButtonItem = nextStepButton;
    
    
    self.view.backgroundColor = [UIColor homeCellbgColor];
}

- (void)nextStepBtnPressed:(id *)sender {
    
    UIViewController *targetViewController;
    
    targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"postStep3ViewController"];
    
    [self.navigationController pushViewController:targetViewController animated:YES];
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
