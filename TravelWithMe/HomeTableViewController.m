//
//  HomeTableViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/8.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeTableViewCell.h"
#import "HomePostViewController.h"
#import "HomeDetailViewController.h"
#import "UIColors.h"
//#import <Parse/Parse.h>

@interface HomeTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *homeTableView;

@end

@implementation HomeTableViewController
{
    HomeTableViewCell *homeTableViewCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

//初始化UI畫面
- (void)initUI {
    
    //關閉分隔線
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //設定背景色
    //[_homeTableView setBackgroundView:nil];
    _homeTableView.backgroundColor = [UIColor homeCellbgColor];
    //透明度
    _homeTableView.opaque = NO;
    
    //Add post Button
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(postBtnPressed:)];
    
    self.navigationItem.rightBarButtonItem = postButton;
    
    //navigation bar color
    [self.navigationController.navigationBar setBackgroundColor:[UIColor navigationBarColor]];
    
    //tab bar color
    [self.tabBarController.tabBar setBackgroundColor:[UIColor tabBarColor]];
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
    
    homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"homeTableViewCell" forIndexPath:indexPath];
    
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
    return homeTableViewCell;
}


- (void) setCellStyle:(UITableView *)tableView {
    
//    homeTableViewCell.textLabel.backgroundColor = [UIColor clearColor];
    homeTableViewCell.contentView.backgroundColor =[UIColor homeCellbgColor];
    
    //設定點選編輯時背景色一致
//    UIView *backgrdView = [[UIView alloc] initWithFrame:homeTableViewCell.frame];
//    backgrdView.backgroundColor = [UIColor darkGrayColor];
//    homeTableViewCell.backgroundView = backgrdView;
    
    homeTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //設定邊框粗細
    [[homeTableViewCell.viewInTableViewCell layer] setBorderWidth:1.5];
    
    //邊框顏色
    [[homeTableViewCell.viewInTableViewCell layer] setBorderColor:[UIColor colorWithRed:0.806 green:0.806 blue:0.806 alpha:1.0].CGColor];
    
    //將超出邊框的部份做遮罩
    //[[vocDataCell.vocDataCell layer] setMasksToBounds:YES];
    
    //設定背景顏色
    [[homeTableViewCell.viewInTableViewCell layer] setBackgroundColor:[UIColor colorWithRed:0.984 green:0.984 blue:0.984 alpha:1.0].CGColor];
    
    //設定圓角程度
    [[homeTableViewCell.viewInTableViewCell layer] setCornerRadius:10.0];
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
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}


@end
