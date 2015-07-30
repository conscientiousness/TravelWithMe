//

//  FavoriteTableViewController.m

//  TravelWithMe

//

//  Created by ajay on 2015/7/29.

//  Copyright (c) 2015年 Jesse. All rights reserved.

//



#import "FavoriteTableViewController.h"

#import "FavoriteTableViewCell.h"

#import "UIColors.h"

#import "FavoriteDetailViewController.h"



@interface FavoriteTableViewController ()



@end



@implementation FavoriteTableViewController

{
    
    
    
    NSMutableArray *dataArray;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
    
    dataArray = [[NSMutableArray alloc] init];
    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}



//初始化UI畫面

- (void)initUI {
    
    //設定背景色
    
    //self.backgroundColor = [UIColor homeCellbgColor];
    
    
    
    [self.tableView setBackgroundColor:[UIColor homeCellbgColor]];
     
     
     
     
     
     
     
     
     
     //navigation bar color
     
     [self.navigationController.navigationBar setBackgroundColor:[UIColor navigationBarColor]];
     
     
     
     //tab bar color
     
     [self.tabBarController.tabBar setBackgroundColor:[UIColor tabBarColor]];
     
     
     
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
         
         return 2;
         
     }
     
     
     
     - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
         
         
         
         
         
         FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favoriteTableViewCell" forIndexPath:indexPath];
         
         
         
         // Configure the cell...
         
         
         
         cell.textLabel.text = [NSString stringWithFormat:@"test"];
         
         
         
         
         
         return cell;
         
     }
     
     
     
     
     
     //當選擇某一列Cell要做的的動作
     
     - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
         
         
         
         FavoriteDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"favoriteDetailViewController"];
         
         [self.navigationController pushViewController:detailVC animated:YES];
         
         
         
         //傳值
         
         NSNumber *value = [NSNumber numberWithLong:indexPath.row];
         
         [detailVC setValue:value forKey:@"test"];
         
         
         
     }
     
     
     
    /*
     
     - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
     
     
     
     // Configure the cell...
     
     
     
     return cell;
     
     }
     
     */
     
     
     
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
     
     
     
    /*
     
     #pragma mark - Navigation
     
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     // Get the new view controller using [segue destinationViewController].
     
     // Pass the selected object to the new view controller.
     
     }
     
     */
     
     
     
     @end
     
