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
#import "MJRefresh.h"
//#import "JDFPeekabooCoordinator.h"


@interface WallViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *wallTableView;
//@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;
//@property (nonatomic) CGFloat previousScrollViewYOffset;
@end

@implementation WallViewController
{
    PFUser *user;
    CGRect originNavFrame;
    NSMutableArray *arrayDatas;
    NSDateFormatter *cellDateFormatter;
    NSNumber *dataCount;
    NSNumber *currentCount;
    NSDateFormatter *formatter;
    NSString *lastUpdated;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //originNavFrame = self.navigationController.navigationBar.frame;
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"讀取中...";
    
    dispatch_queue_t loadingQueue = dispatch_queue_create("loading", nil);
    dispatch_async(loadingQueue, ^{
        [self getdata];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_wallTableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    
   
    //NSLog(@"get2 = %ld", arrayDatas.count);
    
    [self initUI];
    _wallTableView.scrollEnabled = YES;
    _wallTableView.delegate = self;
    _wallTableView.dataSource = self;
    
    //self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
    
    //下拉刷最新
    UIRefreshControl *refresh = [UIRefreshControl new];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"準備更新資料"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [refresh setBackgroundColor:[UIColor homeCellbgColor]];
    [self.wallTableView addSubview:refresh];
    
    //上拉刷更多資料
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //設置顯示文字
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"Loading..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"以下沒資料了唷" forState:MJRefreshStateNoMoreData];

    footer.stateLabel.font = [UIFont systemFontOfSize:16];
    footer.stateLabel.textColor = [UIColor grayColor];
    _wallTableView.footer = footer;
    
    //格式化日期
    cellDateFormatter = [[NSDateFormatter alloc]init];
    [cellDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //NSLog(@"%f",self.view.frame.size.width);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!user) {
        user = [PFUser currentUser];
    }
    // nav tabbar 滾動縮放
    //self.scrollCoordinator.scrollView = _wallTableView;
    //self.scrollCoordinator.topView = self.navigationController.navigationBar;
    //self.scrollCoordinator.bottomView = self.tabBarController.tabBar;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[self.navigationController.navigationBar setFrame:originNavFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initUI {
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = [UIColor homeCellbgColor];
    //關閉分隔線
    [_wallTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //設定背景色
    _wallTableView.backgroundColor = [UIColor homeCellbgColor];
    //透明度
    _wallTableView.opaque = NO;
        
    //Add post Button
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(postBtnPressed:)];
    
    self.navigationItem.rightBarButtonItem = postButton;
        
    //navigation bar color
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor navigationBarColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor navigationBarColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    //originNavY = self.navigationController.navigationBar.frame.origin.y;
    
    //tab bar color
    //[self.tabBarController.tabBar setBackgroundColor:[UIColor tabBarColor]];
    self.tabBarController.tabBar.barTintColor = [UIColor tabBarColor];
    self.tabBarController.tabBar.translucent = YES;
    self.tabBarController.view.backgroundColor = [UIColor homeCellbgColor];
    self.tabBarController.tabBar.layer.borderWidth = 0.5;
    self.tabBarController.tabBar.layer.borderColor = self.tabBarController.tabBar.barTintColor.CGColor;
    self.tabBarController.tabBar.clipsToBounds = YES;

}

#pragma mark - Pull Refresh Method

- (void)refreshView:(UIRefreshControl*)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新中..."];
    
    formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM/dd,a h:mm "];
    lastUpdated = [NSString stringWithFormat:@"最後更新時間: %@",[formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    dispatch_queue_t loadNewDataQueue = dispatch_queue_create("loadNewData", nil);
    dispatch_async(loadNewDataQueue, ^{
        [self getNewData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_wallTableView reloadData];
            [refresh endRefreshing];
        });
    });
    
    
}

- (void)loadMoreData
{
    
    if(currentCount==nil){
        currentCount = [[NSNumber alloc] initWithInteger:arrayDatas.count];
    } else {
        currentCount = [NSNumber numberWithInteger:arrayDatas.count];
    }
    
    dispatch_queue_t loadMoreDataQueue = dispatch_queue_create("loadMoreData", nil);
    dispatch_async(loadMoreDataQueue, ^{
        [self getdata];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_wallTableView reloadData];
            
            if([currentCount integerValue] == arrayDatas.count){//筆數相等表示沒資料
                [_wallTableView.footer noticeNoMoreData];
            } else {
                [_wallTableView.footer endRefreshing];
            }
            
        });
    });
}

