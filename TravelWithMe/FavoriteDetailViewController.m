//
//  FavoriteDetailViewController.m
//  TravelWithMe
//
//  Created by ajay on 2015/8/6.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "FavoriteDetailViewController.h"

@interface FavoriteDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView *detailView;

@end

@implementation FavoriteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initUI {
    
    _detailView.backgroundColor = [UIColor homeCellbgColor];
    //透明度
    _detailView.opaque = NO;
    
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
