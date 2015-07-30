//
//  SettingTableViewControlle.m
//  TravelWithMe
//
//  Created by Hank on 2015/7/29.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "SettingTableViewControlle.h"
#import <MessageUI/MessageUI.h>
@interface SettingTableViewControlle ()<MFMailComposeViewControllerDelegate>

@end

@implementation SettingTableViewControlle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  打印
    //  NSLog(@"indexPath :%@",indexPath);
    if(indexPath.section == 2){
        if(indexPath.row == 1){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/tw/app/angry-birds/id343200656?mt=8"]];
        }
    }
    
    
    if(indexPath.section == 2){
        if(indexPath.row == 0){
            // 方法一
            /*NSString *to = @"TravelWithMe@gmail.com";
            NSString *subject = @"TravelWithMe_Questione";
            //        NSString *cc = @"TravelWithMe@gmail.com";
            //        NSString *bcc = @"TravelWithMe@gmail.com";
            NSString *mailStr = [NSString stringWithFormat:@"mailto:%@?subject=%@&", to, subject];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailStr]];*/
           
            // 方法二
            MFMailComposeViewController * mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
             [mailViewController setSubject:@"TravelWithMe_Questione"];
             [mailViewController setToRecipients:@[@"TravelWithMe@gmail.com"]];
             [self presentViewController:mailViewController animated:YES completion:^{
             }];
        }
        
        
        
        
    }
    
    
}
// 設定方法返回
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
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