#pragma mark - Navigation Bar Item Method
- (void)postBtnPressed:(id *)sender {
    
    //NSLog(@"current= %@",currentUser);
    UIViewController *targetViewController;
    UIStoryboard *storyboard;
    
    //[FBSDKAccessToken currentAccessToken]
    
    if(user) {
        // postTableViewController
        targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"postViewController"];
        
        [self.navigationController pushViewController:targetViewController animated:YES];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [self presentViewController:targetViewController animated:YES completion:nil];
    }
 
    //[self presentViewController:postVC animated:YES completion:nil];
    //[self performSegueWithIdentifier:@"goPostView" sender:nil];
}



#pragma mark - Table View Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return arrayDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"height=>%f",self.view.frame.size.width);
    
    float result = 500.0;
    
    if(self.view.frame.size.width<=320.0) {//5s
        result -= 50.0;
    } else if (self.view.frame.size.width<=375.0) { //6
        result -= 5.0;
    }
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier =@"wallTableViewCell";
    
    UITableViewCell *cell = [self prepareTableViewCell:tableView cellForRowAtIndexPath:indexPath cellIdentifier:identifier];
    [self setCellData:(WallTableViewCell *)cell cellForRowAtIndexPath:indexPath];
    

    return cell;
}

//當選擇某一列Cell要做的的動作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //跳轉到HomePostViewController
    NSString *identifier = @"detailMessageViewController";
    
    HomePostViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
    //傳值
    NSDictionary *dictData = [NSDictionary new];
    dictData = @{
                 //貼文者姓名displayName
                 USER_DISPLAYNAME_KEY:arrayDatas[indexPath.row][COMMON_POINTER_CREATEUSER_KEY][USER_DISPLAYNAME_KEY],
                 
                 //大頭照profilePictureMedium
                 USER_PROFILEPICTUREMEDIUM_KEY:arrayDatas[indexPath.row][COMMON_POINTER_CREATEUSER_KEY][USER_PROFILEPICTUREMEDIUM_KEY],
                 
                 //城市地區countryCity
                 TRAVELMATEPOST_COUNTRYCITY_KEY:arrayDatas[indexPath.row][TRAVELMATEPOST_COUNTRYCITY_KEY],
                 
                 //照片photo
                 TRAVELMATEPOST_PHOTO_KEY:arrayDatas[indexPath.row][TRAVELMATEPOST_PHOTO_KEY],
                 
                 //詳細說明memo
                 TRAVELMATEPOST_MEMO_KEY:arrayDatas[indexPath.row][TRAVELMATEPOST_MEMO_KEY],
                 
                 //出發日期startDate
                 TRAVELMATEPOST_STARTDATE_KEY:arrayDatas[indexPath.row][TRAVELMATEPOST_STARTDATE_KEY],
                 
                 //旅遊天數days
                 TRAVELMATEPOST_DAYS_KEY:arrayDatas[indexPath.row][TRAVELMATEPOST_DAYS_KEY],
                 
                 //view寬度
                 @"tableViewWidth":@(self.view.frame.size.width),
                 
                 //此篇貼文objectId
                 @"objectId":((PFObject *)arrayDatas[indexPath.row]).objectId,
                 
                 //貼文者USER的objectId
                 @"userObjectId":((PFObject *)arrayDatas[indexPath.row][@"createUser"]).objectId
                 };
    
    [detailVC setValue:dictData forKey:@"cellDictData"];
}


#pragma mark - 給予 Cell 資料

