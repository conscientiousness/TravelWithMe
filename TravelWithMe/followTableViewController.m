//
//  followTableViewController.m
//  TravelWithMe
//
//  Created by ajay on 2015/8/11.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "followTableViewController.h"
#import "VIPMyActivityTableViewCell.h"


@interface followTableViewController ()
{
    PFUser *user;
}
@property (strong, nonatomic) IBOutlet UITableView *followTableView;
@end

@implementation followTableViewController
{
    NSMutableArray *arrayDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];

    if (!user) {
        user = [PFUser currentUser];
    }
    
    if([PFUser currentUser]==nil) {
        user = nil;
    }
    
    UIViewController *targetViewController;
    UIStoryboard *storyboard;
    if(!user)
    { //抓不到user權限，導向LOGIN畫面
        
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [self presentViewController:targetViewController animated:YES completion:nil];
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!user) {
        user = [PFUser currentUser];
    }
    
    if([PFUser currentUser]==nil) {
        user = nil;
    }
    
    dispatch_queue_t loadingQueue = dispatch_queue_create("loading", nil);
    dispatch_async(loadingQueue, ^{
        [self getTravelMatePostDatas];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });

}

- (void)initUI {
   [_followTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    return arrayDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier;
    NSString *nibName;
    UINib *nib;
    
    identifier = @"cell";
    nibName = @"VIPMyActivityTableViewCell";
    nib = [UINib nibWithNibName:nibName bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    
    VIPMyActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.myActivityCountryCityLabel.text = arrayDatas[indexPath.row][TRAVELMATEPOST_COUNTRYCITY_KEY];
    
    cell.myActivityStartDate.text = arrayDatas[indexPath.row][TRAVELMATEPOST_STARTDATE_KEY];
    
    cell.myActivityMemo.text = arrayDatas[indexPath.row][TRAVELMATEPOST_MEMO_KEY];
    
    PFFile *photo = (PFFile *)arrayDatas[indexPath.row][TRAVELMATEPOST_SMALLPHOTO_KEY];
    [cell.myActivityShareSmallPhoto sd_setImageWithURL:(NSURL*)photo.url placeholderImage:[UIImage imageNamed:@"intrested-icon"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 取得USER所有參加

- (void) getTravelMatePostDatas
{
    //userObjectId = @"fWcSONXdmc";
    
    PFRelation *relation = [user relationForKey:@"interestedPosts"];
    PFQuery *query = [relation query];
    [query orderByDescending:@"createdAt"];
    //query.limit = 3;
    
    //if(arrayDatas==nil)
    //arrayDatas = [NSMutableArray new];
    
    arrayDatas = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    
    //每次上拉查詢增加筆數
    //dataCount = [NSNumber numberWithInt:[dataCount intValue] + 3];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
