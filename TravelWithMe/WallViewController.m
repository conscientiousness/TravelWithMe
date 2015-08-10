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
//#import "JDFPeekabooCoordinator.h"


@interface WallViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *wallTableView;
//@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;
//@property (nonatomic) CGFloat previousScrollViewYOffset;
@end

@implementation WallViewController
{
    //PFUser *user;
    CGRect originNavFrame;
    NSMutableArray *arrayDatas;
    NSDictionary *dictData;
    NSDateFormatter *cellDateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (!user) {
//        user = [PFUser currentUser];
//        [[PFUser currentUser] fetchIfNeeded];
//    }
    

    //originNavFrame = self.navigationController.navigationBar.frame;
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"讀取中...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [self getdata];
    });
    
    
   
    //NSLog(@"get2 = %ld", arrayDatas.count);
    
    [self initUI];
    _wallTableView.scrollEnabled = YES;
    _wallTableView.delegate = self;
    _wallTableView.dataSource = self;
    
    //self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
      
    UIRefreshControl *refresh = [UIRefreshControl new];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"準備更新資料"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [refresh setBackgroundColor:[UIColor homeCellbgColor]];
    [self.wallTableView addSubview:refresh];
    
    //格式化日期
    cellDateFormatter = [[NSDateFormatter alloc]init];
    [cellDateFormatter setDateFormat:@"yyyy-MM-dd"];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    // nav tabbar 滾動縮放
    //self.scrollCoordinator.scrollView = _wallTableView;
    //self.scrollCoordinator.topView = self.navigationController.navigationBar;
    //self.scrollCoordinator.bottomView = self.tabBarController.tabBar;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    //[self.navigationController.navigationBar setFrame:originNavFrame];
}

//初始化UI畫面
- (void)initUI {
    
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

- (void)refreshView:(UIRefreshControl*)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新中..."];
    
    sleep(2);
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    [formatter setDateFormat:@"MM/dd,a h:mm "];
    
    NSString *lastUpdated = [NSString stringWithFormat:@"最後更新時間: %@",[formatter stringFromDate:[NSDate date]]];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}


