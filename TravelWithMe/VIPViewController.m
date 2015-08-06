//
//  VIPViewController.m
//  TravelWithMe
//
//  Created by Hank on 2015/7/25.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "VIPViewController.h"

@interface VIPViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;

@end

@implementation VIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //大頭照圓形遮罩
    _theImageView.layer.cornerRadius =_theImageView.frame.size.width / 2;
    _theImageView.layer.borderWidth = 2.0f;
    _theImageView.layer.borderColor = [UIColor boyPhotoBorderColor].CGColor;
    _theImageView.clipsToBounds = YES;
    

    
    
    
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
