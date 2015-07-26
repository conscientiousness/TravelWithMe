//
//  WallViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/23.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "WallViewController.h"
#import "WallTableViewCell.h"
#import "HomePostViewController.h"
#import "HomeDetailViewController.h"
#import "UIColors.h"

@interface WallViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *wallTableView;


@end

@implementation WallViewController
{
    WallTableViewCell *wallTableViewCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self initUI];
    _wallTableView.scrollEnabled = YES;
    _wallTableView.delegate = self;
    _wallTableView.dataSource = self;
    
}



//初始化UI畫面
- (void)initUI {
        
    //關閉分隔線
    [_wallTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //設定背景色
    //[_homeTableView setBackgroundView:nil];
    //_wallTableView.backgroundColor = [UIColor homeCellbgColor];
    //透明度
    _wallTableView.opaque = NO;
        
    //Add post Button
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(postBtnPressed:)];
        
    self.navigationItem.rightBarButtonItem = postButton;
        
    //navigation bar color
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor navigationBarColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor navigationBarColor];
    self.navigationController.navigationBar.translucent = NO;
    
    //tab bar color
    //[self.tabBarController.tabBar setBackgroundColor:[UIColor tabBarColor]];
    self.tabBarController.tabBar.barTintColor = [UIColor tabBarColor];
    self.tabBarController.tabBar.translucent = NO;
}

    
    
- (void)postBtnPressed:(id *)sender {
        
        HomePostViewController *postVC = [self.storyboard instantiateViewControllerWithIdentifier:@"postViewController"];
        
        [self.navigationController pushViewController:postVC animated:YES];
        
        
        //[self presentViewController:postVC animated:YES completion:nil];
        //[self performSegueWithIdentifier:@"goPostView" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    wallTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"wallTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    //設定cell外觀
    [self setCellStyle:tableView];
    
    /*取出資料
     NSInteger targetIndex = indexPath.row;
     
     NSArray *allKeys = datas.allKeys;
     
     NSString *currentChinese = [allKeys objectAtIndex:targetIndex];
     
     vocDataCell.chineseLabel.text = currentChinese;
     vocDataCell.englishLabel.text = datas[currentChinese];
     */
    return wallTableViewCell;
}


- (void) setCellStyle:(UITableView *)tableView {
    
    //    homeTableViewCell.textLabel.backgroundColor = [UIColor clearColor];
    wallTableViewCell.contentView.backgroundColor =[UIColor homeCellbgColor];
    
    wallTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //設定邊框粗細
    [[wallTableViewCell.viewInTableViewCell layer] setBorderWidth:0];
    
    //邊框顏色
    //[[wallTableViewCell.viewInTableViewCell layer] setBorderColor:[UIColor colorWithRed:0.806 green:0.806 blue:0.806 alpha:1.0].CGColor];
    
    //將超出邊框的部份做遮罩
    //[[vocDataCell.vocDataCell layer] setMasksToBounds:YES];
    
    //設定背景顏色
    [[wallTableViewCell.viewInTableViewCell layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    
    //設定圓角程度
    [[wallTableViewCell.viewInTableViewCell layer] setCornerRadius:0];
    
    //照片圓形遮罩
    wallTableViewCell.headPhoto.layer.cornerRadius = wallTableViewCell.headPhoto.frame.size.width / 2;
    wallTableViewCell.headPhoto.layer.borderWidth = 3.0f;
    wallTableViewCell.headPhoto.layer.borderColor = [UIColor boyPhotoBorderColor].CGColor;
    wallTableViewCell.headPhoto.clipsToBounds = YES;
    
    //字體粗細大小
    wallTableViewCell.testAreaLabel.font = [UIFont systemFontOfSize:11];
    //文字顏色
    wallTableViewCell.testAreaLabel.textColor = [UIColor colorWithRed:0.373 green:0.710 blue:0.647 alpha:1.000];
    //背景色
    wallTableViewCell.testAreaLabel.backgroundColor = [UIColor clearColor];
    //Lable邊框
    wallTableViewCell.testAreaLabel.layer.borderColor = [UIColor colorWithRed:0.373 green:0.710 blue:0.647 alpha:1.000].CGColor;
    wallTableViewCell.testAreaLabel.layer.borderWidth = 0.5;
    wallTableViewCell.testAreaLabel.layer.cornerRadius = 3;
    //文字在Label置中
    wallTableViewCell.testAreaLabel.textAlignment = NSTextAlignmentCenter;
    //文字自動適應Lable大小
    wallTableViewCell.testAreaLabel.adjustsFontSizeToFitWidth = NO;
}


//當選擇某一列Cell要做的的動作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //跳轉到HomePostViewController
    HomePostViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    //傳值
    NSNumber *value = [NSNumber numberWithLong:indexPath.row];
    [detailVC setValue:value forKey:@"test"];
    
    //NSLog(@"hey");
    
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