- (void)postBtnPressed:(id *)sender {
    
    //NSLog(@"current= %@",currentUser);
    UIViewController *targetViewController;
    UIStoryboard *storyboard;
    
    if([FBSDKAccessToken currentAccessToken]) {
        
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
    
    NSString *identifier =@"wallTableViewCell";
    
    UITableViewCell *cell = [self prepareTableViewCell:tableView cellForRowAtIndexPath:indexPath cellIdentifier:identifier];
    [self setCellData:(WallTableViewCell *)cell cellForRowAtIndexPath:indexPath];
    

    return cell;
}


- (void) setCellData:(WallTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSArray *cuser = [[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"createUser"];
    
    //NSLog(@"objectId= %@",((PFObject *)arrayDatas[indexPath.row]).objectId);
    
    //名字
    cell.userNameLabel.text = arrayDatas[indexPath.row][@"createUser"][@"displayName"];
    
    //大頭照
    //PFFile *proFilePicture = [[[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"createUser"] objectForKey:@"profilePictureMedium"];
    
    //[user objectForKey:kPAPUserProfilePicSmallKey];
    [cell.wallHeadPhoto sd_setImageWithURL:(NSURL*)((PFFile*)arrayDatas[indexPath.row][@"createUser"][@"profilePictureMedium"]).url placeholderImage:[UIImage imageNamed:@"pic1.jpg"]];
        
    //國家城市
    cell.countryCityLabel.text = [[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"countryCity"];
    
    //出發日期
    NSString *strDate = [cellDateFormatter stringFromDate:[[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"startDate"]];
    cell.travelDateLabel.text = strDate;
    
    //地點標籤
    cell.locationTagLabel.text = [[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"locationTag"];
    
    //備註
    cell.memoLabel.text = [[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"memo"];
    
    //照片
    PFFile *photo = (PFFile *)[[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"photo"];
    [cell.cellImageView sd_setImageWithURL:(NSURL*)photo.url placeholderImage:[UIImage imageNamed:@"tmp900X640.png"]];
    
 
    //NSLog(@"%ld => %@",indexPath.row,[[arrayDatas objectAtIndex:indexPath.row] objectForKey:@"createUser"]);
}

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
        
        
        //字體粗細大小
        cell.locationTagLabel.font = [UIFont systemFontOfSize:11];
        //文字顏色
        cell.locationTagLabel.textColor = [UIColor colorWithRed:0.373 green:0.710 blue:0.647 alpha:1.000];
        //背景色
        cell.locationTagLabel.backgroundColor = [UIColor clearColor];
        /*/Lable邊框
         cell.testAreaLabel.layer.borderColor = [UIColor colorWithRed:0.373 green:0.710 blue:0.647 alpha:1.000].CGColor;
         cell.testAreaLabel.layer.borderWidth = 0.5;
         cell.testAreaLabel.layer.cornerRadius = 3;
         //文字在Label置中
         cell.testAreaLabel.textAlignment = NSTextAlignmentCenter;
         //文字自動適應Lable大小
         cell.testAreaLabel.adjustsFontSizeToFitWidth = NO;
         */
        
        cell.viewBlock1.backgroundColor = [UIColor whiteColor];
        cell.viewBlock2.backgroundColor = [UIColor whiteColor];
        cell.viewBlock3.backgroundColor = [UIColor whiteColor];

    
    //UIImage *cellImage = [UIImage imageNamed: @"monkey1080X1080.jpg"];
    //[cell.cellImageView setImage:cellImage];

    
    /*/====Add Image View====
    CGFloat viewInCellWidth = cell.viewInTableViewCell.frame.width;
    CGFloat viewInCellHeight = cell.contentView.frame.size.height;
    
    NSLog(@"viewInCellWidth= %f, viewInCellHeight= %f , index = %ld",viewInCellWidth,viewInCellHeight,(long)indexPath.row);
    
    
    // 初始化
    UIImageView *dyImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0,cell.viewBlock2.frame.origin.y + cell.viewBlock2.frame.size.height ,320,240)];
    //320  橫：240  直：426.666666
    
    // 圖片檔案引入UIImage物件(需要先將圖片加入專案中)
    // initWithNamed:@"cropped-Logo"]];
    UIImage *dyImage = [UIImage imageNamed:@"iphone_h_photo.jpg"];
    dyImageView.contentMode = UIViewContentModeTop;
    dyImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    // 圖片影像物件指定至UIImageView之影象
    dyImageView.image = dyImage;
    dyImageView.backgroundColor =[UIColor redColor];
    
    
    // UIImageView加入主要View中
    //[cell.viewInTableViewCell addSubview:dyImageView];
    
    //NSLog(@"%@",cell.viewInTableViewCell.subviews);
    */
    
    return cell;
    
}


/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat result;
    result = 492.0;
 
    
    return result;
}*/




//當選擇某一列Cell要做的的動作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //跳轉到HomePostViewController
    NSString *identifier = @"detailMessageViewController";
    
    HomePostViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    //傳值
    dictData = [NSDictionary new];
    dictData = @{@"displayName":arrayDatas[indexPath.row][@"createUser"][@"displayName"],
                 @"profilePictureMedium":arrayDatas[indexPath.row][@"createUser"][@"profilePictureMedium"],
                 @"countryCity":arrayDatas[indexPath.row][@"countryCity"],
                 @"photo":arrayDatas[indexPath.row][@"photo"],
                 @"locationTag":arrayDatas[indexPath.row][@"locationTag"],
                 @"memo":arrayDatas[indexPath.row][@"memo"],
                 @"startDate":[cellDateFormatter stringFromDate:arrayDatas[indexPath.row][@"startDate"]],
                 @"tableViewWidth":@(_wallTableView.frame.size.width),
                 @"objectId":((PFObject *)arrayDatas[indexPath.row]).objectId
                 };
    
    [detailVC setValue:dictData forKey:@"cellDictData"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    CGRect frame = self.navigationController.navigationBar.frame;
//    frame.origin.y = 20.0;
//    [self.navigationController.navigationBar setFrame:frame];
//}



#pragma mark - Get Data

- (void) getdata
{
    //PFRelation *relation = [user relationForKey:@"travelMatePosts"];
    //PFQuery *query = [relation query];
    PFQuery *query = [PFQuery queryWithClassName:@"TravelMatePost"];
    [query includeKey:@"createUser.User"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            //NSLog(@"Successfully = %ld", objects.count);
            //NSLog(@"objects = %@", objects);
            // Do something with the found objects
            arrayDatas = [[NSMutableArray alloc] initWithArray:objects];
            
            //arrayDatas = [NSMutableArray new];
            //dictData = [NSMutableDictionary new];
            
//            for (PFObject *object in objects) {
//                [arrayDatas addObject:dictData[@{@"key":object}]];
//            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_wallTableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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
