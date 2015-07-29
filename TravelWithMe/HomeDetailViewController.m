//
//  HomeDetailViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/10.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "UIColors.h"
#import "JLTableViewCell.h"
#import "JL2TableViewCell.h"

@interface HomeDetailViewController ()

@end

@implementation HomeDetailViewController
{
    JLTableViewCell *JLTableViewCell;
    JL2TableViewCell *JL2TableViewCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //設定Navigation bar為透明
    self.navigationController.navigationBar.translucent = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setHeaderImage:[UIImage imageNamed:@"pic900X640.jpg"]];
    [self setTitleText:@"日本"];
    [self setSubtitleText:@"Japan"];
    [self setLabelBackgroundGradientColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f]];
    //[self setInteractionsDelegate:self];
    
    CGFloat headerHeight = [self headerHeight];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, headerHeight - 55, 44, 44)];
    [button setTitle:@"按鈕" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(alert:) forControlEvents:UIControlEventTouchUpInside];
    [self addHeaderOverlayView:button];
    
    //關閉分隔線
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

- (void)alert:(UIButton*)sender{
    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You can even add buttons to the header!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@":)", nil] show];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 10;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"JLCell";
    NSString *nibName = @"JLTableViewCell";
    
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
        identifier = @"JL2Cell";
        nibName = @"JL2TableViewCell";
    }
    
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    JLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        //設定cell外觀
        
        //設定邊框粗細
        [[cell.firstSectionView layer] setBorderWidth:1.5];
        
        //邊框顏色
        [[cell.firstSectionView layer] setBorderColor:[UIColor colorWithRed:0.806 green:0.806 blue:0.806 alpha:1.0].CGColor];
        
        //設定背景顏色
        [[cell.firstSectionView layer] setBackgroundColor:[UIColor colorWithRed:0.984 green:0.984 blue:0.984 alpha:1.0].CGColor];
        
        //設定圓角程度
        [[cell.firstSectionView layer] setCornerRadius:10.0];
        
        //照片圓形遮罩
        cell.headPhoto.layer.cornerRadius = cell.headPhoto.frame.size.width / 2;
        cell.headPhoto.layer.borderWidth = 2.0f;
        cell.headPhoto.layer.borderColor = [UIColor grayColor].CGColor;
        cell.headPhoto.clipsToBounds = YES;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat result;
    
    if(indexPath.section == 0){
        result = 200.0f;
    }else{
        result = 44.0f;
    }
    
    return result;
}

- (CGFloat)horizontalOffset{
    return 50.0f;
}

- (void)didTapHeaderImageView:(UIImageView *)imageView
{
    NSLog(@"The header imageview was tapped: %@", imageView.description);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