- (void) setCellData:(WallTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSArray *cuser = [[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"createUser"];
    
    //NSLog(@"objectId= %@",((PFObject *)arrayDatas[indexPath.row][@"createUser"]).objectId);
    
    //名字
    cell.userNameLabel.text = arrayDatas[indexPath.row][COMMON_POINTER_CREATEUSER_KEY][USER_DISPLAYNAME_KEY];
    
    //大頭照
    //PFFile *proFilePicture = [[[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"createUser"] objectForKey:@"profilePictureMedium"];
    
    //[user objectForKey:kPAPUserProfilePicSmallKey];
    [cell.wallHeadPhoto sd_setImageWithURL:(NSURL*)((PFFile*)arrayDatas[indexPath.row][COMMON_POINTER_CREATEUSER_KEY][USER_PROFILEPICTUREMEDIUM_KEY]).url placeholderImage:[UIImage imageNamed:@"pic1.jpg"]];
        
    //國家城市
    cell.countryCityLabel.text = [[arrayDatas objectAtIndex:indexPath.row] objectForKey:TRAVELMATEPOST_COUNTRYCITY_KEY];
    
    //出發日期
    //NSString *strDate = [cellDateFormatter stringFromDate:[[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"startDate"]];
    cell.travelDateLabel.text = [[arrayDatas objectAtIndex:indexPath.row] objectForKey:TRAVELMATEPOST_STARTDATE_KEY];
    
    //旅遊天數
    NSNumber *days = [[arrayDatas objectAtIndex:indexPath.row] objectForKey:TRAVELMATEPOST_DAYS_KEY];
    cell.daysLabel.text = [days stringValue];
    
    //備註
    cell.memoLabel.text = [[arrayDatas objectAtIndex:indexPath.row] objectForKey:TRAVELMATEPOST_MEMO_KEY];
    
    //照片
    PFFile *photo = (PFFile *)[[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"photo"];
    [cell.cellImageView sd_setImageWithURL:(NSURL*)photo.url placeholderImage:[UIImage imageNamed:@"tmp900X640.png"]];
    
 
    //NSLog(@"%ld => %@",indexPath.row,[[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"createUser"]);
}

#pragma mark - 設定 Cell UI

- (UITableViewCell *)prepareTableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString *)identifier{
    
        WallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
        //====Set Cell Style====
        cell.contentView.backgroundColor =[UIColor homeCellbgColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //設定邊框粗細
        [[cell.viewInTableViewCell layer] setBorderWidth:0];
        
        //邊框顏色
        //[[wallTableViewCell.viewInTableViewCell layer] setBorderColor:[UIColor colorWithRed:0.806 green:0.806 blue:0.806 alpha:1.0].CGColor];
        
        //將超出邊框的部份做遮罩
        //[[vocDataCell.vocDataCell layer] setMasksToBounds:YES];
        
        //設定背景顏色
        [[cell.viewInTableViewCell layer] setBackgroundColor:[UIColor whiteColor].CGColor];
        
        //設定圓角程度
        [[cell.viewInTableViewCell layer] setCornerRadius:0];
        
        //大頭照圓形遮罩
        cell.wallHeadPhoto.layer.cornerRadius = cell.wallHeadPhoto.frame.size.width / 2;
        cell.wallHeadPhoto.layer.borderWidth = 3.0f;
        cell.wallHeadPhoto.layer.borderColor = [UIColor boyPhotoBorderColor].CGColor;
        cell.wallHeadPhoto.clipsToBounds = YES;

    
    return cell;
    
}


#pragma mark - Load Parse Data

- (void) getdata
{
    //PFRelation *relation = [user relationForKey:@"travelMatePosts"];
    //PFQuery *query = [relation query];
    PFQuery *query = [PFQuery queryWithClassName:@"TravelMatePost"];
    [query includeKey:@"createUser.User"];
    [query orderByDescending:@"createdAt"];
    query.limit = 3;
    
    if(dataCount==nil) {
        dataCount = [[NSNumber alloc] initWithInt:0];
    } else {
        query.skip = [dataCount integerValue];
    }
    
    if(arrayDatas==nil){
        arrayDatas = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    } else {
        [arrayDatas addObjectsFromArray:[query findObjects]];
    }
    
    //每次上拉查詢增加筆數
    dataCount = [NSNumber numberWithInt:[dataCount intValue] + 3];
    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            
//            if(arrayDatas==nil){
//                arrayDatas = [[NSMutableArray alloc] initWithArray:objects];
//            } else {
//                [arrayDatas addObjectsFromArray:objects];
//            }
//            
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    
}

- (void) getNewData {
    
    PFQuery *query = [PFQuery queryWithClassName:@"TravelMatePost"];
    [query includeKey:@"createUser.User"];
    [query orderByDescending:@"createdAt"];
    query.limit = 3;
    
    if(dataCount==nil) {
        dataCount = [[NSNumber alloc] initWithInt:3];
    } else {
        dataCount = [NSNumber numberWithInt:3];
    }
    
    arrayDatas = nil;
    arrayDatas = [[NSMutableArray alloc] initWithArray:[query findObjects]];
}



/*
#pragma mark - UIScrollViewDelegate Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat size = frame.size.height - 21;
    CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (scrollOffset <= -scrollView.contentInset.top) {
        frame.origin.y = 20;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        frame.origin.y = -size;
    } else {
        frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
    }
    
    [self.navigationController.navigationBar setFrame:frame];
    [self updateBarButtonItems:(1 - framePercentageHidden)];
    self.previousScrollViewYOffset = scrollOffset;
    
    //NSLog(@"y=%f, height=%f",frame.origin.y, frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

- (void)stoppedScrolling
{
    CGRect frame = self.navigationController.navigationBar.frame;
    if (frame.origin.y < 20) {
        [self animateNavBarTo:-(frame.size.height - 21)];
    }
}

- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    self.navigationItem.titleView.alpha = alpha;
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)animateNavBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navigationController.navigationBar.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        [self.navigationController.navigationBar setFrame:frame];
        [self updateBarButtonItems:alpha];
    }];
}
*/

@end
