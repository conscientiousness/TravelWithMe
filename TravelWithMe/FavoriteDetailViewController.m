//
//  FavoriteDetailViewController.m
//  TravelWithMe
//
//  Created by ajay on 2015/7/29.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "FavoriteDetailViewController.h"
#import "UIColors.h"
@interface FavoriteDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView *inDetailViewTable;

@end

@implementation FavoriteDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];

    // Do any additional setup after loading the view.
}
//初始化UI畫面
- (void)initUI {
    
    //設定背景色
    _inDetailViewTable.backgroundColor = [UIColor homeCellbgColor];
    //透明度
    _inDetailViewTable.opaque = NO;
    
    //navigation bar color
    [self.navigationController.navigationBar setBackgroundColor:[UIColor navigationBarColor]];
    
    //tab bar color
    [self.tabBarController.tabBar setBackgroundColor:[UIColor tabBarColor]];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return 0;
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
