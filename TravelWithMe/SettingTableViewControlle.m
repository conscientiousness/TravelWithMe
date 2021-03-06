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
{
    PFUser *user;
}

@property (weak, nonatomic) IBOutlet UITableViewCell *loginCell;

@end


@implementation SettingTableViewControlle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor homeCellbgColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // FB 判斷
    self.tabBarController.tabBar.hidden = NO;
    
    if(!user){
        user = [PFUser currentUser];
    }
    
    if([PFUser currentUser]==nil) {
        user = nil;
        _loginCell.textLabel.text = @"登入";
    }
    else{
        _loginCell.textLabel.text = @"登出";
    }
    [[PFUser currentUser] fetchIfNeededInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *targetViewController;
    UIStoryboard *storyboard;
    // 我的頁面
    if(indexPath.section == 0){
    if(indexPath.row == 0){
        
        //[FBSDKAccessToken currentAccessToken]
        // 判斷是否已經登入若無跳轉登入若有顯示我的頁面
        if(user) {
            targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VIPViewController"];
            
            [self.navigationController pushViewController:targetViewController animated:YES];
        }
        else {
            storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            
            [self presentViewController:targetViewController animated:YES completion:nil];
        }
    
    }
    else if(indexPath.row == 1){
        
        
        if(user) {
            storyboard = [UIStoryboard storyboardWithName:@"Favorite" bundle:nil];
            
            targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"favoriteMainVC"];
            
            [self.navigationController pushViewController:targetViewController animated:YES];
        }
        else {
            storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            
            [self presentViewController:targetViewController animated:YES completion:nil];
        }
        
    }
}
    
    // NSLog(@"indexPath :%@",indexPath);
    // 待上架後開啟
    /*if(indexPath.section == 1){
     if(indexPath.row == 3){
     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"網址"]];
     }
     }*/
    
    // 意見回饋及問題回報
    if(indexPath.section == 1){
        if(indexPath.row == 0){
     
            MFMailComposeViewController * mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            [mailViewController setSubject:@"TravelwithMe_Q"];
            [mailViewController setToRecipients:@[@"travelwithme.tw@gmail.com"]];
            [self presentViewController:mailViewController animated:YES completion:^{
            }];
        }
    }
    
    // 登出x登入
    if(indexPath.section == 2){
        if(indexPath.row == 0){
  
            if(user){
                [PFUser logOut];
                user=nil;
                _loginCell.textLabel.text = @"登入";
            }else{
                
                storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
                
                [self presentViewController:targetViewController animated:YES completion:nil];
            }

        }
    }
}


// 設定mail方法返回
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//- (IBAction)backBtnPressed:(id)sender {
//    [self dismissViewControllerAnimated:true completion:^{
//        NSLog(@"backBtnPressed");
//    }];
//}
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
